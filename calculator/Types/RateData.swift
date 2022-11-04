//
//  RateData.swift
//  calculator
//
//  Created by Patrick Lawler on 11/2/22.
//

import Foundation

struct RateData {
    var timestamp: Int
    var base: String
    var rates: [String: Double?]
}
