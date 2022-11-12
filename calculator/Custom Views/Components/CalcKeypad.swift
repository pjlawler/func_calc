//
//  CalcKeypad.swift
//  calculator
//
//  Created by Patrick Lawler on 11/1/22.
//

import UIKit

protocol FCKeyboardDelegate {
    func keyboardTapped(button: CalcButton)
    func colonKeyLongPressed()
}

class CalcKeypad {

    let keypadStack = FCStackView(stackAxis: .vertical, alignment: .fill, distribution: .fillEqually, padding: 2.0)
    let model = CalculatorModel.shared
    var keypadDelegate: FCKeyboardDelegate!
        
    init() {
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
    
        let buttonSize: CGFloat = (ScreenSize.height / 2 - 38) / 5
        let buttonLabels = [ "AC", "±", "%", "÷","7","8","9","×","4","5","6","-","1","2","3","+",":","0",".","="]
        var buttonCount = 10
       
        // creates the rows for the the keypad
        for _ in 1...5 {
            
            let rowStack = FCStackView(stackAxis: .horizontal, alignment: .fill, distribution: .fillEqually, padding: 2.0)
            
            // creates the buttons and adds them to the row stack view
            for _ in 1...4 {
                let button = CalcButton(number: buttonCount, label: buttonLabels[buttonCount - 10], size: buttonSize)
                button.addTarget(self, action: #selector(keypadButtonTapped(_:)), for: .touchUpInside)
                if buttonCount == 26 {
                    // adds a long press recognizer to the : button
                    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(timeButtonLongPressed(_:)))
                    button.addGestureRecognizer(longPressGesture)
                }
                button.tag = buttonCount
                rowStack.addArrangedSubview(button)
                buttonCount += 1
            }
            
            // adds the row stack to the keypad stack
            keypadStack.addArrangedSubview(rowStack)
        }
        
        keypadStack.translatesAutoresizingMaskIntoConstraints = false
    }
   
    private func updateHighlighted(button: CalcButton) {
        for tag in [13, 17, 21, 25] {
            let updateButton = keypadStack.viewWithTag(tag) as! CalcButton
            if button.tag != tag { updateButton.unhighlight() } else { updateButton.highlight() }
        }
    }
    
   func updateButtonTitles() {
       
      let equalsButton = keypadStack.viewWithTag(29) as! CalcButton
      let clearButton = keypadStack.viewWithTag(10) as! CalcButton
        
        switch model.mode {
            
        case .entering_first, .awaiting_second, .entering_second:
            clearButton.updateTitle(title: "CE")
            equalsButton.updateTitle(title: "=")
            
        case .function_operation:
            clearButton.updateTitle(title: "C")
            equalsButton.updateTitle(title: "ENT")
        
        case .function_complete:
            clearButton.updateTitle(title: "AC")
            equalsButton.updateTitle(title: "USE")
            
        default:
            clearButton.updateTitle(title: "AC")
            equalsButton.updateTitle(title: "=")
        }
    }
    
    
    @objc private func keypadButtonTapped(_ sender: CalcButton) {
        sender.flash()
        updateHighlighted(button: sender)
        keypadDelegate.keyboardTapped(button: sender)
    }
    
    @objc private func timeButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began { keypadDelegate.colonKeyLongPressed() }
    }
}
