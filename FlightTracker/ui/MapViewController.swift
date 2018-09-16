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
import CoreGraphics

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeButton: UIButton!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var altitudeButton: UIButton!
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var timeElapsedButton: UIButton!
    
    var userLocAnnotation : UserLocAnnotation?
    var locMgr = CLLocationManager()
    var flightPath : [CLLocation] = []
    var isRecording = false
    var timer = Timer()
    var timeCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        locMgr.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            mapView.showsUserLocation = true
        } else {
            locMgr.requestAlwaysAuthorization()
            self.viewDidLoad()
        }
        locMgr.desiredAccuracy = kCLLocationAccuracyBest
        locMgr.startUpdatingLocation()
        centerOnUser()
        isRecording = false
        initializeButtons()
    }
    
    func initializeButtons() {
        mapTypeButton.setTitle("Satellite", for: .normal)
        altitudeButton.setTitle("\(Int((locMgr.location?.course)!))", for: .normal)
        speedButton.setTitle("\(mphToKnots(speed: (locMgr.location?.speed)!)) kts", for: .normal)
        timeElapsedButton.setTitle("00:00", for: .normal)
        
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[0]
        
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
        userLocAnnotation?.onUpdateHeadingRotateImg(heading: degreesToRadians(degrees: CGFloat(currentLocation.course)))
        UIView.performWithoutAnimation {
            self.altitudeButton.setTitle("\(Int((locMgr.location?.course)!))", for: .normal)
            self.speedButton.setTitle("\(mphToKnots(speed: (locMgr.location?.speed)!)) kts", for: .normal)
            self.altitudeButton.layoutIfNeeded()
            self.speedButton.layoutIfNeeded()
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        userLocAnnotation = UserLocAnnotation(annotation: annotation, reuseIdentifier: nil)
        return userLocAnnotation
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
                print("Text field: \(String(describing: textField?.text))")
                flight.name = textField?.text
            }))
            present(alertVC, animated: true, completion: nil)
            flight.path = storeFlightData()
            print(flight.path!)
            flight.date = Date()
            flight.duration = Int16(timeCounter)
            timer.invalidate()
            appDelegate.saveContext()
            print("Recording stopped")
            flightPath = []
        } else {
            mapView.removeOverlays(mapView.overlays)
            isRecording = true
            print("Now recording")
            timeCounter = 0
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
    }
    
    func storeFlightData() -> String {
        var data = ""
        for dataPoint in flightPath {
            data += "+\(dataPoint.coordinate.latitude);\(dataPoint.coordinate.longitude)"
        }
        return data
    }
    
    @objc func updateTime() {
        timeCounter += 1
        UIView.performWithoutAnimation {
            self.timeElapsedButton.setTitle(formatTime(seconds: timeCounter), for: .normal)
            self.timeElapsedButton.layoutIfNeeded()
        }
    }
}

