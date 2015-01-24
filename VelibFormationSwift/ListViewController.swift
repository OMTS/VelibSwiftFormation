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
        static let kImageURlString = "http://www.yankodesign.com/images/design_news/2013/10/17/flexi_bike.jpg"
    }
    @IBOutlet var myTableView : UITableView!

    let cellIdentifier = "cellIdentifier"
    var dataSource = [Dictionary<String, AnyObject>]?()
    var realmDataSource : RLMResults?
    var token : RLMNotificationToken?
    var stationsService : NSURLSessionTask?
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
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
    
    func initUI() {
        //hack to make refrsh control available in our UIViewController subclass
       let tableVC = UITableViewController()
        tableVC.tableView = self.myTableView
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        self.refreshControl.addTarget(self, action:"getRemoteStations", forControlEvents: .ValueChanged)
        tableVC.refreshControl = self.refreshControl
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
        self.stationsService = StationService().getStations();
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
        self.refreshControl.endRefreshing()
        println("\(localTuplet.nbObjects) Objects Fetched and \(localTuplet.elapsedTime)s elapsed locally fetching")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.myTableView.reloadData()
        })
    }
}



