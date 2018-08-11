//
//  RouteParser.swift
//  FlightTracker
//
//  Created by Michael Zhou on 2018-08-08.
//  Copyright © 2018 Michael Zhou. All rights reserved.
//

import MapKit
import UIKit

func parseDataPoints(str: String) -> [CLLocation] {
    var end = 0
    var posn = 0
    var path : [CLLocation] = []
    
    while posn < str.count {
        end = str.substring(from: posn).indexOf(";")!
        var lat = Double(str.substring(with: posn..<end))
        posn = end + 1
        
        end = str.substring(from: posn).indexOf(";")!
        var lon = Double(str.substring(with: posn..<end))
        posn = end + 1
        
        path.append(CLLocation(latitude: lat!, longitude: lon!))
    }
    
    return path
}
