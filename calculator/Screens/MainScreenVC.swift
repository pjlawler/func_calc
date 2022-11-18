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
        loadData()
        configureViewController()
        configureNavbar()
        configureComponents()
        funcKeypad.updateTitleLabels()
    }

    func loadData() {
        // loads the data from user defaults and gets the latest exchange rates
        model.initialDataLoad { showWarning in
            if showWarning {
                // shows warning once in a 24-hour period if the data aren't current
                self.presentAlertOnMainThread(title: "Network Problem", message: self.model.exchangeRates.alertMessage)
            }
        }
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        calcKeypad.keypadDelegate = self
        funcKeypad.functionKeyDelegate = self
        display.displayDelegate = self
    }
    
    
    func configureNavbar() {
        let functions = UIBarButtonItem(image: UIImage(systemName: "f.cursive.circle") , style: .plain, target: self, action: #selector(navbarFunctionsTapped))
        let moreInfo = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(navbarMoreInfoTapped))
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
        view.addSubviews(display, functionStack, keypadStack)

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
        pushFunctionSelectorVC()
    }
    
    
    @objc func navbarMoreInfoTapped() {
        let moreInfoVC = MoreInfoVC()
        navigationController?.pushViewController(moreInfoVC, animated: true)
    }
    
    func pushFunctionSelectorVC() {
        let functionsVC = FunctionSelectorVC()
        let navigationController = UINavigationController(rootViewController: functionsVC)
        present(navigationController, animated: true)
    }
}

extension MainScreenVC: FCKeyboardDelegate, FCFucntionKeysDelegate, FCDisplayDelegate  {
       
    func displaySwippedRight() {
        model.backspace()
        display.updateDisplay()
        calcKeypad.updatedKeyButtons()
    }
    
    
    func functionButtonTapped(button: FuncButton) {
        guard button.titleLabel?.text != nil else { return }
        model.functionOperationSelected(for: button.titleLabel!.text!)
        display.updateDisplay()
        calcKeypad.updatedKeyButtons()
        funcKeypad.isEnabled(model.functionToPerform == nil)
    }
    
    
    func functionButtonLongPressed(button: FuncButton) {
        pushFunctionSelectorVC()
    }
        
    
    func keyboardTapped(button: CalcButton) {
        guard let buttonText = button.titleLabel?.text else { return }
        model.keypadHandler(key: buttonText)
        display.updateDisplay()
        calcKeypad.updatedKeyButtons()
        funcKeypad.isEnabled(model.functionToPerform == nil)
    }
    
    
    func colonKeyLongPressed() {
        model.toggleTimeDisplay()
        display.updateDisplay()
    }
}
