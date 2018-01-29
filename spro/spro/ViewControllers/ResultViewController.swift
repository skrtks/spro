//
//  ResultViewController.swift
//  spro
//
//  Provides the infrastructure for loading and managing interactions with the result screen.
//
//  Created by Sam Kortekaas on 23/01/2018.
//  Student ID: 10718095
//  Copyright © 2018 Kortekaas. All rights reserved.
//

import UIKit
import CoreLocation

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    @IBOutlet var resultsTable: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    
    // MARK: Properties
    var venueList = [JSON]()
    var searchQuery: String!
    
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make the table view transparent for animation
        resultsTable.alpha = 0
        
        getCoordinates() { (locationData) in
            // Show activity indicator
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            if let name = locationData?.name {
                self.locationLabel.text = name
            }
            // Use coordinates to call Foursquare API
            if let coordinates = locationData?.location?.coordinate {
                let lat = coordinates.latitude
                let lon = coordinates.longitude
                RequestController.shared.getCoffeeBars(lat: lat, lon: lon) { (coffeeBars) in
                    self.venueList = coffeeBars
                    DispatchQueue.main.async {
                        self.updateUI()
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barStyle = .default
        
        // Make back button white
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1813119948, green: 0.2569544911, blue: 0.3566510081, alpha: 1)
    }
    
    func updateUI() {
        // Reload table data
        self.resultsTable.reloadData()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // Animate appearance of the table
        UIView.animate(withDuration: 0.5) {
            self.resultsTable.alpha = 1
        }
    }
    
    // Create  CLPlacemark from a address string
    func getCoordinates(completion: @escaping (CLPlacemark?) -> Void) {
        // Get the coordinates for address
        let geocoder = CLGeocoder()
        var placemark: CLPlacemark?
        geocoder.geocodeAddressString(searchQuery) { placemarks, error in
            if let placemarks = placemarks {
                placemark = placemarks[0]
                completion(placemark)
            } else if error != nil {
                self.showAlert(title: "Error", message: "Provided location could not be processed.")
                completion(nil)
            } else {
                completion(nil)
            }
        }
    }
    
    // Show alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
    
    // Prepare for segue to detail view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            let detailViewController = segue.destination as! DetailViewController
            let indexPath = resultsTable.indexPathForSelectedRow!.row
            
            // Pass along venue and location information.
            detailViewController.venueId = venueList[indexPath]["venue"]["id"].stringValue
        }
    }
    
    // MARK: Table view data source
    
    // Set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueList.count
    }

    // Generate the table cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath) as! ResultsTableViewCell
        
        // Set labels
        cell.barImageView.layer.cornerRadius = 8
        cell.nameLabel.text = venueList[indexPath.row]["venue"]["name"].stringValue
        cell.ratingLabel.text = String(venueList[indexPath.row]["venue"]["rating"].doubleValue)
        cell.addressLabel.text = venueList[indexPath.row]["venue"]["location"]["address"].stringValue
        
        // Style the rating label and set label color
        cell.ratingLabel.layer.cornerRadius = 5
        let alpha = "ff"
        let color = UIColor(hexString: "#" + venueList[indexPath.row]["venue"]["ratingColor"].stringValue + alpha)
        cell.ratingLabel.backgroundColor = color
        
        // Load and set image
        let suffix = venueList[indexPath.row]["photo"]["suffix"].stringValue
        RequestController.shared.getImage(suffix: suffix) { (barImage) in
            DispatchQueue.main.async {
                cell.barImageView.image = barImage
            }
        }
        
        return cell
    }

}
