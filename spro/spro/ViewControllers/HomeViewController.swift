//
//  ViewController.swift
//  spro
//
//  Created by Sam Kortekaas on 11/01/2018.
//  Copyright © 2018 Kortekaas. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    @IBOutlet weak var HomeTable: UITableView!
    
    // MARK: Properties
    var venueList = [JSON]()
    var photoSuffix: String!
    var barImageList = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        RequestController.shared.getCoffeeBars { (coffeeBars) in
            self.venueList = coffeeBars
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let indexPath = HomeTable.indexPathForSelectedRow
        if let indexPath = indexPath {
            self.HomeTable.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func updateUI() {
        self.HomeTable.reloadData()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // Prepare for segue to detail view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            let detailViewController = segue.destination as! DetailViewController
            let indexPath = HomeTable.indexPathForSelectedRow!.row

            // Pass along venue information.
            detailViewController.venueId = venueList[indexPath]["venue"]["id"].string
        }
    }
    
    // Set the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set the number of rows.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeTableViewCell
        
        cell.nameLabel.text = venueList[indexPath.row]["venue"]["name"].string
        cell.ratingLabel.text = String(venueList[indexPath.row]["venue"]["rating"].doubleValue)
        
        let suffix = venueList[indexPath.row]["photo"]["suffix"].string
        RequestController.shared.getImage(suffix: suffix!) { (barImage) in
            DispatchQueue.main.async {
                cell.barImageView.image = barImage
            }
        }
        
        return cell
    }
}

