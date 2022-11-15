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

struct Utilities {
    
    func timeToDecimal(_ time: String) -> Double {
        
        let hours: Double!
        let minutes: Double!
        let timeParts = time.split(separator: ":")
        
        switch timeParts.count {
        case 0:
            hours = 0
            minutes = 0
        case 1:
           hours = time.last == ":" ? Double(Int(timeParts[0])!) : 0
            minutes = time.last == ":" ? 0 : Double(Int(timeParts[0])!) / 60
        default:
            hours = Double(Int(timeParts[0])!)
            minutes = Double(Int(timeParts[1])!) / 60
        }
        
        return hours + minutes
    }
    
    func doubleToTime(_ number: Double) -> String {
        
        let hours = String(Int(number))
        var minutes = String(Int(((number - Double(Int(number))) * 60).rounded()))
        if minutes.count < 2 { minutes = "0" + minutes}
        
        return "\(hours):\(minutes)"
    }
    
    func formatDecimalNumber(number: Double, as type: DisplayAs ) -> String {

        // formats the decimla number into the proper format for the results displays
        
        let formatter = NumberFormatter()
        let isWholeNumber = number == trunc(number)
        
        var multiplier = 0.0
        var roundedNumber = 0.0
        var minimumFractionDigits = 0
        var maximumFractionDigits = 0
                
        switch type {
        
        case .currency:
            minimumFractionDigits = isWholeNumber ? 0 : 2
            maximumFractionDigits = isWholeNumber ? 0 : 2
            multiplier = 1 / 0.01
            
        case .temperature:
            maximumFractionDigits = 1
            multiplier = 1 / 1
            
        case .time:
            return Utilities().doubleToTime(number)
        
        default:
            maximumFractionDigits = 9 - String(Int(number)).count
            multiplier = 1 / 0.001
        }
        
        roundedNumber = (number * multiplier).rounded() / multiplier
        
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = roundedNumber == trunc(roundedNumber) ? 0 : maximumFractionDigits
        
        return formatter.string(from: roundedNumber as NSNumber) ?? "0"
    }
    
    func formulaResult(formulaString: String, variables: [Double]) -> Double {
       
        guard variables.count < 9 else { return 0.0 }
        
        var formula = formulaString
        formula     = formula.replacingOccurrences(of: String(Symbols.hourglass), with: "")
        formula     = formula.replacingOccurrences(of: "[Pi]", with: "\(Double.pi)")

        var a = 0.0, b = 0.0, c = 0.0, d = 0.0, e = 0.0, f = 0.0, g = 0.0, h = 0.0
        
        for (variableCount, variable) in variables.enumerated() {
            switch variableCount {
            case 0: a = variable
            case 1: b = variable
            case 2: c = variable
            case 3: d = variable
            case 4: e = variable
            case 5: f = variable
            case 6: g = variable
            case 7: h = variable
            default: break
            }
        }
        
        formula = formula.replacingOccurrences(of: "?a", with: "\(a)")
        formula = formula.replacingOccurrences(of: "?b", with: "\(b)")
        formula = formula.replacingOccurrences(of: "?c", with: "\(c)")
        formula = formula.replacingOccurrences(of: "?d", with: "\(d)")
        formula = formula.replacingOccurrences(of: "?e", with: "\(e)")
        formula = formula.replacingOccurrences(of: "?f", with: "\(f)")
        formula = formula.replacingOccurrences(of: "?g", with: "\(g)")
        formula = formula.replacingOccurrences(of: "?h", with: "\(h)")
        
        let mathExpression = NSExpression(format: formula)
        
        return (mathExpression.expressionValue(with: nil, context: nil) as? Double)!
    }
    
    func convertTemperature(amount: Double, from: String, to: String ) -> Double {
        
        switch "\(from) to \(to)" {
        case "\(Symbols.celsius) to \(Symbols.fahrenheit)": return (amount * 1.8 + 32)
        case "\(Symbols.fahrenheit) to \(Symbols.celsius)": return ((amount - 32) / 1.8)
        case "\(Symbols.celsius) to \(Symbols.kelvin)": return (amount + 273.15)
        case "\(Symbols.fahrenheit) to \(Symbols.kelvin)": return (((amount - 32) / 1.8 ) + 273.15)
        case "\(Symbols.kelvin) to \(Symbols.celsius)": return (amount - 273.15)
        case "\(Symbols.kelvin) to \(Symbols.fahrenheit)": return ((amount - 273.15) * 1.8 + 32)
        default:
            return 0.0
        
        }
    }
}

