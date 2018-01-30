//
//  DetailViewController.swift
//  spro
//
//  Provides the infrastructure for loading and managing interactions with the detail screen.
//
//  Created by Sam Kortekaas on 11/01/2018.
//  Student ID: 10718095
//  Copyright © 2018 Kortekaas. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imageShadowView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var reviewTable: UITableView!
    @IBOutlet weak var directionsButton: UIButton!
    
    // MARK: Properties
    var venueId: String!
    var image: UIImage!
    var venueDetails = [String: JSON]()
    var venueReviews = [JSON]()
    var venueLocation: CLLocation!
    var currentLocation: CLLocation!
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide UIViews for animation
        setAlpha(value: 0)
        
        // Disable button to prevent tapping before all data is loaded
        directionsButton.isEnabled = false
        
        // Disable distance to venue if current location is not provided
        if currentLocation == nil {
            distanceLabel.isHidden = true
        }
        
        getReviews()
        getDetails()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barStyle = .black
        
        // Make back button white
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func updateUI() {
        // set required CLLocations for CL Distance
        let venueLat = self.venueDetails["venue"]!["location"]["lat"].doubleValue
        let venueLon = self.venueDetails["venue"]!["location"]["lng"].doubleValue
        calculateDistance(lat: venueLat, lon: venueLon)
        setLabels()
        addShadow(object: cardView)
        directionsButton.isEnabled = true
        self.reviewTable.reloadData()
        
        // Set and style the venue image
        if let image = image {
            venueImage.image = image
        }
        venueImage.layer.borderWidth = 4
        venueImage.layer.borderColor = UIColor.white.cgColor
        addShadow(object: imageShadowView)
        
    }
    
    /// Sets the alpha value for a number of UIViews
    func setAlpha(value: CGFloat) {
        // Hide UIViews for animation
        nameLabel.alpha = value
        distanceLabel.alpha = value
        ratingLabel.alpha = value
        adressLabel.alpha = value
        hoursLabel.alpha = value
        reviewTable.alpha = value
        directionsButton.alpha = value
        venueImage.alpha = value
        imageShadowView.alpha = value
    }
    
    /// Adds shadow to a UIView
    func addShadow(object: UIView) {
        // Style shadow
        object.layer.masksToBounds = false
        object.layer.shadowOpacity = 0.2
        object.layer.shadowColor = UIColor.black.cgColor
        object.layer.shadowRadius = 4
        object.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    /// Update the labels with available information
    func setLabels() {
        // Set labels
        self.nameLabel.text = self.venueDetails["venue"]!["name"].stringValue
        
        // Check if info is provided
        if String(self.venueDetails["venue"]!["rating"].doubleValue) != "" {
            self.ratingLabel.text = String(self.venueDetails["venue"]!["rating"].doubleValue)
            
            // Style the rating label and set label color
            self.ratingLabel.layer.cornerRadius = 5
            let alpha = "ff"
            let color = UIColor(hexString: "#" + venueDetails["venue"]!["ratingColor"].stringValue + alpha)
            self.ratingLabel.backgroundColor = color
        } else {
            self.ratingLabel.text = "No rating"
        }
        
        if self.venueDetails["venue"]!["location"]["address"].stringValue != "" {
            self.adressLabel.text = self.venueDetails["venue"]!["location"]["address"].stringValue
        } else {
            self.hoursLabel.text = "Address unavailable"
        }
        
        if self.venueDetails["venue"]!["hours"]["status"].stringValue != "" {
            self.hoursLabel.text = self.venueDetails["venue"]!["hours"]["status"].stringValue
        } else {
            self.hoursLabel.text = "Hours unavailable"
        }
        
        // Show the labels
        UIView.animate(withDuration: 0.5) {
            self.setAlpha(value: 1)
        }
    }
    
    /// Request reviews from Foursquare
    func getReviews() {
        RequestController.shared.getReviews(venueId: self.venueId, completion: { (reviews) in
            self.venueReviews = reviews
            
            DispatchQueue.main.async {
                self.reviewTable.reloadData()
            }
        })
    }
    
    /// Get venue details and image from Foursquare
    func getDetails() {
        RequestController.shared.getDetails(venueId: venueId) { (details) in
            self.venueDetails = details
            
            let suffix = self.venueDetails["venue"]!["photos"]["groups"][0]["items"][0]["suffix"].stringValue
            RequestController.shared.getImage(suffix: suffix, completion: { (image) in
                self.image = image
                // Update UI on main queue (for loading image on slow networks)
                DispatchQueue.main.async {
                    self.updateUI()
                }
            })
            
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    /**
    Calculate the distance between two locations
    - Parameter lat: The latitude
    - Parameter lon: The longitude
    */
    func calculateDistance(lat: Double, lon: Double) {
        venueLocation = CLLocation(latitude: lat, longitude: lon)
        
        //Measuring distance from current location to venue
        if let currentLocation = currentLocation {
            self.distanceLabel.text = String(Int(currentLocation.distance(from: venueLocation))) + " meters"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMap" {
            let mapViewController = segue.destination as! MapViewController
            mapViewController.venueLocation = venueLocation
            mapViewController.currentLocation = currentLocation
            mapViewController.venueName = venueDetails["venue"]!["name"].stringValue
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueReviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewTableViewCell
        cell.nameLabel.text = venueReviews[indexPath.row]["user"]["firstName"].stringValue
        cell.bodyLabel.text = venueReviews[indexPath.row]["text"].stringValue

        return cell
    }
}
