//
//  FuncKeypad.swift
//  calculator
//
//  Created by Patrick Lawler on 11/1/22.
//

import UIKit

protocol FCFucntionKeysDelegate {
    func functionKeyTapped(button: FuncButton)
}

class FuncKeypad {

    let functionStack = FCStackView(stackAxis: .vertical, alignment: .fill, distribution: .fillEqually, padding: 2.0)
    var functionKeyDelegate: FCFucntionKeysDelegate!
    
    init() {
        configure()
    }
    
       
    private func configure() {
        
        
        // sets the button height
        let buttonSize: CGFloat = 45
    
        var buttonCount = 100
       
        // creates the rows for the the function buttons
        for _ in 1...2 {
            
            let rowStack = FCStackView(stackAxis: .horizontal, alignment: .fill, distribution: .fillEqually, padding: 2.0)
            
            // creates the buttons and adds them to the row stack view
            for _ in 1...4 {
                let button = FuncButton(size: buttonSize)
                button.addTarget(self, action: #selector(functionButtonTapped(_:)), for: .touchUpInside)
                button.tag = buttonCount
                rowStack.addArrangedSubview(button)
                buttonCount += 1
            }
            
            // adds the row stack to the keypad stack
            functionStack.addArrangedSubview(rowStack)
        }
    }
    
    @objc private func functionButtonTapped(_ sender: FuncButton) {
        sender.flash()
        functionKeyDelegate.functionKeyTapped(button: sender)
    }
}
