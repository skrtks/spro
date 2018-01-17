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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    var venueList = [JSON]()
    var photoSuffix: String!
    var barImageList = [UIImage]()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
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
        // Make the nav bar transparent from https://stackoverflow.com/questions/19082963/how-to-make-completely-transparent-navigation-bar-in-ios-7#19323215
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        addShadow(object: HomeTable)
    
        // Reload table data
        self.HomeTable.reloadData()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        activityIndicator.isHidden = true
    }
    
    func addShadow(object: UIView) {
        // Style shadow
        object.layer.masksToBounds = false
        object.layer.shadowOpacity = 0.2
        object.layer.shadowColor = UIColor.black.cgColor
        object.layer.shadowRadius = 4
        object.layer.shadowOffset = CGSize(width: 0, height: 2)
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
            currentLocation = locationManager.location
            locationManager.stopUpdatingLocation()
        }
        
        // Request data from API
        if let currentLocation = currentLocation {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            RequestController.shared.getCoffeeBars(lat: currentLocation.coordinate.latitude, lon: currentLocation.coordinate.longitude) { (coffeeBars) in
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
        let venueLat = venueList[indexPath.row]["venue"]["location"]["lat"].doubleValue
        let venueLon = venueList[indexPath.row]["venue"]["location"]["lng"].doubleValue
        let venueLocation = CLLocation(latitude: venueLat, longitude: venueLon)
        
        //Measuring distance from my location to venue
        cell.distanceLabel.text = String(Int(currentLocation.distance(from: venueLocation))) + " meters"
        
        
        let suffix = venueList[indexPath.row]["photo"]["suffix"].stringValue
        RequestController.shared.getImage(suffix: suffix) { (barImage) in
            DispatchQueue.main.async {
                cell.barImageView.image = barImage
            }
        }
        
        return cell
    }
}
