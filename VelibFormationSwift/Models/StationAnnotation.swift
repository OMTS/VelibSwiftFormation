//
//  StationAnnotation.swift
//  VelibFormationSwift
//
//  Created by Iman Zarrabian on 24/01/15.
//  Copyright (c) 2015 Iman Zarrabian. All rights reserved.
//

import Foundation
import MapKit

class StationAnnotation: NSObject, MKAnnotation {

    var coordinate : CLLocationCoordinate2D
    var title: String!
    var subtitle: String!
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
