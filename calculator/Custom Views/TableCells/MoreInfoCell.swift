//
//  TableViewCell.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/7/22.
//

import UIKit

import UIKit

class MoreInfoCell: UITableViewCell {
    
    let itemLabel   = UILabel(frame: .zero)
    let button = MoreStuffButton(frame: .zero)
    
    let model = CalculatorModel.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        button.backgroundColor = .systemIndigo.withAlphaComponent(0.75)
        button.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubviews(itemLabel, button)
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            itemLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            itemLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 55)
        ])
        
        
    }
    
    func set(item: String, buttonTitle: String, tag: Int) {
        button.setTitle(buttonTitle, for: .normal)
        itemLabel.text = item
        button.tag = tag
    }
   
}
