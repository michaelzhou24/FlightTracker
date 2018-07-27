//
//  UserLocAnnotation.swift
//  FlightTracker
//
//  Created by Michael Zhou on 2018-07-26.
//  Copyright © 2018 Michael Zhou. All rights reserved.
//

import Foundation
import MapKit

class UserLocAnnotation : MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        image = UIImage(named: "plane")
        frame.size.height = 50
        frame.size.width = 50
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onUpdateHeadingRotateImg(heading: CGFloat) {
        transform = CGAffineTransform(rotationAngle: heading)
    }
    
}

