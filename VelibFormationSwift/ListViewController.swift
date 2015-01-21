//
//  ViewController.swift
//  VelibFormationSwift
//
//  Created by Iman Zarrabian on 29/12/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

import UIKit
import Realm

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct ViewControllerDefines {
        static let kApiPath = "/vls/v1/stations"
        static let kImageURlString = "http://www.yankodesign.com/images/design_news/2013/10/17/flexi_bike.jpg"
    }
    let cellIdentifier = "cellIdentifier"
    var dataSource = [Dictionary<String, AnyObject>]?()
    var realmDataSource : RLMResults?
    var token : RLMNotificationToken?

    @IBOutlet var myTableView : UITableView!
    
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = self.realmDataSource {
            return Int(dataSource.count)
        }
        else {
          return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.myTableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as StationTableViewCell
        
        if let realmResult = self.realmDataSource {
            if let currentStation = realmResult[UInt(indexPath.row)] as? Station {
                cell.nameLabel.text = currentStation.name
                cell.addressLabel.text = currentStation.address
            }
            let url = NSURL(string: ViewControllerDefines.kImageURlString)
            cell.avatarView.sd_setImageWithURL(url, placeholderImage:UIImage(named: "images"))
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("cell \(indexPath.row) tapped")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mapSegue" {
            NSLog("mapSegue")
        }
        else if segue.identifier == "detailSegue" {
            if let detailVC = segue.destinationViewController as? DetailViewController {
                if let cell = sender as? StationTableViewCell {
                    if let indexPath = self.myTableView.indexPathForCell(cell) {
                      detailVC.station = self.realmDataSource![UInt(indexPath.row)] as? Station
                    }
                }
            }
        }
    }
    
    func getRemoteStations () {
        let params = [APIClient.APIClientConstants.kApiContractParamKey :APIClient.APIClientConstants.kApiContractParamValue,
            APIClient.APIClientConstants.kApiKeyParamKey:APIClient.APIClientConstants.kApiKeyParamValue]
        
        APIClient.sharedInstance.GET(ViewControllerDefines.kApiPath, parameters: params,
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

    func populateLocalDb(#array : Array<Dictionary<String,AnyObject>>) -> NSTimeInterval {
        let before = NSDate()
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()

        for station in array {
            let currentStation = Station.createOrUpdateInDefaultRealmWithObject(station)
        }
        realm.commitWriteTransaction()
        let after = NSDate()
        return after.timeIntervalSinceDate(before)
    }
    
    func reloadDataFromLocalDB (#ordered: Bool) -> (nbObjects : UInt, results: RLMResults,elapsedTime: NSTimeInterval){
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
    
    func updateUI() {
        let localTuplet = self.reloadDataFromLocalDB(ordered: true)
        self.realmDataSource = localTuplet.results
        println("\(localTuplet.nbObjects) Objects Fetched and \(localTuplet.elapsedTime)s elapsed locally fetching")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.myTableView.reloadData()
        })
    }
}



