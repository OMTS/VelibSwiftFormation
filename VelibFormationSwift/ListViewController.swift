//
//  ViewController.swift
//  VelibFormationSwift
//
//  Created by Iman Zarrabian on 29/12/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct ViewControllerDefines {
        static let kApiPath = "/vls/v1/stations"
        static let kImageURlString = "http://www.yankodesign.com/images/design_news/2013/10/17/flexi_bike.jpg"
    }
    let cellIdentifier = "cellIdentifier"
    var dataSource = [Dictionary<String, AnyObject>]?()

    @IBOutlet var myTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRemoteStations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfRows = self.dataSource?.count {
            return numberOfRows
        }
        else {
          return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.myTableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as StationTableViewCell
        
        cell.nameLabel.text = self.dataSource![indexPath.row]["name"] as? String
        cell.addressLabel.text = self.dataSource![indexPath.row]["address"] as? String
        
        let url = NSURL(string: ViewControllerDefines.kImageURlString)
        cell.avatarView.sd_setImageWithURL(url, placeholderImage:UIImage(named: "images"))

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
                      detailVC.stationName = self.dataSource![indexPath.row]["name"] as? String
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
                
                var test : AnyObject!  = responseObject
                //can force this test variable to any type to test the optional behavior 
                //e.g test = 3 or test = "a random string"
                //self.dataSource should be nil then
                self.dataSource = test as? Array<Dictionary<String,AnyObject>>
                self.myTableView.reloadData()
            },
            failure:{(task: NSURLSessionDataTask!, error: NSError!) -> Void in
                print("Reponse Failure \(error)")
        })
    }
}

