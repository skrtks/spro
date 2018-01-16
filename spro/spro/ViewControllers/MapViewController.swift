//
//  MapViewController.swift
//  spro
//
//  Created by Sam Kortekaas on 11/01/2018.
//  Copyright © 2018 Kortekaas. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var directionsButton: UIButton!
    
    var currentLocation: CLLocation!
    var venueLocation: CLLocation!
    var venueName: String!
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation(location: currentLocation)
        let distance = String(Int(currentLocation.distance(from: venueLocation))) + " meters"
        let venueAnnotation = VenueAnnotation(title: venueName, distance: distance, coordinate: CLLocationCoordinate2D(latitude: venueLocation.coordinate.latitude, longitude: venueLocation.coordinate.longitude))
        MapView.addAnnotation(venueAnnotation)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    // Set current location indicator if allowed from https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            MapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    // Zoom and center the map from https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        MapView.setRegion(coordinateRegion, animated: true)
    }

}

//extension MapViewController: MKMapViewDelegate {
//    // 1
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        // 2
//        guard let annotation = annotation as? VenueAnnotation else { return nil }
//        // 3
//        let identifier = "marker"
//        var view: MKMarkerAnnotationView
//        // 4
//        MapView.annot
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//            as? MKMarkerAnnotationView {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            // 5
//            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        return view
//    }
//}

