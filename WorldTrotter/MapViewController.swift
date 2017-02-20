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
    let locationManager = CLLocationManager()
    
    
    //Function called when "Find Me" button is pressed
    //If not currently showing the users location, records the current map view in lastLoc
    //then jumps to the users current location. If currently showing the users location, stops
    //tracking them and jumps to the value held in lastLoc
    func locateMe(_ sender: UIButton!) {
        if(!mapView.showsUserLocation){
            mapView.showsUserLocation = true
        } else {
            mapView.showsUserLocation = false
        }
    }
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        print("Started Loading Location")
        lastLoc = mapView.centerCoordinate
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        print("Stopped Loading Location")
        mapView.setCenter(lastLoc, animated: true)
    }

    //Array to hold the annotations in the following indices:
    //0 - bornAnnotation
    //1 - currentAnnotation
    //2 - interestAnnotation
    var pinLocations: [MKPointAnnotation] = []
    
    
    
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
        userLoc.addTarget(self, action: #selector(locateMe(_:)), for: .touchUpInside)
        view.addSubview(userLoc)
        
        let userLocBotConstraint = userLoc.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -8)
        let userLocLeadingConstraint = userLoc.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        userLocBotConstraint.isActive = true
        userLocLeadingConstraint.isActive = true
        
        
        //-----Pin Tracker
        let bornAnnotation = MKPointAnnotation()
        pinLocations.append(bornAnnotation)
        let currentAnnotation = MKPointAnnotation()
        pinLocations.append(currentAnnotation)
        let interestAnnotation = MKPointAnnotation()
        pinLocations.append(interestAnnotation)

        pinLocations[0].coordinate = CLLocationCoordinate2DMake(42.2495, -71.0662)
        pinLocations[0].title = "Born Here"
        pinLocations[0].subtitle = "Milton, MA"
        pinLocations[1].coordinate = CLLocationCoordinate2DMake(35.9732,-79.9950)
        pinLocations[1].title = "Currently Here"
        pinLocations[1].subtitle = "High Point, NC"
        pinLocations[2].coordinate = CLLocationCoordinate2DMake(40.0150, -105.2705)
        pinLocations[2].title = "Been Here"
        pinLocations[2].subtitle = "Boulder, CO"
        
        let pins = UIButton()
        pins.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        pins.layer.borderWidth = 1
        pins.layer.cornerRadius = 5
        
        pins.layer.borderColor = UIColor.blue.cgColor
        pins.translatesAutoresizingMaskIntoConstraints = false
        pins.setTitle(" Pins ", for: .normal)
        pins.setTitleColor(UIColor.blue, for: .normal)
        pins.addTarget(self, action: #selector(cyclePins), for: .touchUpInside)
        view.addSubview(pins)
        
        let pinsBotConstraint = pins.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -8)
        let pinsTrailingConstraint = pins.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        pinsBotConstraint.isActive = true
        pinsTrailingConstraint.isActive = true
        
        
    }
    
    
    var pinNumber = 0
    //Function to cycle through pins with every click of the "pins" button. 
    //On the fourth click will bring the map back to the default view.
    func cyclePins(){
        mapView.removeAnnotations(pinLocations)
        
        if(pinNumber%4 < 3) {
            let coord = pinLocations[pinNumber%4].coordinate
            if(coord.latitude != mapView.centerCoordinate.latitude || coord.longitude != mapView.centerCoordinate.longitude){
                lastLoc = mapView.centerCoordinate
            }
            mapView.addAnnotation(pinLocations[pinNumber%4])
            mapView.selectAnnotation(pinLocations[pinNumber%4], animated: true)
            mapView.setCenter(pinLocations[pinNumber%4].coordinate, animated: true)
        } else {
            mapView.setCenter(lastLoc, animated: true)
            
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
