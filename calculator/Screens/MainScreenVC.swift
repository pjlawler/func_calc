//
//  MainScreenVC.swift
//  calculator
//
//  Created by Patrick Lawler on 10/31/22.
//

import UIKit

class MainScreenVC: UIViewController {
    
    // calculator components
    let display = CalculatorDisplay()
    let funcKeypad = FuncKeypad()
    let calcKeypad = CalcKeypad()
       
    let model = CalculatorModel.shared
    let network = NetworkManager.shared
    
    var tempRates: RateData!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutCalculator()
    }
    
    
    func configureViewController() {
        
        view.backgroundColor = .systemBackground
        
        // delegates
        calcKeypad.keypadDelegate = self
        funcKeypad.functionKeyDelegate = self
        display.displayDelegate = self
    }
       
    
    func layoutCalculator() {
        
        // gets the custom button stack from each component
        let functionStack = funcKeypad.functionStack
        let keypadStack = calcKeypad.keypadStack
        
        // lays out the keypad, fuction keys and main display on the view
        view.addSubview(display)
        view.addSubview(functionStack)
        view.addSubview(keypadStack)
        
        NSLayoutConstraint.activate([
            display.topAnchor.constraint(equalTo: view.topAnchor , constant: 50),
            display.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            display.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            display.bottomAnchor.constraint(equalTo: functionStack.topAnchor, constant: -10),
            functionStack.bottomAnchor.constraint(equalTo: keypadStack.topAnchor, constant: -10),
            functionStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            functionStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            keypadStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            keypadStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            keypadStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

extension MainScreenVC: FCKeyboardDelegate, FCFucntionKeysDelegate, FCDisplayDelegate  {
    
    // required protocol functions from the components
    
    func displaySwippedRight() {
        
        // called when the user gestures on the main display
        
        model.backspace()
        display.updateDisplay()
    }
    
    func functionKeyTapped(button: FuncButton) {
        
        // called when any function key is tapped
    }
    
    func keyboardTapped(button: CalcButton) {

        // called when any keypad button is tapped

        // working code to test network manager
        if button.tag == 16 {
            network.getRates(for: "USD") { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                    
                case .success(let rates):
                    self.tempRates = rates
                    print(self.tempRates as Any)
                    
                case .failure(let error):
                    print(error)
                }
            }
            return
        }
        
        guard let buttonText = button.titleLabel?.text else { return }
        model.keypadTapped(key: buttonText)
        display.updateDisplay()
        calcKeypad.updateHighlighted(button: button)
    }
        
   
}
