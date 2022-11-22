//
//  RatesTableCell.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/7/22.
//

import UIKit

class RatesTableCell: UITableViewCell {
    
    var rateData: Currency!
    
    let countryNameLabel    = RatesCellLabel(textColor: .label, textAlignment: .left)
    let countryCodeLabel    = RatesCellLabel(textColor: .label, textAlignment: .center)
    let currentRateLabel    = RatesCellLabel(textColor: .systemGreen, textAlignment: .center)
    let button              = FavoriteButton(frame: .zero)
    let formatter           = NumberFormatter()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()

    }
    
            
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func set(rateData: Currency) {
        self.rateData                   = rateData
        let rate                        = rateData.rateToBase
        
        countryCodeLabel.text           = rateData.code
        countryNameLabel.text           = rateData.name
        button.isSelected               = rateData.favorited
        formatter.numberStyle           = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        let exchangeRate                = formatter.string(from: NSNumber(value: rate!))
        currentRateLabel.text           = exchangeRate
        
        button.translatesAutoresizingMaskIntoConstraints = false
       
    }
    
    func configure() {
        backgroundColor                 = .systemBackground
        
        let padding: CGFloat            = 10
        countryCodeLabel.numberOfLines = 1
        currentRateLabel.numberOfLines = 1
        
        contentView.addSubviews(countryNameLabel, countryCodeLabel, currentRateLabel, button)
        
        NSLayoutConstraint.activate([
            
            countryCodeLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            countryCodeLabel.widthAnchor.constraint(equalToConstant: 70),
            countryCodeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
                       
            countryNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countryNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            countryNameLabel.trailingAnchor.constraint(equalTo: countryCodeLabel.leadingAnchor, constant: -padding),
        
            currentRateLabel.topAnchor.constraint(equalTo: countryCodeLabel.bottomAnchor),
            currentRateLabel.widthAnchor.constraint(equalToConstant: 70),
            currentRateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            currentRateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
           
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
    }
}
