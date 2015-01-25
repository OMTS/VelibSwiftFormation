//
//  MapViewController.swift
//  VelibFormationSwift
//
//  Created by Iman Zarrabian on 19/01/15.
//  Copyright (c) 2015 Iman Zarrabian. All rights reserved.
//

import UIKit
import MapKit
import Realm

class MapViewController: StationsViewController,UINavigationBarDelegate {

    var realmDataSource : RLMResults?
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func updateUI() {
        let localTuplet = self.reloadDataFromLocalDB(ordered: true)
        self.realmDataSource = localTuplet.results
        //We can work on the RLMResults collection directly here to create an array of StationAnnotations and add it to the map
        //But we first transform the RLMResult into a regular Array just to test
        //The Swift Array's map function
        //Just for fun, not for perf obviously
        var stationArray = [Station]()
        for station in self.realmDataSource! {
            if let stationObj = station as? Station {
                stationArray.append(stationObj)
            }
        }
        //This is the FUN !!! 
        //YIIIIHAAAAA the map function
        let stationsAnnotations = stationArray.map { (station:Station) -> StationAnnotation in
            let coordinates = CLLocationCoordinate2D(latitude: station.position.lat, longitude: station.position.lng)
            return StationAnnotation(coordinate:coordinates, title: station.name, subtitle: station.address)
        }
        //first line will remove old Annotations
        //second line will add new Annotations
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(stationsAnnotations)
    
        //A better approach (but maybe a bit overkill here) 
        //would be to compute (on a background queue)
        //the array of new stations and add them, and only them to the map
        //given the fact that stations are added not often 
        //and never removed in real life
        
        println("Number of annotations on the map (should stay constant) \(self.mapView.annotations.count)")
    }

    @IBAction func gobackToList(sender : AnyObject) {
        if sender is UIButton {
            NSLog("BUTTON")
        }
        else {
            if sender is UIBarButtonItem {
                NSLog("BAR BUTTON ITEM")
            }
            else {
                NSLog("WRONG TYPE")
            }
        }
        //This is also valid I Guess (trying some optional cast)
        if let button = sender as? UIBarButtonItem {
            // object is successfully cast to type UIBarButtonItem and bound to button
            NSLog("BAR BUTTON ITEM CASTED")
        } else {
            // object could not be cast to type UIButton
            NSLog("CANNOT CAST BUTTON")
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func reloadRemoteData(sender : AnyObject) {
        self.getRemoteStations()
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
