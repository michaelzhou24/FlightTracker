//
//  MapViewController.swift
//  FlightTracker
//
//  Created by Michael Zhou on 2018-07-17.
//  Copyright © 2018 Michael Zhou. All rights reserved.
//

import MapKit
import UIKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locMgr = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        locMgr.delegate = self
        checkLocationAuthorizationStatus()
        locMgr.startUpdatingLocation()
        centerOnUser()
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            mapView.showsUserLocation = true
        } else {
            locMgr.requestAlwaysAuthorization()
            checkLocationAuthorizationStatus()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // When the location updates
    }
    
    func centerOnUser() {
        if let coordinate = locMgr.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        centerOnUser()
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        // Start recording actions
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

