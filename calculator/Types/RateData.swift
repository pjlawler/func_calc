//
//  RateData.swift
//  calculator
//
//  Created by Patrick Lawler on 11/2/22.
//

import Foundation

struct RateData: Codable {
    var timestamp: Int?
    var base: String?
    var rates: [String: Double?]?
    
    enum Status: String {
        case current
        case empty
        case one_hour_old
        case hours_old
        case days_old
    }
    
    var isOverHourOld: Bool {
        return downloadStatus != .current
    }
    
    var downloadStatus: Status {
        
        guard rates != nil && rates!.count > 0 else { return Status.empty }
        switch secondsSinceDownload {
        case ...3600: return Status.current
        case 3601...7200: return Status.one_hour_old
        case 7201...172800: return Status.hours_old
        default: return Status.days_old
        }
    }
    
    var alertMessage: String {
        
        var timeFrame = ""
        
        let no_data = """
Due to a network issue (i.e., no internet connection) no exchange rates have not been downloaded as of yet.

Unfortunately, the app cannot convert currencies without this data. It will download automatically once connectivity is restored.
"""
        
        switch downloadStatus {
        case .empty: return no_data
        case .current: return ""
        case .one_hour_old: timeFrame = "1-hour old"
        case .hours_old: timeFrame = "\(secondsSinceDownload / 3600) hours old"
        default: timeFrame = "\(secondsSinceDownload / 86400) days old (\(dateOfData))"
        }
        
        return """
Due to a network issue (i.e., no internet connection) the exchange rates have not been updated.

However, the app will still convert currencies using last downloaded exchange rates which are \(timeFrame).  The rates will automatically update once connectivity is restored.
"""
    }
    
    var moreInfoMessage: String {
        var timeFrame = ""
        
        switch downloadStatus {
        case .empty: return "No Exchange Rates Downloaded"
        case .current: return "Exchange Rates Are Current"
        case .one_hour_old: timeFrame = "1-hour old"
        case .hours_old: timeFrame = "\(secondsSinceDownload / 3600) hours old"
        default: timeFrame = "\(secondsSinceDownload / 86400) days old (\(dateOfData))"
        }
        return """
Exchange Rates are not current!
\(timeFrame).
"""
    }
    
    var secondsSinceDownload: Int {
        guard timestamp != nil else { return 0 }
        return Int(Date().timeIntervalSince1970 - Double(timestamp!))
    }
    
    var dateOfData: String {
        guard timestamp != nil else { return "" }
        let date = Date(timeIntervalSince1970: Double(timestamp!))
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return formatter.string(from: date)
    }
    
    var timeOfData: String {
        guard timestamp != nil else { return "" }
        let date = Date(timeIntervalSince1970: Double(timestamp!))
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
}

