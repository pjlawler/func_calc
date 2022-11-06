//
//  CalculatorModel.swift
//  calculator
//
//  Created by Patrick Lawler on 11/2/22.
//

import Foundation

class CalculatorModel {
    
    static let shared = CalculatorModel()
    private init() {}
    
    let network = NetworkManager.shared
    let storage = LocalStorageManager.shared
    var exchangeRates: RateData!
    var displayResultAsTime: Bool?
    var auxDisplay: String?
    var displayRegister: String!
    var mathRegister: String!
    var operationRegister: String!
    var calculationList = ""
    var mode: CalcModes = .all_clear
    
    
    func keypadTapped(key: String) {
    
        // handles when any of the calculator keypad keys are tapped
        
        if mode == .displaying_error && key != "AC" { return }
        
        switch key {
        case "AC": clearAll()
        case "CE": clearEntry()
        case "=": equalsTapped()
        case "%": percentTapped()
        case "±": toggleNegative()
        case "+", "-", "×","÷": operatorTapped(oper: key)
        default: numericTapped(numberKey: key)
        }
    }
    
    
    private func clearAll() {

        // clears all of the calculator's registers

        displayRegister = nil
        operationRegister = nil
        mathRegister = nil
        displayResultAsTime = nil
        calculationList = ""
        auxDisplay = nil
        mode = .all_clear
    }
    
    
    private func clearEntry() {
        switch mode {
        
        case .entering_first:
            displayRegister = nil
            mode = .all_clear
        
        case .entering_second:
            displayRegister = nil
            mode = .awaiting_second
        
        case .awaiting_second:
            operationRegister = nil
            mode = .entering_first
            resetDisplayRegister()
            
        default:
            return
        }
    }
    
    
    private func equalsTapped() {
        performMath()
        calculationList = ""
    }
    
    
    private func percentTapped() {
        switch mode {

        case .entering_first:
            let result: Double = displayRegister == nil ? 0.0 : (displayRegister as NSString).doubleValue / 100
            setDisplayRegisterWithDecimal(result)
        
        case .entering_second:
            let mathRegister: Double = mathRegister == nil ? 0.0 : (mathRegister as NSString).doubleValue
            let displayRegister: Double = displayRegister == nil ? 0.0 : (displayRegister as NSString).doubleValue
            let result = displayRegister/100 * mathRegister
            setDisplayRegisterWithDecimal(result)

        default:
            return
        }
    }
    
    
    private func toggleNegative() {
        
        // ensures that display is a non-zero number
        if displayRegister == nil || displayRegister == "0" { return }
        
        let result: Double = (displayRegister as NSString).doubleValue * -1
        setDisplayRegisterWithDecimal(result)
    }
    
    
    private func operatorTapped(oper: String) {
        
        // peforms the functions when an operator is tapped on the keypad based on the mode of the calculator
        displayResultAsTime = false
        
        switch mode {
        
        case .all_clear, .entering_first, .operation_complete:
            
            // stores the math operator and gets setup to accept the second number
            
            operationRegister = oper
            mathRegister = displayRegister != nil ? displayRegister : "0"
            mode = .awaiting_second
        
        case .entering_second:
            
            // performs the operation and gets setup to accept the another number
        
            performMath()
            
            guard mode != .displaying_error else { return }
            
            // sets up for the next operation
            mathRegister = displayRegister
            operationRegister = oper
            mode = .awaiting_second
    
        case .awaiting_second:
            
            // changes the operator before the second number starts getting entered
            operationRegister = oper
            
        default:
            
            // returns if the calculator is in any other mode
            return
        }
    }
    
    
    private func numericTapped(numberKey: String) {

        // performs the functions if a number or . is tapped on the keypad based on the mode of the calculator
             
        switch mode {
            
        case .all_clear:
            
            // first number being entered into the calculator
            
            displayRegister = numberKey
            mode = .entering_first
            
        case .entering_first, .entering_second:
            
            // user is entering numbers into the register
            
            let registerValue: Double = displayRegister == nil ? 0.0 : (displayRegister as NSString).doubleValue
            
            // limits the number the user can type into the calculator
            guard abs(registerValue) < 100000000 else { return }
                        
            // ensures only one decimal is entered in the display regester
            if displayRegister.contains(".") && numberKey == "." { return }
            if displayRegister.contains(":") && (numberKey == "." || numberKey == ":") { return }
            
            // if the display is showing 0, then any number will replace the zero
            displayRegister = displayRegister == "0" ? numberKey : displayRegister + numberKey
            
        case .awaiting_second:
            
            // awaiting the next number for the calculation
            displayRegister = numberKey
            mode = .entering_second
            
        case .operation_complete:
            
            // user starts entering a new number after they pressed the equals
            
            mathRegister = displayRegister != nil ? displayRegister : "0"
            displayRegister = numberKey
            operationRegister = nil
            mode = .entering_first
       
        default:
            return
        }
    }
    
    
    private func performMath() {
        
        // performs the math operation on the math and display registers using the operator that is stored in the operation register
        
        let lhs = doubleValueOf(mathRegister)
        let rhs = doubleValueOf(displayRegister)
        let result: Double!
        
        displayResultAsTime = mathRegister.contains(":") || displayRegister.contains(":")
         
        switch operationRegister {
        case "+": result = lhs + rhs
        case "-": result = lhs - rhs
        case "×": result = lhs * rhs
        case "÷":
            if(rhs == 0) {
                setDisplayRegisterWithErrorText("Divide by Zero!")
                return }
            result = lhs / rhs
        default:
            return
        }
             
        let math = formatAuxNumber(number: mathRegister)
        let display = formatAuxNumber(number: displayRegister)
        
        if calculationList.count == 0 {
            calculationList = "\(math) \(operationRegister ?? "?") \(display)"
        }
        else {
            calculationList = calculationList + " \(operationRegister ?? "?") \(display)"
        }
        
        auxDisplay = calculationList
        
        setDisplayRegisterWithDecimal(result)
        mode = .operation_complete
    }
    
    
    private func formatAuxNumber(number: String?) -> String {
        
        if (number != nil && ((number!.contains(":")) == true )) {
            return number!
        }
        else {
            let register = doubleValueOf(number) as NSNumber
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumIntegerDigits = 1
            formatter.groupingSeparator = ","
            return formatter.string(from: register) ?? "0"
        }
    }
    
    
    private func setDisplayRegisterWithDecimal(_ decimal:Double) {
        
        if decimal == trunc(decimal) && decimal < Double(Int.max) {
            displayRegister = String(Int(decimal))
        } else {
            displayRegister = String(decimal)
        }
    }
    
    
    private func setDisplayRegisterWithTime(_ time: String) {
        displayRegister = time
    }
    
    
    private func resetDisplayRegister() {
        guard mathRegister != nil else { return }
        displayRegister = mathRegister
    }
    
    
    private func setDisplayRegisterWithErrorText(_ errorText:String) {
        displayRegister = errorText
        auxDisplay = "Error!"
        mode = .displaying_error
    }
}

extension CalculatorModel {
    
    // publicly available functions
    
    
    func backspace() {

        // updates the display register when the display is swipped right

        guard displayRegister != nil else { return }
        
        if displayRegister.count == 1 { displayRegister = "0" }
        else { displayRegister.remove(at: displayRegister.index(before: displayRegister.endIndex)) }
    }
    
    
    func toggleTimeDisplay() {
        
        // swaps display between decimal and time
        
        let registerValue = doubleValueOf(displayRegister)
        
        if displayRegister == nil || !displayRegister.contains(":") {
            setDisplayRegisterWithTime(Convert().doubleToTime(registerValue))
        }
        else {
            setDisplayRegisterWithDecimal(registerValue)
        }
        mode = .operation_complete
    }
    
    
    func doubleValueOf(_ register: String?) -> Double {
        
        // returns the value of what's stored in the passed in register
        
        // if register is nil, then returs 0.0
        guard let _ = register else { return 0.0 }
        
        // if register contains time, then converts time to double
        if register!.contains(":") { return Convert().timeToDecimal(register!) }
        
        // converts register string to double
        return (register! as NSString).doubleValue
    }
    
    
    func updateExchangeRates() {
        
        // gets the rates, if any, that are saved in local storage and stores them in the local variable.
        // if there is local storage is empty or it's older than 1-hour old it will attempt to download the latest
                
        retrieveRates()
        
        // if the rates need to be updated, it downloads them from through the network manager
        if exchangeRates == nil || exchangeRates.isOverHourOld {
            network.getRates() { [weak self] result in
                guard let self = self else {return }
                switch result {
                case .success(let success):
                    
                    // stores the rates in the local variable
                    self.exchangeRates = success
                    print("downloaded the latest rates!")
                    
                    // saves the downloaded rates to local storage
                    if self.storage.saveExchangeRates(success) {
                        print("rates were saved to local storage!")
                    }
                case .failure(let failure):
                    print("network manager error - \(failure)")
                }
            }
        }
    }
    
    
    private func retrieveRates() {
        storage.retrieveRateData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.exchangeRates = success
                print("retrieved rates from local storage")

            case .failure(let failure):
                print("local storage manager error - \(failure)")
            }
        }
    }
}

extension CalculatorModel {
    
    
    private func performConversion(with number: Double, from fromUnit: ConversionUnit, to toUnit: ConversionUnit) {
        
        // look up units
        //        ConversionUnit(title: "U.S. Cup", multiplier: 0.2365882365, category: Categories.volume, symbol: "cup", favorite: nil, answerPrefix: nil, answerSuffix: " cp"),
        //        ConversionUnit(title: "U.S. Gallon", multiplier: 3.785411784, category: Categories.volume, symbol: "gal", favorite: nil, answerPrefix: nil, answerSuffix: " gal"),

    }
    
    
    
    
}
