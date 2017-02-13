//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Alexander Nardozzi on 2/7/17.
//  Copyright © 2017 Alex Nardozzi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    var mapView: MKMapView!
    
    var lastLoc: MKCoordinateRegion!
    
    var currentPress = true
    
    
    let locationManager = CLLocationManager()
    
    func locateMe(sender: UIButton!){
        if(currentPress){
            mapView.showsUserLocation = true
            mapView.showsUserLocation = false
            currentPress = false
        } else {
            mapView.setRegion(lastLoc, animated: true)
            currentPress = true
        }
    }
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        print("Started Loading Location")
        
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        lastLoc = mapView.region
        
        let region = MKCoordinateRegionMakeWithDistance((locationManager.location?.coordinate)!, 1000, 1000)
        mapView.setRegion(region, animated: true)
        
        
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        print("Stopped Loading Location")
    }
    
  

    
    
    override func loadView() {
        mapView = MKMapView()
        
        view = mapView
        self.mapView.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        let standardString = NSLocalizedString("Standard", comment: "Standard Map View")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite Map View")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid Map View")
        
        let segmentedControl = UISegmentedControl(items: [standardString, satelliteString, hybridString])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let margins = view.layoutMarginsGuide
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        
        // -----User Location Finder
        let userLoc = UIButton()
        userLoc.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        userLoc.layer.borderWidth = 1
        userLoc.layer.borderColor = UIColor.blue.cgColor
        userLoc.layer.cornerRadius = 5
        userLoc.translatesAutoresizingMaskIntoConstraints = false
        userLoc.setTitle(" Find Me ", for: .normal)
        userLoc.setTitleColor(UIColor.blue, for: .normal)
        userLoc.addTarget(self, action: #selector(locateMe), for: .touchUpInside)
        
        userLoc.tag = 1
        view.addSubview(userLoc)
        
        let userLocBotConstraint = userLoc.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -8)
        let userLocLeadingConstraint = userLoc.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        
        userLocBotConstraint.isActive = true
        userLocLeadingConstraint.isActive = true
        
        //-----Pin Tracker
        let bornAnnotation = MKPointAnnotation()
        bornAnnotation.coordinate = CLLocationCoordinate2D(latitude: 42.2513, longitude: -71.0773)
        bornAnnotation.title = "Born Here"
        let currentAnnotation = MKPointAnnotation()
        currentAnnotation.coordinate = CLLocationCoordinate2D(latitude: 35.9732, longitude: -79.9950)
        currentAnnotation.title = "Currently Here"
        let interestAnnotation = MKPointAnnotation()
        interestAnnotation.coordinate = CLLocationCoordinate2D(latitude: 44.5437, longitude: -72.8143)
        interestAnnotation.title = "Been Here"
        
        mapView.addAnnotation(bornAnnotation)
        mapView.addAnnotation(currentAnnotation)
        mapView.addAnnotation(interestAnnotation)
        
        let pins = UIButton()
        pins.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        pins.layer.borderWidth = 1
        pins.layer.borderColor = UIColor.blue.cgColor
        pins.layer.cornerRadius = 5
        pins.translatesAutoresizingMaskIntoConstraints = false
        pins.setTitle(" Pins ", for: .normal)
        pins.setTitleColor(UIColor.blue, for: .normal)
        
    
        
        pins.tag = 2
        view.addSubview(pins)
        
        let pinsBotConstraint = pins.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -8)
        let pinsTrailingConstraint = pins.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        pinsBotConstraint.isActive = true
        pinsTrailingConstraint.isActive = true
        
    }
    
    var pinNumber = 0
    func cyclePins(){
        var rgn: CLLocationCoordinate2D
        if(pinNumber == 0) {
            rgn.init(latitude: 42.2513, longitude: -71.0773)
            MKCoordinateRegionMakeWithDistance(rgn, 1000, 1000)
        }
        
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        print("MapViewController loaded its view.")
    }
    
    func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
            mapView.showsUserLocation = false
        case 2:
            mapView.mapType = .hybrid
            mapView.showsUserLocation = true
        default:
            break
        }
    }
}
