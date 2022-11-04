//
//  RateData.swift
//  calculator
//
//  Created by Patrick Lawler on 11/2/22.
//

import Foundation

struct RateData: Codable {
    var timestamp: Int
    var base: String
    var rates: [String: Double?]
      
    
    
    var isOverHourOld: Bool {
        return (Date().timeIntervalSince1970 - Double(timestamp)) > 3600
    }
    
    var dateOfData: String {
        let date = Date(timeIntervalSince1970: Double(timestamp))
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        return formatter.string(from: date)
    }
    
    var timeOfData: String {
        let date = Date(timeIntervalSince1970: Double(timestamp))
        let formatter = DateFormatter()
        formatter.timeStyle = .long
        
        return formatter.string(from: date)
    }
}

