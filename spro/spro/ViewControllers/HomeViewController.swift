//
//  ViewController.swift
//  spro
//
//  Provides the infrastructure for loading and managing interactions with the home screen.
//
//  Created by Sam Kortekaas on 11/01/2018.
//  Student ID: 10718095
//  Copyright © 2018 Kortekaas. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UITextFieldDelegate, MKLocalSearchCompleterDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var resultsTable: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var suggestionsTable: UITableView!
    
    // MARK: Properties
    var venueList = [JSON]()
    var photoSuffix: String!
    var barImageList = [UIImage]()
    let locationManager = CLLocationManager()
    let searchCompleter = MKLocalSearchCompleter()
    var currentLocation: CLLocation!
    var searchSuggestions = [MKLocalSearchCompletion]()
    
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        // Set delegates
        searchField.delegate = self
        suggestionsTable.delegate = self
        searchCompleter.delegate = self
        
        // Make sure suggestions are locations only
        searchCompleter.filterType = .locationsOnly
        
        // Set up location services
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // Make the table view transparent for animation
        resultsTable.alpha = 0
        
        // Get current location and request API data
        activityIndicator.isHidden = false
        getCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set the navigation bar style
        self.navigationController?.navigationBar.barStyle = .default
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Deselect the selected row
        let indexPath = resultsTable.indexPathForSelectedRow
        if let indexPath = indexPath {
            self.resultsTable.deselectRow(at: indexPath, animated: true)
        }
    }

    func updateUI() {
        // Make the nav bar transparent from https://stackoverflow.com/questions/19082963/how-to-make-completely-transparent-navigation-bar-in-ios-7#19323215
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        // Style the suggestions table
        suggestionsTable.alpha = 0
        suggestionsTable.layer.masksToBounds = true
        suggestionsTable.layer.cornerRadius = 4
        
        // Add shadows
        addShadow(object: resultsTable)
        
        // Hide suggestions
        suggestionsTable.isHidden = true
    
        // Reload table data
        self.resultsTable.reloadData()
        
        // Hide activity indicators
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        activityIndicator.isHidden = true
        
        // Animate appearance of the table
        UIView.animate(withDuration: 0.5) {
            self.resultsTable.alpha = 1
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
            locationManager.requestLocation()
        } else {
            showAlert(title: "Spro", message: "Please enable location services for Spro")
        }
    }
    
    // Manage the delivere of location related events
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Request the current location
        currentLocation = locationManager.location
        
        if let currentLocation = currentLocation {
            // Show activity indicators
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            activityIndicator.isHidden = false
            
            // Request data from API with current location
            RequestController.shared.getCoffeeBars(lat: currentLocation.coordinate.latitude, lon: currentLocation.coordinate.longitude) { (coffeeBars) in
                self.venueList = coffeeBars
                DispatchQueue.main.async {
                    self.updateUI()
                }
            }
        }
    }
    
    // Show error when reported
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(title: "Spro", message: "Something went wrong: \(error.localizedDescription)")
    }
    
    // Show a alert about location services
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
    
    // Hide the keyboard when touching oustide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // When return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        performSegue(withIdentifier: "SearchSegue", sender: nil)
        return true
    }
    
    // Prepare for segue to detail view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            let detailViewController = segue.destination as! DetailViewController
            let indexPath = resultsTable.indexPathForSelectedRow!.row

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
        // Update the query fragment and request results
        searchCompleter.queryFragment = searchField.text!
        searchSuggestions = searchCompleter.results
        
        // Animate appearance of suggestions
        UIView.animate(withDuration: 0.2, delay: 0.5, animations: {
            self.suggestionsTable.isHidden = false
            self.suggestionsTable.alpha = 1
        })
    }
    
    @IBAction func searchFieldEnded(_ sender: Any) {
        // Animate dissapearing of suggestions
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.suggestionsTable.alpha = 0
        }, completion: { _ in
            self.suggestionsTable.isHidden = true
        })
        
        // Stop the suggestions request
        searchCompleter.cancel()
    }
    
    @IBAction func refreshButtonTouched(_ sender: Any) {
        // Get fresh data for current location
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        getCurrentLocation()
    }
    
    // MARK: Tableview
    
    // Set the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set the number of rows.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == resultsTable {
            return venueList.count
        } else {
            return searchSuggestions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == resultsTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeTableViewCell
            cell.barImageView.layer.cornerRadius = 8
            cell.nameLabel.text = venueList[indexPath.row]["venue"]["name"].stringValue
            cell.ratingLabel.text = String(venueList[indexPath.row]["venue"]["rating"].doubleValue)
            
            // Style the rating label and set label color
            cell.ratingLabel.layer.cornerRadius = 5
            let alpha = "ff"
            let color = UIColor(hexString: "#" + venueList[indexPath.row]["venue"]["ratingColor"].stringValue + alpha)
            cell.ratingLabel.backgroundColor = color
            
            // set required CLLocations for calculating distance
            let venueLat = venueList[indexPath.row]["venue"]["location"]["lat"].doubleValue
            let venueLon = venueList[indexPath.row]["venue"]["location"]["lng"].doubleValue
            let venueLocation = CLLocation(latitude: venueLat, longitude: venueLon)
            
            // Measuring distance from my location to venue
            cell.distanceLabel.text = String(Int(currentLocation.distance(from: venueLocation))) + " meters"
            
            // Get the photo from Foursquare
            let suffix = venueList[indexPath.row]["photo"]["suffix"].stringValue
            RequestController.shared.getImage(suffix: suffix) { (barImage) in
                DispatchQueue.main.async {
                    cell.barImageView.image = barImage
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
            
            cell.textLabel?.text = searchSuggestions[indexPath.row].title
            cell.detailTextLabel?.text = searchSuggestions[indexPath.row].subtitle
            return cell
        }
    }
    
    // Use completion to fill searchField
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == suggestionsTable {
            searchField.text = searchSuggestions[indexPath.row].title + ", " + searchSuggestions[indexPath.row].subtitle
            
            performSegue(withIdentifier: "SearchSegue", sender: nil)
        }
    }
}

// Exstension for updating the table view when completion is updated, from: https://stackoverflow.com/questions/41136150/swift-mapkit-autocomplete#41150928
extension HomeViewController {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchSuggestions = completer.results
        suggestionsTable.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
        print(error.localizedDescription)
    }
}
