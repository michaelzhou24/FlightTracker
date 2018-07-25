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
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeButton: UIButton!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var currentLocLabel: UILabel!
    
    var locMgr = CLLocationManager()
    var flightPath : [CLLocation] = []
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initializeButtons()
        mapView.delegate = self
        mapView.mapType = MKMapType.satellite
        locMgr.delegate = self
        checkLocationAuthorizationStatus()
        locMgr.desiredAccuracy = kCLLocationAccuracyBest
        locMgr.startUpdatingLocation()
        centerOnUser()
        isRecording = false
    }
    
    func initializeButtons() {
        mapTypeButton.layer.cornerRadius = 5
        mapTypeButton.layer.borderWidth = 1
        mapTypeButton.layer.borderColor = UIColor.black.cgColor
        centerButton.layer.cornerRadius = 5
        centerButton.layer.borderWidth = 1
        centerButton.layer.borderColor = UIColor.black.cgColor
        recordButton.layer.cornerRadius = 5
        recordButton.layer.borderWidth = 1
        recordButton.layer.borderColor = UIColor.black.cgColor
        mapTypeButton.setTitle("Street", for: .normal)
    }
    
    @IBAction func mapTypeButtonTapped(_ sender: Any) {
        if mapView.mapType == MKMapType.satellite {
            mapView.mapType = MKMapType.standard
            mapTypeButton.setTitle("Satellite", for: .normal)
        } else {
            mapView.mapType = MKMapType.satellite
            mapTypeButton.setTitle("Street", for: .normal)
        }
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
        let currentLocation = locations[0]
        currentLocLabel.text = String(currentLocation.coordinate.latitude.rounded()) + ", " + String(currentLocation.coordinate.longitude.rounded()) + " Heading: \(currentLocation.course)"
        if isRecording {
            flightPath.append(currentLocation)
            if flightPath.count > 1 {
                let firstIndex = flightPath.count - 1
                let nextIndex = flightPath.count - 2
                let lineSegment = [flightPath[firstIndex].coordinate, flightPath[nextIndex].coordinate]
                let polyLine = MKPolyline(coordinates: lineSegment, count: lineSegment.count)
                mapView.add(polyLine)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.cyan
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func centerOnUser() {
        if let coordinate = locMgr.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 3000, 3000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        centerOnUser()
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        // Start recording actions
        if isRecording {
            isRecording = false
            let flight = Flight(context: context)
            //let data = NSKeyedArchiver.archivedData(withRootObject: flightPath)
            
            let alertVC = UIAlertController(title: "Save Flight", message: "Give your flight a name!", preferredStyle: .alert)
            alertVC.addTextField { (textField) in
                textField.text = "flightName"
            }
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alertVC] (_) in
                let textField = alertVC?.textFields![0]
                print("Text field: \(textField?.text)")
                flight.name = textField?.text
            }))
            present(alertVC, animated: true, completion: nil)
            flight.path = "Location of Flight Data saved" // Get file path
            flight.date = Date()
            flight.from = "KSFO" // Get from airport
            flight.to = "KSJC"  // Get nearest airport
            appDelegate.saveContext()
            print("Recording stopped")
            flightPath = []
        } else {
            mapView.removeOverlays(mapView.overlays)
            isRecording = true
            print("Now recording")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

