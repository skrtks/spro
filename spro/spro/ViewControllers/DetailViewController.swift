//
//  DetailViewController.swift
//  spro
//
//  Created by Sam Kortekaas on 11/01/2018.
//  Copyright © 2018 Kortekaas. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var reviewTable: UITableView!
    @IBOutlet weak var directionsButton: UIButton!
    
    var venueId: String!
    var image: UIImage!
    var venueDetails = [String: JSON]()
    var venueReviews = [JSON]()
    var venueLocation: CLLocation!
    var currentLocation: CLLocation!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Disable button to prevent tapping before all data is loaded
        directionsButton.isEnabled = false
        
        // Disable some functions if current location is missing
        if currentLocation == nil {
            directionsButton.isHidden = true
            distanceLabel.isHidden = true
        }
        
        RequestController.shared.getReviews(venueID: self.venueId, completion: { (reviews) in
            self.venueReviews = reviews
            
            DispatchQueue.main.async {
                self.reviewTable.reloadData()
            }
        })
        
        RequestController.shared.getDetails(venueId: venueId) { (details) in
            self.venueDetails = details
            
            let suffix = self.venueDetails["venue"]!["photos"]["groups"][0]["items"][0]["suffix"].stringValue
            RequestController.shared.getImage(suffix: suffix, completion: { (image) in
                self.image = image
                
                DispatchQueue.main.async {
                    self.updateUI()
                }
            })
            
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barStyle = .black
        
        // Make back button white
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func updateUI() {
        // Set labels
        self.nameLabel.text = self.venueDetails["venue"]!["name"].stringValue
        self.ratingLabel.text = String(self.venueDetails["venue"]!["rating"].doubleValue)
        self.adressLabel.text = self.venueDetails["venue"]!["location"]["address"].stringValue
        self.hoursLabel.text = self.venueDetails["venue"]!["hours"]["status"].stringValue
        
        // Style the rating label and set label color
        self.ratingLabel.layer.cornerRadius = 5
        let alpha = "ff"
        let color = UIColor(hexString: "#" + venueDetails["venue"]!["ratingColor"].stringValue + alpha)
        self.ratingLabel.backgroundColor = color
        
        // set required CLLocations for CL Distance
        let venueLat = self.venueDetails["venue"]!["location"]["lat"].doubleValue
        let venueLon = self.venueDetails["venue"]!["location"]["lng"].doubleValue
        venueLocation = CLLocation(latitude: venueLat, longitude: venueLon)
        
        //Measuring distance from my location to venue
        if let currentLocation = currentLocation {
            self.distanceLabel.text = String(Int(currentLocation.distance(from: venueLocation))) + " meters"
        }
        
        // Set the image
        if let image = image {
            venueImage.image = image
        }
        
        // Configure the background card
        cardView.layer.cornerRadius = 8
        addShadow(object: cardView)
        
        // Enable the button
        directionsButton.isEnabled = true
        
        // Update table data
        self.reviewTable.reloadData()
    }
    
    func addShadow(object: UIView) {
        // Style shadow
        object.layer.masksToBounds = false
        object.layer.shadowOpacity = 0.2
        object.layer.shadowColor = UIColor.black.cgColor
        object.layer.shadowRadius = 4
        object.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    // Prepare for segue to map view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMap" {
            let mapViewController = segue.destination as! MapViewController
            mapViewController.venueLocation = venueLocation
            mapViewController.currentLocation = currentLocation
            mapViewController.venueName = venueDetails["venue"]!["name"].stringValue
        }
    }
    
    // Set the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Set the number of rows.
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
