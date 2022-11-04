//
//  CalculatorDisplay.swift
//  calculator
//
//  Created by Patrick Lawler on 11/1/22.
//

import UIKit

protocol FCDisplayDelegate {
    func displaySwippedRight()
}

class CalculatorDisplay: UIView {
    
    // creates a black view container with a label inside to display the calculator's data
    
    // main readout label
    let main = UILabel(frame: .zero)
    
    // used to access the data from the display register
    let model = CalculatorModel.shared
    
    var displayDelegate: FCDisplayDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        
        // styles the black screen
        backgroundColor = .black
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        clipsToBounds = false
        
        // styles the main label text
        main.backgroundColor = .clear
        main.textColor = .white
        main.textAlignment = .right
        main.numberOfLines = 1
        main.font = Fonts.mainDisplayText
        main.minimumScaleFactor = 0.5
        main.adjustsFontSizeToFitWidth = true
        main.text = "0."
        
        // adds the main text label to the dissplay
        addSubview(main)
        
        // laysout the lable inside the view container
        main.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            main.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 2.0),
            main.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2.0),
            main.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2.0),
        ])
        
        // adds the gesture recognizer to the view which allows the swipping right action
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(displaySwipedRight(_:)))
        addGestureRecognizer(swipeGesture)
    }
    
    @objc func displaySwipedRight(_ sender: Any){
        displayDelegate.displaySwippedRight()
    }
    
    func updateDisplay() {
        
        // reformats the display register data to show the user on the main display (i.e. decimal with thousands seperators)
                
        var textToDisplay:String?
        
        // determines how to format the displayed data depending on the mode and what's in the register.
        
        if model.mode == .displaying_error {
            textToDisplay = model.displayRegister
        }
                
        else {
            // operations if the register contains a decimal number
            
            // converts the display register to a double, if nil will use 0
            let register: Double = model.displayRegister == nil ? 0.0 : (model.displayRegister as NSString).doubleValue
            let useScientific = abs(register) > 999999999.9
            var significantDigits = 1
            var trailingZeros = ""
            
            if model.displayRegister != nil && !useScientific {
                
                // determines max fraction digits and number of trailing zeros (i.e. 1.00000) in the display register
                
                // calculates how many digits to the left of the decimal, if any. If none it uses 1 (for a zero placeholder)
                significantDigits = model.displayRegister.count > 1 && model.displayRegister.first != "." ? model.displayRegister.split(separator: ".")[0].count : 1
                
                // checks to see how many trailing 0's are after the end of the decimal, if any
                if model.displayRegister.contains(".") && model.displayRegister.last != "." {
                    
                    var count = 0
                    
                    // if nothing on the left side of the split uses zero for the fraction index
                    let fractionPart = model.displayRegister.first == "." ? 0 : 1
                    
                    // looks at each char after the . to see how many trailing zeros there are
                    for char in model.displayRegister.split(separator: ".")[fractionPart] {
                        if char == "0" { count += 1} else { count = 0 }
                    }
                    
                    // creates a string of trailing zeros to add to the display
                    trailingZeros = String(repeating: "0", count: count)
                }
            }
            
            // formats the register as string
            let formatter =  NumberFormatter()
            formatter.numberStyle = useScientific ? .scientific : .decimal
            formatter.exponentSymbol = "e"
            formatter.groupingSeparator = ","
            formatter.usesGroupingSeparator = true
            formatter.alwaysShowsDecimalSeparator = useScientific ? false : true
            formatter.maximumIntegerDigits = useScientific ? 3 : 9
            formatter.maximumFractionDigits = useScientific ? 3 : 10 - significantDigits
            textToDisplay = formatter.string(from: register as NSNumber)! + trailingZeros
        }
        
        // sets the label text
        main.text = textToDisplay
    }
    
}

