//
//  BaseCurrenciesCell.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/7/22.
//

import UIKit

class BaseCurrenciesCell: UITableViewCell {

    let itemLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        let padding: CGFloat = 10
        backgroundColor = .tertiarySystemBackground
        selectionStyle = .none
        
        addSubview(itemLabel)

        itemLabel.translatesAutoresizingMaskIntoConstraints = false
 
        NSLayoutConstraint.activate([
            itemLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            itemLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func set(rowData: String, isCurrentSelection: Bool) {
        itemLabel.text      = rowData
        accessoryType       = isCurrentSelection ? .checkmark : .none
    }

}
