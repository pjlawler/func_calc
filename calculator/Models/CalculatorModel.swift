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
    var userDefaults: DefaultData!
    var exchangeRates: RateData!
    var auxDisplay: String?
    var displayRegister = CalcRegister()
    var mathRegister = CalcRegister()
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
    
    func saveTestData() {
        storeUserDefaults()
    }
    
    
    private func clearAll() {

        // clears all of the calculator's registers

        displayRegister.data = nil
        operationRegister = nil
        mathRegister.data = nil
        calculationList = ""
        auxDisplay = nil
        mode = .all_clear
    }
    
    
    private func clearEntry() {
        switch mode {
        
        case .entering_first:
            displayRegister.data = nil
            mode = .all_clear
        
        case .entering_second:
            displayRegister.data = nil
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
            setDisplayRegister(data: displayRegister.decimalValue / 100)
        
        case .entering_second:
            let mathRegister = mathRegister.decimalValue
            let displayRegister = displayRegister.decimalValue
            let result = displayRegister/100 * mathRegister
            setDisplayRegister(data: result)

        default:
            return
        }
    }
    
    
    private func toggleNegative() {
        
        // ensures that display is a non-zero number
        if displayRegister.data == nil || displayRegister.data == "0" { return }
        
        let result: Double = displayRegister.decimalValue * -1
        setDisplayRegister(data: result)

    }
    
    
    private func operatorTapped(oper: String) {
        
        // peforms the functions when an operator is tapped on the keypad based on the mode of the calculator
        
        switch mode {
        
        case .all_clear, .entering_first, .operation_complete:
            
            // stores the math operator and gets setup to accept the second number
            
            operationRegister = oper
            mathRegister.data = displayRegister.data
            mode = .awaiting_second
        
        case .entering_second:
            
            // performs the operation and gets setup to accept the another number
        
            performMath()
            
            // sets up for the next operation
            mathRegister.data = displayRegister.data
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
            
            displayRegister.data = numberKey
            mode = .entering_first
            
        case .entering_first, .entering_second:
            
            // user is entering numbers into the register
            
            guard displayRegister.data != nil else { return }
            
            // limits the number the user can type into the calculator
            guard !displayRegister.isMax else { return }
                        
            // ensures only one decimal and/or colon is entered in the display regester
            if displayRegister.containsDecimalOrColon && (numberKey == "." || numberKey == ":") { return }
            
            // if the display is showing 0, then any number will replace the zero
            displayRegister.data = displayRegister.data == "0" ? numberKey : displayRegister.data! + numberKey
            
        case .awaiting_second:
            
            // awaiting the next number for the calculation
            
            displayRegister.data = numberKey
            mode = .entering_second
            
        case .operation_complete:
            
            // user starts entering a new number after they pressed the equals
            
            mathRegister.data = displayRegister.data
            displayRegister.data = numberKey
            operationRegister = nil
            mode = .entering_first
       
        default:
            return
        }
    }
    
    
    private func performMath() {
        
        // performs the math operation on the math and display registers using the operator that is stored in the operation register
        
        let lhs = mathRegister.decimalValue
        let rhs = displayRegister.decimalValue
        let result: Double!
        
        guard (rhs != 0 && operationRegister != "") else {
            setDisplayRegisterWithErrorText("Divide by Zero!")
            return
        }
        
        switch operationRegister {
        case "+": result = lhs + rhs
        case "-": result = lhs - rhs
        case "×": result = lhs * rhs
        case "÷": result = lhs / rhs
        default: return
        }
        
        // sets up to format the registers for the aux display
        let math = mathRegister.displayFormatted
        let display = displayRegister.displayFormatted
        if calculationList.count == 0 { calculationList = "\(math) \(operationRegister ?? "?") \(display)" }
        else { calculationList = calculationList + " \(operationRegister ?? "?") \(display)" }
        auxDisplay = calculationList
        
        // sets the display register to display time if either of the registers were formatted as time
        let displayResultAsTime = mathRegister.isDisplayingTime || displayRegister.isDisplayingTime
        setDisplayRegister(data: result, asTime: displayResultAsTime)
        
        mode = .operation_complete
    }
    
        
    private func setDisplayRegister(data decimal: Double, asTime: Bool = false) {
        
        if !asTime {
            if decimal == trunc(decimal) && decimal < Double(Int.max) {  displayRegister.data = String(Int(decimal)) }
            else { displayRegister.data = String(decimal) }
        }
        else {
            displayRegister.data = Convert().doubleToTime(decimal)
        }
        
    }
        
    
    private func resetDisplayRegister() {
        displayRegister.data = mathRegister.data
    }
    
    
    private func setDisplayRegisterWithErrorText(_ errorText:String) {
        displayRegister.data = errorText
        auxDisplay = "Error!"
        mode = .displaying_error
    }
    
 
}

extension CalculatorModel {
    
    // publicly available functions
    
    
    func backspace() {

        // updates the display register when the display is swipped right

        guard displayRegister.data != nil else { return }
        
        if displayRegister.data!.count == 1 { displayRegister.data = "0" }
        else { displayRegister.data!.remove(at: displayRegister.data!.index(before: displayRegister.data!.endIndex)) }
    }
    
    
    func toggleTimeDisplay() {
        
        // swaps display between decimal and time
        setDisplayRegister(data: displayRegister.decimalValue, asTime: !displayRegister.isDisplayingTime)
        mode = .operation_complete
    }
      
    
    func updateExchangeRates() {
        
        // gets the rates, if any, that are saved in local storage and stores them in the local variable.
        // if there is local storage is empty or it's older than 1-hour old it will attempt to download the latest
                
        retrieveRates()
        
        // if the rates need to be updated, it downloads them from through the network manager
        if exchangeRates == nil || exchangeRates.isOverHourOld || userDefaults.baseCurrency != exchangeRates.base {
            network.getRates(baseCurrency: userDefaults?.baseCurrency ?? "USD") { [weak self] result in
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
        
        // retrieves the stored rates, if any, from local storage
        
        storage.retrieveRateData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.exchangeRates = success
                print("retrieved rates from local storage. base: \(success.base)")

            case .failure(let failure):
                print("local storage exchange rates error - \(failure)")
            }
        }
    }
    
    func retrieveUserDefaults() {
        
        // retrieves the user data, if any, from local storage
        storage.retrieveDefaultData { [weak self] result in
            guard let self = self else { return }
            switch result {
            
            case .success(let success):
                self.userDefaults = success
                print("retrieved user defaults from local storage")
              
            case .failure(let failure):
                print("local storgage user defaults error - \(failure)")
            }
        }
    }
    
    func storeUserDefaults() {
        if storage.saveDefaultData(userDefaults) {
            print("user defaults saved")
        }
    }
}

extension CalculatorModel {
    
    func displayFunctionResult(mainText: String, auxText: String) {
        displayRegister.data = mainText
        auxDisplay = auxText
    }
    
    private func performConversion(with number: Double, from fromUnit: ConversionUnit, to toUnit: ConversionUnit) {
        
     
    }
    
    
    
    
}
