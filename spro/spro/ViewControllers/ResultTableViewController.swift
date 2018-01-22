//
//  ResultTableViewController.swift
//  spro
//
//  Created by Sam Kortekaas on 11/01/2018.
//  Copyright © 2018 Kortekaas. All rights reserved.
//

import UIKit
import CoreLocation

class ResultTableViewController: UITableViewController {
    
    // MARK: Properties
    var lon: Double!
    var lat: Double!
    var venueList = [JSON]()
    var locationData: CLPlacemark!
    
    // MARK: Outlets
    @IBOutlet var resultsTable: UITableView!
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        RequestController.shared.getCoffeeBars(lat: lat, lon: lon) { (coffeeBars) in
            self.venueList = coffeeBars
            DispatchQueue.main.async {
                self.updateUI()
            }
        
        }
    }
        
    func updateUI() {
        // Reload table data
        self.resultsTable.reloadData()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueList.count
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath) as! ResultsTableViewCell
        
        cell.nameLabel.text = venueList[indexPath.row]["venue"]["name"].stringValue
        cell.ratingLabel.text = String(venueList[indexPath.row]["venue"]["rating"].doubleValue)
        
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
