//
//  PathViewController.swift
//  FlightTracker
//
//  Created by Michael Zhou on 2018-08-20.
//  Copyright © 2018 Michael Zhou. All rights reserved.
//

import UIKit
import MapKit

class PathViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var flight : Flight = Flight()
    var pathInCoordinates : [CLLocation] = []
    @IBOutlet weak var mapTypeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        pathInCoordinates = parseDataPoints(str: flight.path!)
        plotCoordinates()
        let region = MKCoordinateRegionMakeWithDistance(pathInCoordinates[0].coordinate, 3000, 3000)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func centreButton(_ sender: Any) {
        let region = MKCoordinateRegionMakeWithDistance(pathInCoordinates[0].coordinate, 3000, 3000)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func changeMapViewButton(_ sender: Any) {
        if mapView.mapType == MKMapType.satellite {
            mapView.mapType = MKMapType.standard
            mapTypeButton.setTitle("Satellite", for: .normal)
        } else {
            mapView.mapType = MKMapType.satellite
            mapTypeButton.setTitle("Street", for: .normal)
        }
    }
    
    func plotCoordinates() {
        for index in 1...pathInCoordinates.count-1 {
            let lineSegment = [pathInCoordinates[index-1].coordinate, pathInCoordinates[index].coordinate]
            let polyLine = MKPolyline(coordinates: lineSegment, count: lineSegment.count)
            mapView.add(polyLine)
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

}
