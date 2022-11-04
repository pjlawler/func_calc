//
//  Utilities.swift
//  calculator
//
//  Created by Patrick Lawler on 11/1/22.
//

import UIKit


enum ScreenSize {
    static let width                    = UIScreen.main.bounds.size.width
    static let height                   = UIScreen.main.bounds.size.height
    static let maxLength                = max(ScreenSize.width, ScreenSize.height)
    static let minLength                = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceTypes {
    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale
    
    static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard        = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed          = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard    = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed      = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX                = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr       = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad                   = idiom == .pad && ScreenSize.maxLength >= 1024.0
    
    static func isIphoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}

struct Convert {
    func timeToDecimal(_ time: String) -> Double {
        
        guard time.contains(":") else { return 0.0 }
        
        let timeParts = time.split(separator: ":")
        let hours: Double = Double(Int(timeParts[0]) ?? 0)
        let minutes: Double = (timeParts.endIndex > 1 ? Double(Int(timeParts[1]) ?? 0) : 0) / 60
        
        return hours + minutes
    }
    
    func decimalToTime(_ number: Double) -> String {
        
        let hours = String(Int(number))
        var minutes = String(Int(((number - Double(Int(number))) * 60).rounded()))
        if minutes.count < 2 { minutes = "0" + minutes}
        
        return "\(hours):\(minutes)"
    }
}


