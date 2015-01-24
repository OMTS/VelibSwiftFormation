//
//  StationService.swift
//  VelibFormationSwift
//
//  Created by Iman Zarrabian on 23/01/15.
//  Copyright (c) 2015 Iman Zarrabian. All rights reserved.
//

import Realm

class StationService {
    struct RESTStationsAttributes {
        static let kStationsPath = "/vls/v1/stations"
        static let kStationDetailPath = "/vls/v1/stations/"
    }

    func getStations() -> NSURLSessionDataTask {
        let params = [APIClient.APIClientConstants.kApiContractParamKey :APIClient.APIClientConstants.kApiContractParamValue,
            APIClient.APIClientConstants.kApiKeyParamKey:APIClient.APIClientConstants.kApiKeyParamValue]
        
        return APIClient.sharedInstance.GET(RESTStationsAttributes.kStationsPath, parameters: params,
            success:{
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
                
                //Doing the Local DB populating in background to test Realm perf
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    // do some task
                    var test : AnyObject!  = responseObject
                    //can force this test variable to any type to test the optional behavior
                    //e.g test = 3 or test = "a random string"
                    //self.dataSource should be nil then
                    // self.dataSource = test as? Array<Dictionary<String,AnyObject>>
                    if let arrayOfStations = test as? Array<Dictionary<String,AnyObject>> {
                        let timeElapsed = self.populateLocalDb(array: arrayOfStations)
                        println("\(timeElapsed)s elapsed populating")
                    }
                }
            },
            failure:{(task: NSURLSessionDataTask!, error: NSError!) -> Void in
                print("Reponse Failure \(error)")
        })
    }
    
    func getStation(#station_id: Int) -> NSURLSessionDataTask {
        let params = [APIClient.APIClientConstants.kApiContractParamKey :APIClient.APIClientConstants.kApiContractParamValue,
            APIClient.APIClientConstants.kApiKeyParamKey:APIClient.APIClientConstants.kApiKeyParamValue]
        
        let path = RESTStationsAttributes.kStationDetailPath + String(station_id)
        return APIClient.sharedInstance.GET(path, parameters: params,
            success:{
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
                
                //Doing the Local DB populating in background to test Realm perf
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    if let station = responseObject as? Dictionary<String, AnyObject> {
                        let realm = RLMRealm.defaultRealm()
                        realm.beginWriteTransaction()
                        Station.createOrUpdateInDefaultRealmWithObject(station)
                        realm.commitWriteTransaction()
                    }
                }
            },
            failure:{(task: NSURLSessionDataTask!, error: NSError!) -> Void in
                print("Reponse Failure \(error)")
        })
    }

    private func populateLocalDb(#array : Array<Dictionary<String,AnyObject>>) -> NSTimeInterval {
        let before = NSDate()
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        for station in array {
            let currentStation = Station.createOrUpdateInDefaultRealmWithObject(station)
            //We can use currentStation is needed
        }
        realm.commitWriteTransaction()
        let after = NSDate()
        return after.timeIntervalSinceDate(before)
    }
}
