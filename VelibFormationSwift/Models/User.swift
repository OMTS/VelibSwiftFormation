//
//  User.swift
//  VelibFormationSwift
//
//  Created by Iman Zarrabian on 25/01/15.
//  Copyright (c) 2015 Iman Zarrabian. All rights reserved.
//

import Realm

//User model
class User: RLMObject {
    dynamic var user_id = 0
    dynamic var name = ""
    dynamic var email = ""
    var stations: [Station] {
        // Realm doesn't persist this property because it only has a getter defined
        // Define "stations" as the inverse relationship to Station.user
        return linkingObjectsOfClass("Station", forProperty: "user") as [Station]
    }
    override class func primaryKey() -> String {
        return "user_id"
    }
}
