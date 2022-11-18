//
//  FuncKeypad.swift
//  calculator
//
//  Created by Patrick Lawler on 11/1/22.
//

import UIKit

protocol FCFucntionKeysDelegate {
    func functionButtonTapped(button: FuncButton)
    func functionButtonLongPressed(button: FuncButton)
}

class FuncKeypad {

    let model = CalculatorModel.shared
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
                // adds a long press recognizer to the : button
                let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(functionButtonLongPressed(_:)))
                button.addGestureRecognizer(longPressGesture)
                button.tag = buttonCount
                rowStack.addArrangedSubview(button)
                buttonCount += 1
            }
            
            // adds the row stack to the keypad stack
            functionStack.translatesAutoresizingMaskIntoConstraints = false
            functionStack.addArrangedSubview(rowStack)
        }
    }
    
    func isEnabled(_ enabled: Bool) {
        
        for tag in 100...107 {
            let button = functionStack.viewWithTag(tag) as! FuncButton
            button.isEnabled = enabled
            button.titleLabel?.font = enabled ? Fonts.fucntionButtonEnabled : Fonts.fucntionButtonDisabled
        }
    }
        
    func updateTitleLabels() {
        
        for tag in 100...107 {
            
            let button = functionStack.viewWithTag(tag) as! FuncButton
            
            switch tag {
            case 100: button.updateTitle(titleText: model.userDefaults.funcButton_1 ?? "")
            case 101: button.updateTitle(titleText: model.userDefaults.funcButton_2 ?? "")
            case 102: button.updateTitle(titleText: model.userDefaults.funcButton_3 ?? "")
            case 103: button.updateTitle(titleText: model.userDefaults.funcButton_4 ?? "")
            case 104: button.updateTitle(titleText: model.userDefaults.funcButton_5 ?? "")
            case 105: button.updateTitle(titleText: model.userDefaults.funcButton_6 ?? "")
            case 106: button.updateTitle(titleText: model.userDefaults.funcButton_7 ?? "")
            case 107: button.updateTitle(titleText: model.userDefaults.funcButton_8 ?? "")
            default:
                return
            }
            
        }
    }
    
    @objc private func functionButtonTapped(_ sender: FuncButton) {
        sender.flash()
        functionKeyDelegate.functionButtonTapped(button: sender)
    }
    
    @objc private func functionButtonLongPressed(_ sender: UIGestureRecognizer) {
        
        guard let tag = sender.view?.tag else { return }
        
        if sender.state == .began  {
            guard let button = functionStack.viewWithTag(tag) as? FuncButton else { return }
            functionKeyDelegate.functionButtonLongPressed(button: button)
        }
       
    }
}
