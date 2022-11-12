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
       
    
    func updateDisplay() {
        
        aux.text = model.auxDisplay
            
        var textToDisplay: String?
        
        switch model.mode {
        
        case .displaying_error, .function_complete:
            textToDisplay = model.displayRegister.data
        
        default:
            if model.displayRegister.isDisplayingTime { textToDisplay = model.displayRegister.formattedTime }
            else { textToDisplay = model.displayRegister.formattedDecimal }
        }
        
        main.text = textToDisplay
    }
    
}

