//
//  UserManager.swift
//  VelibFormationSwift
//
//  Created by Iman Zarrabian on 25/01/15.
//  Copyright (c) 2015 Iman Zarrabian. All rights reserved.
//
import Foundation
import Realm

class UserManager : NSObject  {
    
    //computed property
    class var sharedInstance: UserManager {
        //this struc won't be accessible from outside
        struct Static {
            static var instance: UserManager?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = UserManager()
        }
        return Static.instance!
    }
    
    var currentUser:User?
}
