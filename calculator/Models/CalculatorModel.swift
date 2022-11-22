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
    
    func keypadHandler(key: String) {
        
        // handles when any of the calculator keypad keys are tapped
        
        // ensures if displaying and error only the AC will work
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
        
        // clears just the register, specifically when inputing a function input
        
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
            guard functionToPerform != nil else { return }
            functionOperationSelected(for: functionToPerform)
            
        default:
            return
        }
    }
    
    
    private func useTapped() {
        
        // use is available when the calculator is displaying a function result
        
        // temporarily stores the function's result decimal value
        let functionResult = displayRegister.decimalValueAfterFunctionResult
        
        // clears all and sets the display with the decimal value of the function result
        clearAll()
        setDisplayRegister(data: functionResult)
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
        
        // swaps the displayed value from postive to negative and vice versa
        
        // ensures that calculator is not displaying a function result
        guard mode != .function_complete else { return }
        
        // ensures that display is a non-zero number
        if displayRegister.data == nil || displayRegister.data == "0" { return }
        
        let displayAsTime = displayRegister.isDisplayingTime
        
        let result: Double = displayRegister.decimalValue * -1
        setDisplayRegister(data: result, asTime: displayAsTime)
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
                        
            let formulaResult = displayRegister.decimalValueAfterFunctionResult
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
    
    // basic actions available outside the model
    
    func backspace() {
        
        // updates the display register when the display is swipped right and the calculator is inputing a number
   
        switch mode {

        case .entering_first, .entering_second, .function_operation:
            
            if displayRegister.data!.count == 1 { displayRegister.data = "0" }
            else { displayRegister.data!.remove(at: displayRegister.data!.index(before: displayRegister.data!.endIndex)) }
            
        default:
            break
        }
    }
    
    
    func toggleTimeDisplay() {
        
        // swaps display between decimal and time
        setDisplayRegister(data: displayRegister.decimalValue, asTime: !displayRegister.isDisplayingTime)
        mode = .operation_complete
    }
    
    // MARK: Peforms the overall basic math operations
    
    private func performMath() {
        
        // performs the math operation on the math and display registers using the operator that is stored in the operation register
        
        let lhs = mathRegister.decimalValue
        let rhs = displayRegister.decimalValue
        let result: Double!
        
        if rhs == 0 && operationRegister == "÷" {
            setDisplayRegisterWithErrorText("\(Symbols.infinity)", auxText: "Error: dividing any number by 0 will result in an infinite result!")
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
        if calculationList.count == 0 { calculationList = "\(math) \(operationRegister!) \(display)" }
        else { calculationList = calculationList + " \(operationRegister!) \(display)" }
        auxDisplay = calculationList
        
        // sets the display register to display time if either of the registers were formatted as time
        let displayResultAsTime = mathRegister.isDisplayingTime || displayRegister.isDisplayingTime
        setDisplayRegister(data: result, asTime: displayResultAsTime)
        
        mode = .operation_complete
    }
    
    // MARK: Sets the display register for the different modes
    
    private func setDisplayRegister(data decimal: Double, asTime: Bool = false) {
        
        var numberToDisplay = String(decimal)
        
        // used to set the display register in the calculator mode to
        if asTime {
            numberToDisplay = Utilities().doubleToTime(decimal)
        } else {
            if decimal < Double(Int.max) && decimal == trunc(decimal) { numberToDisplay = String(Int(decimal)) }
        }
        
        displayRegister.data = numberToDisplay
    }
    
    
    private func setDispayWithFunctionResult(data decimal: Double, prefix: String = "", suffix: String = "", displayAs: DisplayAs = .decimal) {
        
        // sets the display register in the function mode which allows a prefix and suffix, bypassing the display register's formatting
        
        displayRegister.data = "\(prefix)\(Utilities().formatDecimalNumber(number: decimal, as: displayAs))\(suffix)"
        mode = .function_complete
    }
    
    
    private func setDisplayRegisterWithErrorText(_ errorText:String, auxText: String = "Error!") {
        
        // sets the main and aux display registers with error messages
        displayRegister.data = errorText
        auxDisplay = auxText
        
        // sets the mode to displaying error so it doesn't allow any other operations
        mode = .displaying_error
    }
    
    
    private func resetDisplayRegister() {
        
        // when CE is pressed, this puts what's in the math register back in the display register
        
        displayRegister.data = mathRegister.data
        mathRegister.data = nil
    }
}

extension CalculatorModel {
    
    // MARK: Manages user default and exchange rate retrival and storage
    
    func initialDataLoad(showWarning: @escaping(Bool) -> Void ) {
        
        // loads the user defaults and exchange rates
        retrieveUserDefaults()
        retrieveRates()
        
        updateExchangeRates(completed: {
            if self.exchangeRates.isOverHourOld {
                
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
            network.getRatesFromApi(baseCurrency: userDefaults.baseCurrency!) { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                    
                case .success(let success):
                    
                    // stores the rates in the local variable
                    self.exchangeRates = success
                    print("the latest rates have been downloaded - base: \(self.exchangeRates.base ?? "")")
                    
                    // saves the downloaded rates to local storage
                    if self.storage.saveExchangeRates(success) {
                        print("those rates are now saved to local storage")
                    }
                    
                    self.userDefaults.errorWarningTimeStamp = nil
                    self.storeUserDefaults()
                    
                    completed()
                    
                case .failure(let failure):
                    
                    // if unable to download new data, keeps the old ratedata if not nil
                    print("unable to download exchange rates - error: \(failure)")
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
                let status = self.exchangeRates.isOverHourOld ? "is not current" : "is current"
                print("retrieved rates from local storage, base: \(self.exchangeRates.base ?? "?") and \(status)")
                
            case .failure(let failure):
                
                // if unable to retrieve data, keeps the old data if not nil
                self.exchangeRates.rates = self.exchangeRates.rates != nil ? self.exchangeRates.rates : [:]
                print("unable to retrieve rates from local storage - error: \(failure)")
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
                print("unable to retrive user defaults from local storage - error: - \(failure)")
            }
        }
        
        if userDefaults.baseCurrency == nil {
            print("no base currency in user defaults USD is being defaulted")
            userDefaults.baseCurrency = "USD"
            storeUserDefaults()
        }
    }
    
    
    func storeUserDefaults() {
        
        // ensures showingfavorites is only selected if there are favorites in the array
        if userDefaults.showingFavoritesWithNoneSelected { userDefaults.showingFavorites = false }
        
        if storage.saveDefaultData(userDefaults) {
            print("user defaults have been saved in local storage")
        }
    }
}

extension CalculatorModel {
    
    // MARK: Function operations
    
    func functionOperationSelected(for selectedFunction: String) {
        
        if functionToPerform == nil { functionToPerform = selectedFunction }
        else { guard functionToPerform == selectedFunction else {return }}
        
        // determines if it's a conversion or a formula
        
        if functionToPerform.contains(Symbols.convertTo) {
            
            // if conversion (determined by the -> in the label)
            
            // gets the symbols of the from and to of the conversion
            let items = functionToPerform.split(separator: Symbols.convertTo)
            
            // if there is something in the register, then the conversion will automatically use that number as nuumber
            if displayRegister.data != nil { performConversion() }
            
            else {
                // if nothing in the regsiter, then it will ask for the input
                auxDisplay = "What amount to convert from \(items[0]) to \(items[1])?"
                mode = .function_operation
                functionMode = .entering_conversion
            }
        }
        else {
            
            // if a formula then it will start to collect all of the input variables for to execute the formula
            
            guard let formula = Functions.formulas.first(where: {$0.symbol == selectedFunction }) else { return }
            
            
            if formulaInputs.count == 0 && mode != .function_operation {
                
                // user initial set up for the formula (executes whether there's data in the register or not)
                
                mode = .function_operation
                functionMode = .entering_formula
                
                // display register contains data, it will use that data as the first input and set up to collect the rest
                if displayRegister.data != nil {
                    
                    // takes the value from the register and appends it to the array
                    formulaInputs.append(displayRegister.decimalValue)
                    
                    // sets upt the aux display for the next queue
                    auxDisplay = formula.inputCues![1]
                    
                    // clears the display to zero
                    displayRegister.data = nil
                }
                else {
                    
                    // if no data in the register, then it will set up to collect all the inputs
                    auxDisplay = formula.inputCues?[0] ?? ""
                }
            }
            
            else {
                
                // after enter is pressed
                
                // gets the amount from the display register
                let amountEntered = displayRegister.decimalValue
                
                // appends it to the array
                formulaInputs.append(amountEntered)
                
                // if that was the last input
                if formulaInputs.count == formula.inputCues?.count {
                    
                    // ensures the formula is present
                    guard let formulaString = formula.formula else { return }
                    
                    // gets the formula's result
                    let result = Utilities().formulaResult(formulaString: formulaString, variables: formulaInputs)
                    
                    // a nan result causes an error to be display
                    if result.isNaN {
                        setDisplayRegisterWithErrorText("Error!", auxText: "Error: The formula produced a non-number result.")
                        mode = .displaying_error
                        return
                    }
                    
                    auxDisplay = "\(formula.answerPrefix ?? "Formula result")"
                    
                    
                    let resultSuffix = formula.answerSuffix ?? ""
                    
                    
                    // sets the data for the result to be displayed
                    let displayAs: DisplayAs!
                    
                    switch formula.category {
                    case Categories.financial: displayAs = .currency
                    default: displayAs = .decimal
                    }
                    
                    mode = .function_complete
                    setDispayWithFunctionResult(data: result, suffix: resultSuffix, displayAs: displayAs)
                    
                }
                else {
                    // if more inputs are pending, then it sets the aux display with the input queue and clears the display register
                    auxDisplay = formula.inputCues?[formulaInputs.count]
                    displayRegister.data = nil
                }
            }
        }
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
                result = Utilities().convertTemperature(amount: convertAmount, from: units[0].symbol ?? "", to: units[1].symbol ?? "" )
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
            auxDisplay = "\(fromTitle) converted to \(toTitle) - \(fromPrefix)\(Utilities().formatDecimalNumber(number: fromAmount, as: displayAs))\(auxSuffix) equals:"
            
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
                    let currecySymbol =  CountryData.currencySymbols[String(item)] ?? nil
                    let answerPrefix = currecySymbol != nil ? String(currecySymbol!) : ""
                    let answerSuffix = " \(item)"
                    
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
    }
    
    
    
    
    
    
