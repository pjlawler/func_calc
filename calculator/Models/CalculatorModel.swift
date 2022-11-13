//
//  CalculatorModel.swift
//  calculator
//
//  Created by Patrick Lawler on 11/2/22.
//

import UIKit

class CalculatorModel {
    
    static let shared = CalculatorModel()
    private init() {}
    
    let network = NetworkManager.shared
    let storage = LocalStorageManager.shared
    var userDefaults = DefaultData()
    var exchangeRates = RateData()
    var auxDisplay: String?
    var displayRegister = CalcRegister()
    var mathRegister = CalcRegister()
    var operationRegister: String!
    var calculationList = ""
    var mode: CalcModes = .all_clear
    var functionMode: FunctionMode!
    var functionToPerform: String!
    var formulaInputs: [Double] = []
    
    
    // MARK: Handles user inputs through keypad buttons
    
    func keypadTapped(key: String) {
    
        // handles when any of the calculator keypad keys are tapped
        
        if mode == .displaying_error && key != "AC" { return }
        
        switch key {
        case "AC": clearAll()
        case "CE": clearEntry()
        case "C": clearRegister()
        case "=": equalsTapped()
        case "ENT": enterTapped()
        case "USE": useTapped()
        case "%": percentTapped()
        case "±": toggleNegative()
        case "+", "-", "×","÷": operatorTapped(oper: key)
        default: numericTapped(numberKey: key)
        }
    }
    
    
    private func clearAll() {

        // clears all of the calculator's registers

        displayRegister.data = nil
        operationRegister = nil
        mathRegister.data = nil
        calculationList = ""
        auxDisplay = nil
        functionToPerform = nil
        formulaInputs.removeAll()
        mode = .all_clear
    }
    
    
    private func clearRegister() {
        
        // clears just the register when inputing a function input
        
        if displayRegister.data == nil { clearAll() }
        else { displayRegister.data = nil }
    }
    
    
    private func clearEntry() {
        
        // clears the entry and backs up one mode when entering calculator functions
        
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
    
    
    private func enterTapped() {
        
        // when the calculator is in the function mode and the ENT button is pressed
        
        switch functionMode {

        case .entering_conversion:
            performConversion()

        case .entering_formula:
            guard functionMode != nil else { return }
            performFunctionOperation(on: functionToPerform)
            return

        default:
            return
        }
    }
    
    private func useTapped() {
        
        guard mode == .function_complete else { return }
        
        let formulaResult = displayRegister.decimalValue
        clearAll()
        setDisplayRegister(data: formulaResult)
        mode = .entering_first
    }
    
    
    private func percentTapped() {
        
        // calculates the percentage depending which mode the calculator is in
        
        switch mode {

        case .entering_first, .function_operation:
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
        
        case .function_complete:
            let formulaResult = displayRegister.decimalValue
            clearAll()
            setDisplayRegister(data: formulaResult)
            mathRegister.data = displayRegister.data
            operationRegister = oper
            mode = .awaiting_second
            
        default:
            
            // returns if the calculator is in any other mode
            return
        }
    }
    
    
    private func numericTapped(numberKey: String) {

        // performs the functions if a number, "." or ":" is tapped on the keypad based on the mode of the calculator
             
        switch mode {
            
        case .all_clear:
            
            // first number being entered into the calculator
            
            displayRegister.data = numberKey
            mode = .entering_first
            
        case .function_operation:
            
            if displayRegister.data == nil {
                displayRegister.data = numberKey
                return
            }
            
            // limits the number the user can type into the calculator
            guard !displayRegister.isMax else { return }
                        
            // ensures only one decimal and/or colon is entered in the display regester
            if displayRegister.containsDecimalOrColon && (numberKey == "." || numberKey == ":") { return }
            
            // if the display is showing 0, then any number will replace the zero
            displayRegister.data = displayRegister.data == "0" ? numberKey : displayRegister.data! + numberKey
            
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
    
    
    // MARK: Peforms the overall basic math operations
    
    
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
    
    // for actions available outside the model
    
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
    
    
    // MARK: Sets the display register for the different modes
    
    
    private func setDisplayRegister(data decimal: Double, asTime: Bool = false) {
        
        var numberToDisplay = String(decimal)
       
        // used to set the display register in the calculator mode to
        if asTime {
            numberToDisplay = Convert().doubleToTime(decimal)
        } else {
            if decimal < Double(Int.max) && decimal == trunc(decimal) { numberToDisplay = String(Int(decimal)) }
        }
        
        displayRegister.data = numberToDisplay
    }
        
    
    private func resetDisplayRegister() {
        
        // when CE is pressed, this puts
        
        displayRegister.data = mathRegister.data
    }
        
    private func setDispayWithFunctionResult(data decimal: Double, prefix: String = "", suffix: String = "", displayAs: DisplayAs = .decimal) {
        
        // sets the display register in the function mode which allows a prefix and suffix, bypassing the display register's formatting
        
        displayRegister.data = "\(prefix)\(formatDecimalNumber(number: decimal, as: displayAs))\(suffix)"
        mode = .function_complete
    }
    
    
    private func setDisplayRegisterWithErrorText(_ errorText:String) {
        displayRegister.data = errorText
        auxDisplay = "Error!"
        mode = .displaying_error
    }

    
    private func formatDecimalNumber(number: Double, as type: DisplayAs ) -> String {

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
            multiplier = 1 / 0.1
            
        case .time:
            return Convert().doubleToTime(number)
        
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
}

extension CalculatorModel {
    
    // MARK: Manages user default and exchange rate retrival and storage
    
    func initialDataLoad(showWarning: @escaping(Bool) -> Void ) {
        
        // loads the user defaults and exchange rates
        retrieveUserDefaults()
        retrieveRates()
        
        updateExchangeRates(completed: {
            if self.exchangeRates.downloadStatus != .current {
                
                // if the data is not current, then will display a warning
                
                // enusres the warning only displays once every 24-hours
                if self.userDefaults.errorWarningTimeStamp != nil && self.userDefaults.hoursSinceWarned <= 24 { return }
                
                // sets the time stamp of the warning
                self.userDefaults.errorWarningTimeStamp = Int(Date().timeIntervalSince1970)
                self.storeUserDefaults()
                showWarning(true)
                return
            }
        })
        
        showWarning(false)
    }
    
    func updateExchangeRates(completed: @escaping() -> Void) {
        
        // if the rates need to be updated, it downloads them from through the network manager
        if exchangeRates.isOverHourOld || userDefaults.baseCurrency != exchangeRates.base {
            network.getRates(baseCurrency: userDefaults.baseCurrency!) { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                
                case .success(let success):
                    
                    // stores the rates in the local variable
                    self.exchangeRates = success
                    print("downloaded the latest rate data")

                    // saves the downloaded rates to local storage
                    if self.storage.saveExchangeRates(success) {
                        print("new rate data saved to local storage")
                    }
                    
                    self.userDefaults.errorWarningTimeStamp = nil
                    self.storeUserDefaults()
                    
                    completed()
                
                case .failure(let failure):
                    
                    // if unable to download new data, keeps the old ratedata if not nil
                    print("network manager error - \(failure)")
                    completed()
                }
            }
        }
        else {
            completed()
        }
    }
    
    
    func retrieveRates() {
        
        // retrieves the stored rates, if any, from local storage
        
        storage.retrieveRateData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.exchangeRates = success
                print("retrieved rates from local storage. base: \(String(describing: success.base))")

            case .failure(let failure):
                
                // if unable to retrieve data, keeps the old data if not nil
                self.exchangeRates.rates = self.exchangeRates.rates != nil ? self.exchangeRates.rates : [:]
                print("local storage error - \(failure)")
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
        
        if userDefaults.baseCurrency == nil {
            print("USD being defaulted")
            userDefaults.baseCurrency = "USD"
            storeUserDefaults()
        }
    }
    
    func storeUserDefaults() {
        if storage.saveDefaultData(userDefaults) {
            print("user defaults saved")
        }
    }
}

extension CalculatorModel {
    
    // MARK: Function operations

    func performFunctionOperation(on label: String) {
        
        functionToPerform = label
        
        if functionToPerform.contains(Symbols.convertTo) {
            
            let items = functionToPerform.split(separator: Symbols.convertTo)
            
            if displayRegister.data != nil { performConversion() }
            else {
                auxDisplay = "What amount to convert from \(items[0]) to \(items[1])?"
                mode = .function_operation
                functionMode = .entering_conversion
            }
        }
        else {
            
            //FormulaUnit(title: "Monthly Payment Calculation", formula: "(?a*(?c/12))/(1-((1+(?c/12))**(?b*-1)))", category: Categories.financial, symbol: "PMT", inputCues: ["Amount to be borrowed?", "Length of Loan (Months)?", "Interest Rate APR (i.e. 0.065)?"], favorite: nil, answerPrefix: "Payment ", answerSuffix: "/mo"),

            guard let formula = Functions.formulas.first(where: {$0.symbol == label }) else { return }
            
            if formulaInputs.count == 0 {
                
                // if this is the first input
                
                mode = .function_operation
                functionMode = .entering_formula
                
                if displayRegister.data != nil {
                    formulaInputs.append(displayRegister.decimalValue)
                    auxDisplay = formula.inputCues![1]
                    displayRegister.data = nil
                }
                else {
                    auxDisplay = formula.inputCues?[0] ?? ""
                }
            }
            else {
                let amountEntered = displayRegister.decimalValue
                formulaInputs.append(amountEntered)
                if formulaInputs.count == formula.inputCues?.count {
                    
                    guard let formulaString = formula.formula else { return }
                    
                    auxDisplay = "\(formula.answerPrefix ?? "Function Result") = "
                    
                    let result = formulaResult(formulaString: formulaString, variables: formulaInputs)
                    let resultSuffix = formula.answerSuffix ?? ""
                    let displayAs: DisplayAs!
                    
                    switch formula.category {
                    case Categories.financial: displayAs = .currency
                    default: displayAs = .decimal
                    }
                                        
                    mode = .function_complete
                    setDispayWithFunctionResult(data: result, suffix: resultSuffix, displayAs: displayAs)
                }
                else {
                    displayRegister.data = nil
                    auxDisplay = formula.inputCues?[formulaInputs.count] }
            }
        }
    }
    
    private func formulaResult(formulaString: String, variables: [Double]) -> Double {
       
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
    
    private func performConversion() {
        
        // gets two strings in an array, from and to
        let items = functionToPerform.split(separator: Symbols.convertTo)

        // ensures it's a conversion b
        guard items.count == 2 else { return }
        
        // gets the value from the register to conver from
        let convertAmount = displayRegister.decimalValue
        
        // get the formatted amount string (includes thousands seprators)
        let fromAmount = displayRegister.decimalValue
        
        // gets an array with the conversion units
        let units = getConversionUnits()
        
        
        // gets the needed items from the objects for doing the conversion and displaying result
        
        // gets the titles of each item
        let fromTitle = units[0].title ?? ""
        let toTitle = units[1].title ?? ""
        
        // gets multipler for conversion
        let from = units[0].multiplier ?? 0.0
        let to = units[1].multiplier ?? 0.0
        
        var displayAs: DisplayAs!
        var result: Double!
        
        switch units[0].category {
        case Categories.temperature:
            result = convertTemperature(amount: convertAmount, from: units[0].symbol ?? "", to: units[1].symbol ?? "" )
            displayAs = .temperature
        
        case Categories.currency:
            result = to/from * convertAmount
            displayAs = .currency
            
        default:
            result = from/to * convertAmount
            displayAs = .decimal
        }
        
        
        // gets the prefixes and suffixes
        let fromPrefix = units[0].answerPrefix ?? ""
        let fromSuffix = units[0].answerSuffix ?? ""
        let toPrefix = units[1].answerPrefix ?? ""
        let toSuffix = units[1].answerSuffix ?? ""
        let auxSuffix = (displayAs == .currency && fromPrefix == "") || !(displayAs == .currency) ? fromSuffix : ""
        let resultSuffix = (displayAs == .currency && toPrefix == "") || !(displayAs == .currency) ? toSuffix : ""
                     
        // sets the aux display with the text data
        auxDisplay = "\(fromTitle) converted to \(toTitle) - \(fromPrefix)\(formatDecimalNumber(number: fromAmount, as: displayAs))\(auxSuffix) equals:"
       
        // sets the display register with the functions result
        setDispayWithFunctionResult(data: result, prefix: toPrefix, suffix: resultSuffix, displayAs: displayAs)
    }
    
    
    private func getConversionUnits() -> [ConversionUnit] {
        
        let items = functionToPerform.split(separator: Symbols.convertTo)

        guard items.count == 2 else { return [] }
        
        let isCurrency = exchangeRates.rates?.contains(where: {$0.key == items[0]}) ?? false
        
        var conversionUnits:[ConversionUnit] = []

        // this will get the conversion units from the functions enum or create new ones with currency information if the conversion is for currency
        
        if isCurrency {
            for item in items {
                
                // populates the data from the latest exchange rates and the country information dictionaries
                
                let title = CountryData.currencyName[String(item)] ?? ""
                let multiplier = exchangeRates.rates?[String(item)] ?? 0.0
                let category = Categories.currency
                let symbol = String(item)
                let answerPrefix = String(CountryData.currencySymbols[String(item)] ?? Character(""))
                let answerSuffix = String(item)

                conversionUnits.append(ConversionUnit(title: title, multiplier: multiplier, category: category, symbol: symbol, favorite: nil, answerPrefix: answerPrefix, answerSuffix: answerSuffix))
            }
        }
        else {
            
            // retrieves the respective objects from the library to be used for the conversion
            
            guard let fromObj = Functions.conversions.first(where: { $0.symbol == String(items[0])}) else { return [] }
            guard let toObj = Functions.conversions.first(where: { $0.symbol == String(items[1])}) else { return [] }
            conversionUnits.append(contentsOf: [fromObj, toObj])
        }
        
        return conversionUnits
    }
    
    
    private func convertTemperature(amount: Double, from: String, to: String ) -> Double {
        
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






