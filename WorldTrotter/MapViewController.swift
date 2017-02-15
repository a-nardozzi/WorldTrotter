//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Alexander Nardozzi on 2/7/17.
//  Copyright © 2017 Alex Nardozzi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{
    
    var mapView: MKMapView!
    
    var lastLoc: CLLocationCoordinate2D!
    
    var originalLocation: MKCoordinateRegion!
    
    
    let locationManager = CLLocationManager()
    
    func locateMe(_ sender: UIButton!) {
        
        
        if(!mapView.showsUserLocation){
            print("locating")
            mapView.showsUserLocation = true
            lastLoc = mapView.centerCoordinate
            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
            
        } else {
            mapView.showsUserLocation = false
            mapView.setCenter(lastLoc, animated: true)
        }
    }
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        print("Started Loading Location")
        
        
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        print("Stopped Loading Location")
    }
    
    var pinLocations: [CLLocationCoordinate2D] = [CLLocationCoordinate2DMake(42.2495, -71.0662),CLLocationCoordinate2DMake(35.9732,-79.9950),CLLocationCoordinate2DMake(41.6688, -70.2962)]
    

    
    
    override func loadView() {
        mapView = MKMapView()
        
        view = mapView
        self.mapView.delegate = self
        originalLocation = MKCoordinateRegionMakeWithDistance(mapView.centerCoordinate, 10000000, 10000000)
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
        userLoc.addTarget(self, action: #selector(locateMe(_:)), for: .touchUpInside)
        
        userLoc.tag = 1
        view.addSubview(userLoc)
        
        let userLocBotConstraint = userLoc.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -8)
        let userLocLeadingConstraint = userLoc.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        
        userLocBotConstraint.isActive = true
        userLocLeadingConstraint.isActive = true
        
        
        //-----Pin Tracker
        let bornAnnotation = MKPointAnnotation()
        bornAnnotation.coordinate = pinLocations[0]
        bornAnnotation.title = "Born Here, Milton MA"
        let currentAnnotation = MKPointAnnotation()
        currentAnnotation.coordinate = pinLocations[1]
        currentAnnotation.title = "Currently Here, High Point NC"
        let interestAnnotation = MKPointAnnotation()
        interestAnnotation.coordinate = pinLocations[2]
        interestAnnotation.title = "Been Here, Cape Cod MA"
        
        mapView.addAnnotation(bornAnnotation)
        mapView.addAnnotation(currentAnnotation)
        mapView.addAnnotation(interestAnnotation)
        
        let pins = UIButton()
        pins.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        pins.layer.borderWidth = 1
        pins.layer.cornerRadius = 5
        
        pins.layer.borderColor = UIColor.blue.cgColor
        pins.translatesAutoresizingMaskIntoConstraints = false
        pins.setTitle(" Pins ", for: .normal)
        pins.setTitleColor(UIColor.blue, for: .normal)
        pins.addTarget(self, action: #selector(cyclePins), for: .touchUpInside)
        
    
        
        pins.tag = 2
        view.addSubview(pins)
        
        let pinsBotConstraint = pins.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -8)
        let pinsTrailingConstraint = pins.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        pinsBotConstraint.isActive = true
        pinsTrailingConstraint.isActive = true
        
        originalLocation = MKCoordinateRegionMakeWithDistance(mapView.centerCoordinate, 1000000, 1000000)
        
    }
    
    
    var pinNumber = 0
    func cyclePins(){
        var rgn: MKCoordinateRegion
        if(pinNumber%4 < 3) {
            rgn = MKCoordinateRegionMakeWithDistance(pinLocations[pinNumber%4], 10000, 10000)
            mapView.setRegion(rgn, animated: true)
        } else {
            mapView.setRegion(originalLocation, animated: true)
            
        }
        pinNumber = pinNumber + 1
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
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
