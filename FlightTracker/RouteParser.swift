//
//  RouteParser.swift
//  FlightTracker
//
//  Created by Michael Zhou on 2018-08-08.
//  Copyright © 2018 Michael Zhou. All rights reserved.
//

import MapKit

func parseDataPoints(str: String) -> [CLLocation] {
    var path : [CLLocation] = []
    let latLons = str.split(separator: "+")
    
    for latLon in latLons {
        let coordinateArr = latLon.split(separator: ";")
        path.append(CLLocation(latitude: Double(coordinateArr[0])!, longitude: Double(coordinateArr[1])!))
    }
    
    return path
}
