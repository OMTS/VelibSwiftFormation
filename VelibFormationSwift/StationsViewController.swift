//
//  StationsViewController.swift
//  VelibFormationSwift
//
//  Created by Iman Zarrabian on 25/01/15.
//  Copyright (c) 2015 Iman Zarrabian. All rights reserved.
//
import Realm

class StationsViewController: UIViewController {
    
    var stationsService : NSURLSessionTask?
    var token : RLMNotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        getRemoteStations()
        updateUI()
        // Observe Realm Notifications
        let realm = RLMRealm.defaultRealm()
        self.token = realm.addNotificationBlock { note, realm in
            self.updateUI()
        }
    }

    func updateUI() {
        fatalError("This func has to be implemented/override by subclasse")
    }
    
    func getRemoteStations () {
        //This will get all new data from the remote API
        //AND update the local database
        self.stationsService = StationService().getStations();
    }
    
    func reloadDataFromLocalDB (#ordered: Bool) -> (nbObjects : UInt, results: RLMResults,elapsedTime: NSTimeInterval){
        //This will fetch all stations from the local database
        //and return the result as a RLMResults
        let before = NSDate()
        var resultsToReturn : RLMResults
        if !ordered {
            resultsToReturn = Station.allObjects()
        }
        else {
            resultsToReturn = Station.allObjects().sortedResultsUsingProperty("name", ascending: true)
        }
        let after = NSDate()
        return (resultsToReturn.count,resultsToReturn,after.timeIntervalSinceDate(before))
    }
}
