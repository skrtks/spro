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
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    var venueList = [JSON]()
    var photoSuffix: String!
    var barImageList = [UIImage]()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        // Disable/enable the search button
        updateSearchButton()
        
        // Set up location services
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // Get current location and request API data
        getCurrentLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Deselect the selected row
        let indexPath = HomeTable.indexPathForSelectedRow
        if let indexPath = indexPath {
            self.HomeTable.deselectRow(at: indexPath, animated: true)
        }
        
        // Get fresh data for current location
        getCurrentLocation()
    }
    
    func updateUI() {
        // Make the nav bar transparent from https://stackoverflow.com/questions/19082963/how-to-make-completely-transparent-navigation-bar-in-ios-7#19323215
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = .black
        
        addShadow(object: HomeTable)
    
        // Reload table data
        self.HomeTable.reloadData()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        activityIndicator.isHidden = true
    }
    
    // Update state of search button
    func updateSearchButton() {
        
        // Disable search button if search field is empty
        if searchField.text == "" {
            searchButton.isEnabled = false
        } else {
            searchButton.isEnabled = true
        }
    }
    
    // Adds dropshadow to a UIView
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
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
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
        
        // Request data from API with current location
        if let currentLocation = currentLocation {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            activityIndicator.isHidden = false
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
            
        } else if segue.identifier == "SearchSegue" {
            let resultViewController = segue.destination as! ResultViewController
            resultViewController.searchQuery = searchField.text
        }
    }
    
    // MARK: Actions
    @IBAction func searchFieldChanged(_ sender: Any) {
        updateSearchButton()
    }
    
    @IBAction func refreshButtonTouched(_ sender: Any) {
        // Get fresh data for current location
        getCurrentLocation()
    }
    
    // MARK: Tableview
    
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
        
        // Style the rating label and set label color
        cell.ratingLabel.layer.cornerRadius = 5
        let alpha = "ff"
        let color = UIColor(hexString: "#" + venueList[indexPath.row]["venue"]["ratingColor"].stringValue + alpha)
        cell.ratingLabel.backgroundColor = color
        
        // set required CLLocations
        let venueLat = venueList[indexPath.row]["venue"]["location"]["lat"].doubleValue
        let venueLon = venueList[indexPath.row]["venue"]["location"]["lng"].doubleValue
        let venueLocation = CLLocation(latitude: venueLat, longitude: venueLon)
        
        // Measuring distance from my location to venue
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
