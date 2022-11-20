//
//  UserDefaults.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/6/22.
//

import Foundation

struct DefaultData: Codable {
    var baseCurrency: String?
    var functionButtons = ["","","","","","","",""]
    var favorites: [String]?
    var showingFavorites: Bool?
    var errorWarningTimeStamp: Int?
    
    var hoursSinceWarned: Int {
        
        // if the network erro warning was display returns the hours since last shown to user
        guard errorWarningTimeStamp != nil else { return 0 }
        return (Int(Date().timeIntervalSince1970) - errorWarningTimeStamp!) / 3600
    }
    
    var showingFavoritesWithNoneSelected: Bool {
        guard showingFavorites != nil else { return false }
        if showingFavorites == false { return false }
        guard favorites != nil else { return true }
        return favorites!.count == 0
    }
    
    var firstOpenPreset: Int? {
        for (index, button) in functionButtons.enumerated() {
            if button == "" { return index }
        }
        return nil
    }
}



  
