//
//  VenueAnnotation.swift
//  spro
//
//  Initializes a custom marker for showing the location of a venue on the map.
//
//  Created by Sam Kortekaas on 16/01/2018.
//  Student ID: 10718095
//  Copyright © 2018 Kortekaas. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class VenueAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        super.init()
    }
}
