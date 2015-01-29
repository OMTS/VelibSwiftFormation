//
//  ViewController.swift
//  VelibFormationSwift
//
//  Created by Iman Zarrabian on 29/12/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

import UIKit
import Realm

class ListViewController: StationsViewController, UITableViewDelegate, UITableViewDataSource, DetailViewControllerDelegate {
    
    struct ViewControllerDefines {
        //Same as static constant in C
        static let kImageURlString = "http://www.yankodesign.com/images/design_news/2013/10/17/flexi_bike.jpg"
    }
    @IBOutlet var myTableView : UITableView!

    let cellIdentifier = "cellIdentifier"
    var realmDataSource : RLMResults?
    var refreshControl = UIRefreshControl()
    var displayAll: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initRefreshControl()
    }
    
    override func updateUI() {
        let localTuplet = self.reloadDataFromLocalDB(ordered: true)
        self.realmDataSource = localTuplet.results
        self.refreshControl.endRefreshing()
        println("\(localTuplet.nbObjects) Objects Fetched and \(localTuplet.elapsedTime)s elapsed locally fetching")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.myTableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initRefreshControl() {
        //hack to make refrsh control available in our UIViewController subclass
       let tableVC = UITableViewController()
        tableVC.tableView = self.myTableView
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        self.refreshControl.addTarget(self, action:"getRemoteStations", forControlEvents: .ValueChanged)
        tableVC.refreshControl = self.refreshControl
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.displayAll {
            if let dataSource = self.realmDataSource {
                return Int(dataSource.count)
            }
            else {
                return 0
            }
        }
        else {
            let dataSource = UserManager.sharedInstance.currentUser!.stations
            return Int(dataSource.count)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.myTableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as StationTableViewCell
        
        if self.displayAll {
            if let realmResult = self.realmDataSource {
                if let currentStation = realmResult[UInt(indexPath.row)] as? Station {
                    configureCell(cell, station: currentStation)
                }
                let url = NSURL(string: ViewControllerDefines.kImageURlString)
                cell.avatarView.sd_setImageWithURL(url, placeholderImage:UIImage(named: "images"))
            }
        }
        else {
                configureCell(cell, station: UserManager.sharedInstance.currentUser!.stations[indexPath.row])
                let url = NSURL(string: ViewControllerDefines.kImageURlString)
                cell.avatarView.sd_setImageWithURL(url, placeholderImage:UIImage(named: "images"))
            }
        return cell
    }
    
    
    func configureCell(cell: StationTableViewCell, station: Station) {
        cell.nameLabel.text = station.name
        cell.addressLabel.text = station.address
        cell.favView.hidden = (station.user == nil)
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
                        if self.displayAll {
                            detailVC.station = self.realmDataSource![UInt(indexPath.row)] as? Station
                        }
                        else {
                            detailVC.station = UserManager.sharedInstance.currentUser!.stations[indexPath.row]
                        }
                        detailVC.delegate = self
                    }
                }
            }
        }
    }
    
    @IBAction func selectorChanged(sender: AnyObject?) {
        self.displayAll = !self.displayAll
        self.myTableView.reloadData()
    }

    func detailViewControllerDidfavUnFav(detailVC: DetailViewController, station: Station, faved: Bool) {
        
        //Carefull this makes user_id an Int? (Optional Int type)
        //Because currentUser is a User? type
        let user_id = UserManager.sharedInstance.currentUser?.user_id
        let station_id = station.number
        
        //No need to do this in background
        //But we are just testing realm here
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            
            if let thisThreadStation = Station.objectsWhere("number = \(station_id)").firstObject() as? Station {
                if let thisThreadUser = User.objectsWhere("user_id = \(user_id!)").firstObject() as? User {
                    if faved {
                        thisThreadStation.user = thisThreadUser
                    }
                    else {
                        thisThreadStation.user = nil
                    }
                    realm.commitWriteTransaction()
                }
            }
        }
    }
}



