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
    
    
    
    let locationManager = CLLocationManager()
    
    func buttonAction(sender: UIButton!){
        mapView.showsUserLocation = true
   //   print(mapView.userLocation.location)
        
        //locationManager = CLLocationManager()
        
 
        
    }
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        print("Start Loading")
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        print("Stop Loading")
    }
    

    
    
    override func loadView() {
        mapView = MKMapView()
        
        view = mapView
        self.mapView.delegate = self
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
        
        
        let userLoc = UIButton()
        userLoc.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        userLoc.layer.borderWidth = 1
        userLoc.layer.borderColor = UIColor.blue.cgColor
        userLoc.layer.cornerRadius = 5
        userLoc.translatesAutoresizingMaskIntoConstraints = false
        userLoc.setTitle(" Find Me ", for: .normal)
        userLoc.setTitleColor(UIColor.blue, for: .normal)
        userLoc.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        userLoc.tag = 1
        view.addSubview(userLoc)
        
        let userLocBotConstraint = userLoc.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -8)
        let userLocLeadingConstraint = userLoc.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        
        userLocBotConstraint.isActive = true
        userLocLeadingConstraint.isActive = true
        
        
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
