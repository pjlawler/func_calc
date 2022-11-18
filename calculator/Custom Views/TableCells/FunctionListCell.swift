//
//  FunctionListCell.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/16/22.
//

import UIKit

class FunctionListCell: UITableViewCell {
    
    let symbolLabel = UILabel(frame: .zero)
    let titleLabel = UILabel(frame: .zero)
    let button = FavoriteButton(frame: .zero)
    let model = CalculatorModel.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Hello there from"
        titleLabel.font = Fonts.functionListCellTitle
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        
        symbolLabel.text = "[MORT]"
        symbolLabel.font = Fonts.functionListCellSymbol
        symbolLabel.textColor = .label
        symbolLabel.textAlignment = .center
        
        button.isHidden = true
        
        addSubviews(titleLabel, button, symbolLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -120),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            symbolLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            symbolLabel.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -10),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
        
        
    }
    
    func setCellData(data: FunctionData) {
        
        if data.category == Categories.currency {
            button.isHidden = false
            let isFavorited = model.userDefaults.favorites?.contains(data.symbol) ?? false
            button.isSelected = isFavorited
        } else {
            button.isHidden = true
        }
        
        titleLabel.text = data.title
        symbolLabel.text = "[\(data.symbol)]"
        
    }
}
