//
//  ViewController.swift
//  VelibFormationSwift
//
//  Created by Iman Zarrabian on 29/12/14.
//  Copyright (c) 2014 Iman Zarrabian. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let fakeData = ["line 1","line 2","line 3"]
    let cellIdentifier = "cellIdentifier"
    var dataSource = [String]()
    
    @IBOutlet var myTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting this avoid cells to display ??
       //self.myTableView.registerClass(StationTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        for i in 1..<101 {
            self.dataSource.append("index \(i)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.myTableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as StationTableViewCell
        
        cell.nameLabel.text = self.dataSource[indexPath.row]
        cell.addressLabel.text = "toto"
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
                      detailVC.stationName = self.dataSource[indexPath.row]
                    }
                }
            }
        }
    }
}

