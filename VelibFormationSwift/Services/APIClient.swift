//
//  APIClient.swift
//  VelibFormationSwift
//
//  Created by Iman Zarrabian on 20/01/15.
//  Copyright (c) 2015 Iman Zarrabian. All rights reserved.
//


class APIClient : AFHTTPSessionManager {
    
    //this struct will be accessible from outside
    struct APIClientConstants {
        static let kApiBaseUrl = "https://api.jcdecaux.com"
        static let kApiKeyParamValue = "cd982b2f6008d5560b48a2d31cb6d3ad44f11fca"
        static let kApiKeyParamKey = "apiKey"
        static let kApiContractParamValue = "paris"
        static let kApiContractParamName = "contract"
    }
    
    //computed property
    class var sharedInstance: APIClient {
        //this struc won't be accessible from outside
        struct Static {
            static var instance: APIClient?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            let baseURL = NSURL(string: APIClientConstants.kApiBaseUrl)
            Static.instance = APIClient(baseURL: baseURL)
        }
        return Static.instance!
    }
}
