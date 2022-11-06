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
    
    let main = UILabel(frame: .zero)
    let aux = UILabel(frame: .zero)
    
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
        main.backgroundColor = .clear
        main.textColor = .white
        main.textAlignment = .right
        main.numberOfLines = 1
        main.font = Fonts.mainDisplayText
        main.minimumScaleFactor = 0.5
        main.adjustsFontSizeToFitWidth = true
        main.text = "0"
        aux.backgroundColor = .clear
        aux.textColor = .white
        aux.textAlignment = .left
        aux.numberOfLines = 3
        aux.minimumScaleFactor = 0.8
        aux.font = Fonts.auxDisplayText
        aux.text = ""
        
        addSubview(main)
        addSubview(aux)
        
        main.translatesAutoresizingMaskIntoConstraints = false
        aux.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            main.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4.0),
            main.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4.0),
            main.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4.0),
            aux.topAnchor.constraint(equalTo: topAnchor, constant: 4.0),
            aux.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4.0),
            aux.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4.0)
        ])
        
        // adds the gesture recognizer to the view which allows the swipping right action
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(displaySwipedRight(_:)))
        addGestureRecognizer(swipeGesture)
    }
    
    
    @objc private func displaySwipedRight(_ sender: Any){
        displayDelegate.displaySwippedRight()
    }
    
    
    private func updateAuxDisplay(_ text: String?) {
        aux.text = text
    }
    
    
    func updateMainDisplay() {
        
        updateAuxDisplay(model.auxDisplay)
        
        // reformats the display register data to show the user on the main display (i.e. decimal with thousands seperators)
                
        var textToDisplay = model.displayRegister != nil ? model.displayRegister : "0"
        
        let timeResult = model.displayResultAsTime != nil ? model.displayResultAsTime! : false
        
        
        // determines how to format the displayed data depending on the mode and what's in the register.
        
        if model.displayRegister != nil && model.mode != .displaying_error {
            
            // operations if the register contains a decimal number
            
            let register = model.doubleValueOf(model.displayRegister)
            let useScientific = abs(register) > 9999999999.99
            let showDecimal = model.displayRegister.contains(".") && !useScientific
            var significantDigits = 1
            var trailingZeros = ""
            let displayAsTime = model.displayRegister.contains(":") || timeResult ? true : false
            
            if !useScientific {

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
            
            if displayAsTime {
                textToDisplay = Convert().doubleToTime(register)
            }
            else {
                let formatter =  NumberFormatter()
                formatter.numberStyle = useScientific ? .scientific : .decimal
                formatter.exponentSymbol = "e"
                formatter.groupingSeparator = ","
                formatter.usesGroupingSeparator = true
                formatter.alwaysShowsDecimalSeparator = showDecimal
                formatter.maximumIntegerDigits = useScientific ? 3 : 10
                formatter.maximumFractionDigits = useScientific ? 3 : 9 - significantDigits
                textToDisplay = formatter.string(from: register as NSNumber)! + trailingZeros
            }
        }
        // sets the label text
        main.text = textToDisplay
    }
    
}

