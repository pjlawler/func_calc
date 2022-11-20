//
//  TableViewCell.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/7/22.
//

import UIKit

import UIKit

class MoreInfoCell: UITableViewCell {
    
    let itemLabel   = UILabel()
    let detailLabel = UILabel()
    let model = CalculatorModel.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configure() {
        
        let padding: CGFloat = 10
        backgroundColor = .systemBackground
        
        itemLabel.font = Fonts.settingsItem
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        
        detailLabel.font = Fonts.settingsDetail
        detailLabel.textColor = .link
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(itemLabel, detailLabel)
        
        NSLayoutConstraint.activate([
            itemLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            itemLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            detailLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(padding + 25))
        ])
    }
    
     func set(data: [String], row: Int) {
        
        var detailText: String?
        var symbol: AccessoryType?
        
        switch row {
        case 0:
            symbol                  = AccessoryType.detailButton
        case 1:
            detailText = "⌫"
        case 2:
            detailText              = model.userDefaults.baseCurrency
            symbol                  = AccessoryType.disclosureIndicator
        case 3:
            symbol                  = AccessoryType.detailButton
           
        case 4:
            symbol                  = AccessoryType.disclosureIndicator
        default:
            break
        }
              
        itemLabel.text = data[row]
        detailLabel.text = detailText
        accessoryType = symbol != nil ? symbol! : .none
    }
   
}
