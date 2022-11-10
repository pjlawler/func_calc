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
        return secondsSinceDownload > 3600
    }
    
    var status: String {
        
        if !isOverHourOld { return "Exchange Rates Are Current"}
        
        var timeFrame = ""
        
        switch secondsSinceDownload {
        case ...7200:
            timeFrame = "1 hour old"
        case 7201...172800:
            timeFrame = "\(secondsSinceDownload / 3600) hours old"
        default:
            timeFrame = "\(secondsSinceDownload / 86400) days old (\(dateOfData))"
        }
        
        return """
Exchange Rates are not current!
\(timeFrame).
"""
    }
    
    var secondsSinceDownload: Int {
        return Int(Date().timeIntervalSince1970 - Double(timestamp))
    }
    
    var dateOfData: String {
        let date = Date(timeIntervalSince1970: Double(timestamp))
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return formatter.string(from: date)
    }
    
    var timeOfData: String {
        let date = Date(timeIntervalSince1970: Double(timestamp))
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
}

