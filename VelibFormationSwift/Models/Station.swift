//
//  Station.swift
//  VelibFormationSwift
//
//  Created by Iman Zarrabian on 21/01/15.
//  Copyright (c) 2015 Iman Zarrabian. All rights reserved.
//

import Realm

// Station model
class Station: RLMObject {
    dynamic var number = 0
    dynamic var name = ""
    dynamic var address = ""
    dynamic var lat : Double = 0.0
    dynamic var lng : Double = 0.0
    dynamic var nbBikesAvailable = 0
    dynamic var nbStandsAvailable = 0
    dynamic var imageURL = ""
    
    override class func primaryKey() -> String {
        return "number"
    }
}

