//
//  Conversions.swift
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

func formatTime(seconds: Int) -> String {
    let min = seconds / 60
    let sec = seconds % 60
    if (sec < 10) && (min < 10) {
        return "0\(min):0\(sec)"
    }
    if sec < 10 {
        return "\(min):0\(sec)"
    }
    if min < 10 {
        return "0\(min):\(sec)"
    }
    return "\(min):\(sec)"
}
