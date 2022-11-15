//
//  CalcRegister.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/7/22.
//

import Foundation

struct CalcRegister {
    
    var data: String?
    
    private var maxValue = 100000000.0
       
    var isDisplayingTime: Bool {
        guard let _ = data else { return false }
        return data!.contains(":")
    }
    
    var isMax: Bool {
        return abs(decimalValue) >= maxValue
    }
    
    var containsDecimalOrColon: Bool {
        guard let _ = data else { return false }
        return (data?.contains(".") == true || data?.contains(":") == true)
    }
    
    var decimalValue: Double {
        
        guard let _ = data else { return 0.0 }
        
        var tempData = ""
        
        // removes any non-decimal or non-time characters fromt he display register (e.g. function data)
        for char in data! {
            if ["0", "1", "2", "3", "4", "5","6","7","8", "9",".","-",":"].contains(char) {
                tempData += String(char)
            }
        }
        
        // returns the value if it's not time
        if !isDisplayingTime {
           return (tempData as NSString).doubleValue
        }
        
        // if it is time, it converts it to a double and returns
        else {
            return Utilities().timeToDecimal(tempData)
        }
    }
    
    var displayFormatted: String {
        if isDisplayingTime { return formattedTime }
        else { return formattedDecimal }
    }
    
    var formattedCurrency: String {
        
        guard abs(decimalValue) < 9999999999.99 else {return "Error"}
        
        let formatter =  NumberFormatter()
        formatter.numberStyle = .currency
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        formatter.alwaysShowsDecimalSeparator = true

        return formatter.string(from: decimalValue as NSNumber)!
    }
        
    var formattedDecimal: String {
        
        guard let _ = data else { return "0" }
        
        let useScientific = abs(decimalValue) > 9999999999.99
        let showDecimal = data!.contains(".") && !useScientific
        var significantDigits = 1
        var trailingZeros = ""
        let formatter =  NumberFormatter()
        
        
        if !useScientific {
            
            // determines max fraction digits and number of trailing zeros (i.e. 1.00000) in the display register
            
            // calculates how many digits to the left of the decimal, if any. If none it uses 1 (for a zero placeholder)
            significantDigits = data!.count > 1 && data!.first != "." ? data!.split(separator: ".")[0].count : 1
            
            // checks to see how many trailing 0's are after the end of the decimal, if any
            if data!.contains(".") && data!.last != "." {
                
                var count = 0
                
                // if nothing on the left side of the split uses zero for the fraction index
                let fractionPart = data!.first == "." ? 0 : 1
                
                // looks at each char after the . to see how many trailing zeros there are
                for char in data!.split(separator: ".")[fractionPart] {
                    if char == "0" { count += 1} else { count = 0 }
                }
                
                // creates a string of trailing zeros to add to the display
                trailingZeros = String(repeating: "0", count: count)
            }
        }
    
        formatter.numberStyle = useScientific ? .scientific : .decimal
        formatter.exponentSymbol = "e"
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        formatter.alwaysShowsDecimalSeparator = showDecimal
        formatter.maximumIntegerDigits = useScientific ? 3 : 10
        formatter.maximumFractionDigits = useScientific ? 3 : 9 - significantDigits
        
        var formattedNumber = formatter.string(from: decimalValue as NSNumber)! + trailingZeros
        
        while formattedNumber.count > 13 {
            formattedNumber = String(formattedNumber.dropLast(1))
        }
                
        return  formattedNumber
    }
    
    var truncatedZeros: String {
        let decimal = decimalValue
        if decimal == trunc(decimal) && decimal < Double(Int.max) {
            return String(Int(decimal))
        } else {
            return String(decimal)
        }
    }
        
    var formattedTime: String {
        return Utilities().doubleToTime(decimalValue)
    }
}
