//
//  MapViewController.swift
//  spro
//
//  Created by Sam Kortekaas on 11/01/2018.
//  Copyright © 2018 Kortekaas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var directionsButton: UIButton!
    
    var currentLocation: CLLocation!
    var venueLocation: CLLocation!
    var venueName: String!
    let locationManager = CLLocationManager()
    var destinationMapItem: MKMapItem!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Make the nav bar transparent from https://stackoverflow.com/questions/19082963/how-to-make-completely-transparent-navigation-bar-in-ios-7#19323215
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        // Make back button blue
        self.navigationController?.navigationBar.tintColor = self.view.tintColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getRoute()
        centerMapOnLocation(location: currentLocation)
        
        // Set annotations for venue
        let venueAnnotation = VenueAnnotation(title: venueName, coordinate: CLLocationCoordinate2D(latitude: venueLocation.coordinate.latitude, longitude: venueLocation.coordinate.longitude))
        mapView.addAnnotation(venueAnnotation)
        
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    func updateUI() {
        // Style button
        directionsButton.backgroundColor = UIColor.white
        directionsButton.layer.masksToBounds = false
        directionsButton.layer.shadowOpacity = 0.2
        directionsButton.layer.cornerRadius = 8
        directionsButton.layer.shadowColor = UIColor.black.cgColor
        directionsButton.layer.shadowRadius = 4
        directionsButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        
//        // Set up blur effect from https://stackoverflow.com/questions/25550719/add-a-blur-effect-to-a-uibutton#32861709
//        let blur = UIVisualEffectView(effect: UIBlurEffect(style:
//            UIBlurEffectStyle.light))
//        blur.frame = directionsButton.bounds
//        blur.layer.cornerRadius = 8
//        blur.clipsToBounds = true
//        blur.isUserInteractionEnabled = false
//        directionsButton.insertSubview(blur, at: 0)
    }
    
    // Set current location indicator if allowed from https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    // Zoom and center the map from https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // Sets MapItems and requests route using MKDirections from https://www.ioscreator.com/tutorials/draw-route-mapkit-tutorial
    func getRoute() {
        // Get MKMapItem for locations
        let sourcePlacemark = MKPlacemark(coordinate: currentLocation.coordinate, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        
        let destinationPlacemark = MKPlacemark(coordinate: venueLocation.coordinate, addressDictionary: nil)
        destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // Request route information from https://stackoverflow.com/questions/28723490/display-route-on-map-in-swift
        let request: MKDirectionsRequest = MKDirectionsRequest()
        request.source = sourceMapItem
        request.destination = destinationMapItem
        request.transportType = .walking
        
        let route = MKDirections(request: request)
        
        route.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("ERROR")
                    print(error)
                }
                
            return
        }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
        
        }
    
    }
    
    // Render the polyline
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = self.view.tintColor
        renderer.lineWidth = 3.5
        
        return renderer
    }
    @IBAction func directionsButtonTapped(_ sender: Any) {
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        destinationMapItem.name = venueName
        destinationMapItem.openInMaps(launchOptions: launchOptions)
    }
    
}

