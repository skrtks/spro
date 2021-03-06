//
//  MapViewController.swift
//  spro
//
//  Provides the infrastructure for loading and managing interactions with the map screen.
//
//  Created by Sam Kortekaas on 11/01/2018.
//  Student ID: 10718095
//  Copyright © 2018 Kortekaas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var directionsButton: UIButton!
    
    // MARK: Properties
    var currentLocation: CLLocation!
    var venueLocation: CLLocation!
    var venueName: String!
    let locationManager = CLLocationManager()
    var destinationMapItem: MKMapItem!

    // MARK: Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barStyle = .default
        
        // Make back button blue
        self.navigationController?.navigationBar.tintColor = self.view.tintColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Center the map and calculate route if current location is available
        if currentLocation != nil {
            getRoute()
            centerMapOnLocation(location: currentLocation)
        } else {
            centerMapOnLocation(location: venueLocation)
        }
        
        
        // Add annotations for venue on map
        let venueAnnotation = VenueAnnotation(title: venueName, coordinate: CLLocationCoordinate2D(latitude: venueLocation.coordinate.latitude, longitude: venueLocation.coordinate.longitude))
        mapView.addAnnotation(venueAnnotation)
        
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    func updateUI() {
        // Style directions button
        directionsButton.backgroundColor = UIColor.white
        directionsButton.layer.cornerRadius = 8
        addShadow(object: directionsButton)
    }
    
    /// Add shadow to a UIView
    func addShadow(object: UIView) {
        object.layer.masksToBounds = false
        object.layer.shadowOpacity = 0.2
        object.layer.shadowColor = UIColor.black.cgColor
        object.layer.shadowRadius = 4
        object.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    /// Set current location indicator if allowed (from https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started)
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    /// Zoom and center the map (from https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started)
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        // make MKCoordinateRegion from the specified coordinate and distance
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /// Sets MapItems and requests route using MKDirections (from https://www.ioscreator.com/tutorials/draw-route-mapkit-tutorial)
    func getRoute() {
        // Get MKMapItem for locations
        let sourcePlacemark = MKPlacemark(coordinate: currentLocation.coordinate, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationPlacemark = MKPlacemark(coordinate: venueLocation.coordinate, addressDictionary: nil)
        destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // Request route information (from https://stackoverflow.com/questions/28723490/display-route-on-map-in-swift)
        let request: MKDirectionsRequest = MKDirectionsRequest()
        
        // Set start, destination, and transport type
        request.source = sourceMapItem
        request.destination = destinationMapItem
        request.transportType = .walking
        
        let route = MKDirections(request: request)
        
        // Calculate the route
        route.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print(error.localizedDescription)
                }
                
            return
            }
            
            // Use the first route
            let route = response.routes[0]
            
            // Add the route to the map
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
        }
    
    }
    
    /// Render the polyline
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = self.view.tintColor
        renderer.lineWidth = 4
        
        return renderer
    }
    
    // MARK: Actions
    @IBAction func directionsButtonTapped(_ sender: Any) {
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        if let destinationMapItem = destinationMapItem {
            destinationMapItem.name = venueName
        } else {
            let destinationPlacemark = MKPlacemark(coordinate: venueLocation.coordinate, addressDictionary: nil)
            destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            destinationMapItem.name = venueName
        }
        
        destinationMapItem.openInMaps(launchOptions: launchOptions)
    }
    
}

