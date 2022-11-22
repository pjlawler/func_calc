//
//  StorePresetButton.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/20/22.
//


import UIKit

class StorePresetButton: UIButton {
    
    var buttonHighlighted = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        // styles button
        setTitle("Save to Preset", for: .normal)
        setTitleColor(.label, for: .normal)
        backgroundColor = .systemIndigo.withAlphaComponent(0.75)
        layer.cornerRadius = 10
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
        
        translatesAutoresizingMaskIntoConstraints = false
        
        // laysout button height and width
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 200),
            heightAnchor.constraint(equalToConstant: 40),
        ])
        
    }
    
    
    
    func presetSaved(_ saved:Bool) {

        // sets the button state depending if the preset is saved or not
        
        isHidden = false

        switch saved {
        case true:
            setTitle("Preset Saved", for: .normal)
            backgroundColor = .systemIndigo.withAlphaComponent(0.5)
            isEnabled = false
        case false:
            setTitle("Save to Preset", for: .normal)
            backgroundColor = .systemIndigo.withAlphaComponent(0.75)
            isEnabled = true
        }
        
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
