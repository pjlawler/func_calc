//
//  MainScreenVC.swift
//  calculator
//
//  Created by Patrick Lawler on 10/31/22.
//
import UIKit

class MainScreenVC: UIViewController {
    
    let display = CalculatorDisplay()
    let funcKeypad = FuncKeypad()
    let calcKeypad = CalcKeypad()
    let model = CalculatorModel.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavbar()
        configureComponents()
        model.updateExchangeRates()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        calcKeypad.keypadDelegate = self
        funcKeypad.functionKeyDelegate = self
        display.displayDelegate = self
    }
    
    
    func configureNavbar() {
        let functions = UIBarButtonItem(image: UIImage(systemName: "f.cursive.circle") , style: .plain, target: self, action: #selector(navbarFunctionsTapped))
        let moreInfo = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(navbarMoreInfoTapped))
        let titleImageView = UIImageView(image: UIImage(named: "FCIcon_trans"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
        navigationItem.leftBarButtonItems = [functions]
        navigationItem.rightBarButtonItems = [moreInfo]
    }
       
    
    func configureComponents() {
        // gets the custom button stack from each component
        let functionStack = funcKeypad.functionStack
        let keypadStack = calcKeypad.keypadStack
        
        // lays out the keypad, fuction keys and main display on the view
        view.addSubview(display)
        view.addSubview(functionStack)
        view.addSubview(keypadStack)
        
        NSLayoutConstraint.activate([
            display.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 20),
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
    
    
    @objc func navbarFunctionsTapped() {
        
    }
    
    
    @objc func navbarMoreInfoTapped() {
        
    }
}

extension MainScreenVC: FCKeyboardDelegate, FCFucntionKeysDelegate, FCDisplayDelegate  {
    
    // required protocol functions from the components
    
    func displaySwippedRight() {
        
        // called when the user gestures on the main display
        
        model.backspace()
        display.updateMainDisplay()
    }
    
    
    func functionKeyTapped(button: FuncButton) {
        
        // called when any function key is tapped
    }
    
    
    func keyboardTapped(button: CalcButton) {

        // called when any keypad button is tapped
        
        guard let buttonText = button.titleLabel?.text else { return }
        model.keypadTapped(key: buttonText)
        display.updateMainDisplay()
        calcKeypad.updateButtonTitles()
    }
    
    
    func colonKeyLongPressed() {
        model.toggleTimeDisplay()
        display.updateMainDisplay()
    }
}
