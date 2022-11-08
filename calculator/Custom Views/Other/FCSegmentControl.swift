//
//  FCSegmentControl.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/7/22.
//

import UIKit

class FCSegmentControl: UISegmentedControl {

    var firstTitle: String!
    var secondTitle: String!
    var startOn: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(firstTitle: String, secondTitle: String, startOn: Int) {
        self.init(frame: .zero)
        self.firstTitle     = firstTitle
        self.secondTitle    = secondTitle
        self.startOn        = startOn
        configure()
    }
    
    
    func configure() {
        insertSegment(withTitle: firstTitle, at: 0, animated: false)
        insertSegment(withTitle: secondTitle, at: 1, animated: false)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.label], for: .selected)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel], for: .normal)
        translatesAutoresizingMaskIntoConstraints       = false
        selectedSegmentTintColor                        = UIColor.systemIndigo
        backgroundColor                                 = UIColor.systemFill
        selectedSegmentIndex                            = startOn
    }

}
