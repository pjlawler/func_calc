//
//  RatesCellLabel.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/7/22.
//

import UIKit

class RatesCellLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textColor: UIColor, textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.textColor      = textColor
        self.font           = Fonts.rateCellLabel
        self.textAlignment  = textAlignment
        configure()
    }
   

    func configure() {
        numberOfLines               = 0
        minimumScaleFactor          = 0.9
        adjustsFontSizeToFitWidth   = true
        lineBreakMode               = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
