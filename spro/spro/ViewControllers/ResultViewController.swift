//
//  ResultViewController.swift
//  spro
//
//  Created by Sam Kortekaas on 23/01/2018.
//  Copyright © 2018 Kortekaas. All rights reserved.
//

import UIKit
import CoreLocation

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    var venueList = [JSON]()
    var searchQuery: String!
    
    // MARK: Outlets
    @IBOutlet var resultsTable: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        print("query = \(searchQuery)")
        getCoordinates() { (locationData) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            if let name = locationData?.name {
                print(name)
                self.locationLabel.text = name
            }
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
        self.navigationController?.navigationBar.barStyle = .black
        
        // Make back button white
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func updateUI() {
        // Reload table data
        self.resultsTable.reloadData()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func getCoordinates(completion: @escaping (CLPlacemark?) -> Void) {
        // Get the coordinates for address
        let geocoder = CLGeocoder()
        var placemark: CLPlacemark?
        geocoder.geocodeAddressString(searchQuery) { placemarks, error in
            if let placemarks = placemarks {
                placemark = placemarks[0]
                completion(placemark)
            } else {
                completion(nil)
            }
        }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueList.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath) as! ResultsTableViewCell
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
