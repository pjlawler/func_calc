//
//  FuncButton.swift
//  calculator
//
//  Created by Patrick Lawler on 11/1/22.
//

import UIKit

class FuncButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(size: CGFloat) {
        
        super.init(frame: .zero)
       
        // sets background color
        backgroundColor = .systemBrown.withAlphaComponent(0.75)
        
        // styles button
        setTitleColor(.label, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = size / 6
        clipsToBounds = true

        // laysout button height and width
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: size)
        ])
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
