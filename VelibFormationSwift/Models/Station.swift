//
//  Station.swift
//  VelibFormationSwift
//
//  Created by Iman Zarrabian on 21/01/15.
//  Copyright (c) 2015 Iman Zarrabian. All rights reserved.
//

import Realm
import MapKit

class Position: RLMObject {
    dynamic var lat = 0.0
    dynamic var lng = 0.0
}

// Station model
class Station: RLMObject {
    dynamic var number = 0
    dynamic var name = ""
    dynamic var address = ""
    dynamic var available_bikes = 0
    dynamic var available_bike_stands = 0
    dynamic var position = Position()
    dynamic var imageURL = ""
    
    //External To-One relationship
    //has to be optional cause a station can be without a user
    dynamic var user : User?

    override class func primaryKey() -> String {
        return "number"
    }
}



