//
//  FCStackView.swift
//  calculator
//
//  Created by Patrick Lawler on 11/1/22.
//

import UIKit

class FCStackView: UIStackView {

        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        convenience init(stackAxis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, padding: CGFloat) {
            self.init(frame: .zero)
            self.axis           = stackAxis
            self.alignment      = alignment
            self.distribution   = distribution
            self.spacing        = padding
            configure()
        }
                   
        func configure() {
            translatesAutoresizingMaskIntoConstraints = false
        }
}
