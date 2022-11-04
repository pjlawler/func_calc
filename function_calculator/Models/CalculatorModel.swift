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
    
    // registers
    var displayRegister: String!
    var mathRegister: String!
    var operationRegister: String!
    var secondaryOperationRegister: String!

    var mode: CalcModes = .all_clear
    
    func keypadTapped(key: String) {
    
        // handles when any of the calculator keypad keys are tapped
        
        if mode == .displaying_error && key != "AC" { return }
        
        switch key {
        case "AC": clearAll()
        case "=": performMath()
        case "%": percentTapped()
        case "±": toggleNegative()
        case "+", "-", "×","÷": operatorTapped(oper: key)
        default: numericTapped(numberKey: key)
        }
    }
    
    // basic calculator functions
    
    private func clearAll() {

        // clears all of the calculator's registers

        displayRegister = nil
        operationRegister = nil
        secondaryOperationRegister = nil
        mathRegister = nil
        mode = .all_clear
    }
    
    
    func backspace() {

        // updates the display register when the display is swipped right

        guard displayRegister != nil else { return }
        
        if displayRegister.count == 1 { displayRegister = "0" }
        else { displayRegister.remove(at: displayRegister.index(before: displayRegister.endIndex)) }
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
            guard abs(registerValue) < 999999999 else { return }
                        
            // ensures only one decimal is entered in the display regester
            if displayRegister.contains(".") && numberKey == "." { return }
            
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
    
    
    private func operatorTapped(oper: String) {
        
        // peforms the functions when an operator is tapped on the keypad based on the mode of the calculator
        
        switch mode {
        
        case .all_clear, .entering_first, .operation_complete:
            
            // stores the math operator and gets setup to accept the second number
            
            operationRegister = oper
            mathRegister = displayRegister != nil ? displayRegister : "0"
            mode = .awaiting_second
        
        case .entering_second:
            
            // performs the operation and gets setup to accept the another number
        
            performMath()
            
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
    
    
    private func percentTapped() {
        switch mode {

        case .entering_first:
            let result: Double = displayRegister == nil ? 0.0 : (displayRegister as NSString).doubleValue / 100
            setDisplayRegister(with: result)
        
        case .entering_second:
            let mathRegister: Double = mathRegister == nil ? 0.0 : (mathRegister as NSString).doubleValue
            let displayRegister: Double = displayRegister == nil ? 0.0 : (displayRegister as NSString).doubleValue
            let result = displayRegister/100 * mathRegister
            setDisplayRegister(with: result)

        default:
            return
        }
    }
    
    
    private func toggleNegative() {
        
        // ensures that display is a non-zero number
        if displayRegister == nil || displayRegister == "0" { return }
        
        let result: Double = (displayRegister as NSString).doubleValue * -1
        setDisplayRegister(with: result)
    }
    
    
    private func performMath() {
        
        // performs the math operation on the math and display registers using the operator that is stored in the operation register
        
        let lhs: Double = mathRegister == nil ? 0.0 : (mathRegister as NSString).doubleValue
        let rhs: Double = displayRegister == nil ? 0.0 : (displayRegister as NSString).doubleValue
        let result: Double!
 
        switch operationRegister {
        case "+": result = lhs + rhs
        case "-": result = lhs - rhs
        case "×": result = lhs * rhs
        case "÷":
            if(rhs == 0) {
                setDisplayRegister(with: "Divide by Zero!")
                return }
            result = lhs / rhs
        default:
            return
        }
        setDisplayRegister(with: result)
        mode = .operation_complete
    }
    
    private func setDisplayRegister(with decimal:Double) {
        if decimal == Double(Int(decimal)) {
            displayRegister = String(Int(decimal))
        } else {
            displayRegister = String(decimal)
        }
    }
    
    private func setDisplayRegister(with errorText:String) {
        displayRegister = errorText
        mode = .displaying_error
    }
}
