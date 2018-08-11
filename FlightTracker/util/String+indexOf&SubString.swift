//
//  String+indexOf.swift
//  FlightTracker
//
//  Created by Michael Zhou on 2018-08-10.
//  Copyright © 2018 Michael Zhou. All rights reserved.
//

import Foundation

extension String {
    func indexOf(_ input: String,
                 options: String.CompareOptions = .literal) -> Int? {
        return self.range(of: input, options: options)?.lowerBound.encodedOffset
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}
