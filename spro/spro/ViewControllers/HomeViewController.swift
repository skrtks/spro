//
//  ViewController.swift
//  spro
//
//  Created by Sam Kortekaas on 11/01/2018.
//  Copyright © 2018 Kortekaas. All rights reserved.
//

import UIKit
import CoreLocation


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var HomeTable: UITableView!
    
    // MARK: Properties
    var venueList = [JSON]()
    var photoSuffix: String!
    var barImageList = [UIImage]()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up location services
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        getCurrentLocation()
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
    
    // Get the current location of the user
    func getCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            showLocationAlert()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Request the current location
        if currentLocation == nil {
            currentLocation = locationManager.location?.coordinate
            locationManager.stopUpdatingLocation()
        }
        
        // Request data from API
        if let currentLocation = currentLocation {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            RequestController.shared.getCoffeeBars(lat: currentLocation.latitude, lon: currentLocation.longitude) { (coffeeBars) in
                self.venueList = coffeeBars
                DispatchQueue.main.async {
                    self.updateUI()
                }
            }
        }
    }
    
    func showLocationAlert() {
        let alert = UIAlertController(title: "spro", message: "Please enable location services for 'spro'", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
    
    
    // Prepare for segue to detail view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            let detailViewController = segue.destination as! DetailViewController
            let indexPath = HomeTable.indexPathForSelectedRow!.row

            // Pass along venue and location information.
            detailViewController.venueId = venueList[indexPath]["venue"]["id"].stringValue
            detailViewController.currentLocation = currentLocation
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
        
        cell.nameLabel.text = venueList[indexPath.row]["venue"]["name"].stringValue
        cell.ratingLabel.text = String(venueList[indexPath.row]["venue"]["rating"].doubleValue)
        
        // set required CLLocations
        let VenueLat = venueList[indexPath.row]["venue"]["location"]["lat"].doubleValue
        let VenueLon = venueList[indexPath.row]["venue"]["location"]["lng"].doubleValue
        let VenueLocation = CLLocation(latitude: VenueLat, longitude: VenueLon)
        let myLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        //Measuring distance from my location to venue
        cell.distanceLabel.text = String(Int(myLocation.distance(from: VenueLocation))) + " meters"
        
        
        let suffix = venueList[indexPath.row]["photo"]["suffix"].stringValue
        RequestController.shared.getImage(suffix: suffix) { (barImage) in
            DispatchQueue.main.async {
                cell.barImageView.image = barImage
            }
        }
        
        return cell
    }
}
