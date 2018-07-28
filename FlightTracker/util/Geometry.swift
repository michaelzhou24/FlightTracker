//
//  Geometry.swift
//  FlightTracker
//
//  Created by Michael Zhou on 2018-07-26.
//  Copyright © 2018 Michael Zhou. All rights reserved.
//

import Foundation
import CoreGraphics

func degreesToRadians(degrees: CGFloat) -> CGFloat {
    return degrees * CGFloat(Double.pi) / 180
}

func radiansToDegrees(radians: CGFloat) -> CGFloat {
    return radians * 180 / CGFloat(Double.pi)
}

func mphToKnots(speed: Double) -> Int {
    return Int(speed * (5280 / 6075))
}
