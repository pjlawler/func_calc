//
//  CalcKeypad.swift
//  calculator
//
//  Created by Patrick Lawler on 11/1/22.
//

import UIKit

protocol FCKeyboardDelegate {
    func keyboardTapped(button: CalcButton)
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
    
    
    func configure() {
    
        let buttonSize: CGFloat = (ScreenSize.height / 2 - 38) / 5
        let buttonLabels = [ "AC", "±", "%", "÷","7","8","9","×","4","5","6","-","1","2","3","+","","0",".","="]
        var buttonCount = 0
       
        // creates the rows for the the keypad
        for _ in 1...5 {
            
            let rowStack = FCStackView(stackAxis: .horizontal, alignment: .fill, distribution: .fillEqually, padding: 2.0)
            
            // creates the buttons and adds them to the row stack view
            for _ in 1...4 {
                let button = CalcButton(number: buttonCount, label: buttonLabels[buttonCount], size: buttonSize)
                button.addTarget(self, action: #selector(keypadButtonTapped(_:)), for: .touchUpInside)
                button.tag = buttonCount
                rowStack.addArrangedSubview(button)
                buttonCount += 1
            }
            
            // adds the row stack to the keypad stack
            keypadStack.addArrangedSubview(rowStack)
        }
        
        keypadStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func updateHighlighted(button: CalcButton) {
        for tag in [3, 7, 11, 15] {
            let updateButton = keypadStack.viewWithTag(tag) as! CalcButton
            if button.tag != tag { updateButton.unhighlight() } else { updateButton.highlight() }
        }
    }
    
    @objc func keypadButtonTapped(_ sender: CalcButton) {
        sender.flash()
        keypadDelegate.keyboardTapped(button: sender)
    }
}
