//
//  CalcButton.swift
//  calculator
//
//  Created by Patrick Lawler on 10/31/22.
//

import UIKit

class CalcButton: UIButton {
    
    var buttonHighlighted = false

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(number: Int, label: String, size: CGFloat) {
        
        super.init(frame: .zero)
                
        setTitle(label, for: .normal)
        
        // sets background color
        switch number {
        case 3, 7, 11, 15, 19: backgroundColor = .systemOrange
        case 0...2: backgroundColor = .systemGray3
        default: backgroundColor = .systemIndigo
        }
        
        // styles button
        setTitleColor(.label, for: .normal)
        titleLabel?.font = Fonts.keypadButton
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = size / 5
        clipsToBounds = true

        // laysout button height and width
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: size)
        ])
        
    }
    
    func unhighlight() {
        // sets button back to normal state
        titleLabel?.font = Fonts.keypadButton
        backgroundColor = .systemOrange.withAlphaComponent(1.0)
    }
    
    func highlight() {
        // updates styling when highlighting button
        titleLabel?.font = Fonts.keypadButton_hl
        backgroundColor = .systemOrange.withAlphaComponent(0.5)
    }
        
    func flash() {
        let flash                       = CABasicAnimation(keyPath: "opacity")
        flash.duration                  = 0.1
        flash.fromValue                 = 1
        flash.toValue                   = 0.5
        flash.timingFunction            = CAMediaTimingFunction(name: .easeInEaseOut)
        flash.autoreverses              = true
        flash.repeatCount               = 0
        layer.add(flash, forKey: nil)
    }
    

}
