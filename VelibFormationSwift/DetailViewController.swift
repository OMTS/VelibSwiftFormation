//
//  DetailViewController.swift
//  VelibFormationSwift
//
//  Created by Iman Zarrabian on 20/01/15.
//  Copyright (c) 2015 Iman Zarrabian. All rights reserved.
//

import UIKit
import MapKit
import Realm

class DetailViewController: UIViewController {

    var station : Station!
    
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var nbBikesLabel: UILabel!
    @IBOutlet var nbStandsLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var favButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.favButton.selected = !(self.station.user == nil)
        updateUI()
        setStationRegion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        self.title = self.station.name
        self.addressLabel.text = self.station.address
        self.nbBikesLabel.text = "\(self.station.available_bikes) bikes available"
        self.nbStandsLabel.text = "\(self.station.available_bike_stands) stands available"
        createAndAddStationAnnotation()
    }
    
    func createAndAddStationAnnotation() {
        let coordinates = CLLocationCoordinate2D(latitude: self.station.position.lat, longitude: self.station.position.lng)
        let annotation = StationAnnotation(coordinate:coordinates, title: self.station.name, subtitle: self.station.address)
        self.mapView.addAnnotation(annotation)
    }
    
    func setStationRegion() {
        let coordinates = CLLocationCoordinate2D(latitude: self.station.position.lat, longitude: self.station.position.lng)
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBAction func favOrUnFav(sender : AnyObject) {
        self.favButton.selected = !self.favButton.selected
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        if self.favButton.selected {
            self.station.user = UserManager.sharedInstance.currentUser
        }
        else {
            self.station.user = nil
        }
        realm.commitWriteTransaction()
    }
}
