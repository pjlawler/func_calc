//
//  MoreStuffButton.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/21/22.
//

import UIKit

class MoreStuffButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemIndigo.withAlphaComponent(0.75)
        setTitleColor(.label, for: .normal)
        titleLabel?.font = Fonts.fucntionButtonEnabled
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 75),
            heightAnchor.constraint(equalToConstant: 35)
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
