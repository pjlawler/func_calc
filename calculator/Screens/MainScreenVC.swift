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
        layoutViews()
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
        
        // configure navbar
        let moreStuff = UIBarButtonItem(title: "More Stuff", style: .plain, target: self, action: #selector(navbarMoreStuffTapped))
        let functions = UIBarButtonItem(title: "Functions", style: .plain, target: self, action: #selector(navbarFunctionsTapped))
        let titleImageView = UIImageView(image: UIImage(named: "FCIcon_trans"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
        navigationItem.leftBarButtonItems = [functions]
        navigationItem.rightBarButtonItems = [moreStuff]
    }


    func layoutViews() {

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
    
    
    @objc func navbarMoreStuffTapped() {
        let moreInfoVC = MoreStuffVC()
        moreInfoVC.moreInfoDelegate = self
        navigationController?.pushViewController(moreInfoVC, animated: true)
    }
    
    
    func pushFunctionSelectorVC(tag: Int? = nil) {
        let functionsVC = FunctionSelectorVC()
        let navigationController = UINavigationController(rootViewController: functionsVC)
        if let _ = tag { functionsVC.fromPresetTag = tag }
        functionsVC.functionSelectorDelegate = self
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

        if (button.titleLabel?.text ?? "" ) == "" {
            
            // if preset button is empty, then pushes the function selector vc
            pushFunctionSelectorVC(tag: button.tag) }
        else {
            
            // presents an alert sheet if not empty
            presentMultipleChoiceAlertOnMainThread(title: "Function Button Preset Action", message: "What would you like to do with this preset button?", actions: ["Change the Preset":.default, "Clear the Preset":.default, "Cancel":.cancel], style: .actionSheet) { choice in
                switch choice {
                case "Change the Preset": self.pushFunctionSelectorVC(tag: button.tag)
                case "Clear the Preset": self.clearPreset(tag: button.tag)
                default:break
                }
            }
        }
    }
    
    
    func clearPreset(tag: Int) {
        model.userDefaults.functionButtons[tag - 100] = ""
        model.storeUserDefaults()
        funcKeypad.updateTitleLabels()
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

extension MainScreenVC: FunctionSelectorDelegate {
    
    func updateButtonTitles() {
        funcKeypad.updateTitleLabels()
    }
    
    
    func executeFunction(function: String) {
        model.functionOperationSelected(for: function)
        display.updateDisplay()
        calcKeypad.updatedKeyButtons()
        funcKeypad.isEnabled(model.functionToPerform == nil)
    }
}

extension MainScreenVC: MoreInfoDelegate {
    
    func clearAllPresets() {
        for (index, _) in model.userDefaults.functionButtons.enumerated() {
            model.userDefaults.functionButtons[index] = ""
        }
        model.storeUserDefaults()
        funcKeypad.updateTitleLabels()
    }
}

