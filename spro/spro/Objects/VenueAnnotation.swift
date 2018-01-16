//
//  VenueAnnotation.swift
//  spro
//
//  Created by Sam Kortekaas on 16/01/2018.
//  Copyright © 2018 Kortekaas. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class VenueAnnotation: NSObject, MKAnnotation {

    let title: String?
    let distance: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, distance: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.distance = distance
        self.coordinate = coordinate
        
        super.init()
    }
}
