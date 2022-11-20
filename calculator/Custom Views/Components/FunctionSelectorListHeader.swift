//
//  FunctionSelectorListHeader.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/16/22.
//

import UIKit

class FunctionSelectorListHeader: UIView {
    
    let arrowButton  = UIButton(frame: .zero)
    let arrowImageView              = UIImageView(image: ImageSymbols.arrowRight, highlightedImage: ImageSymbols.arrowDown)
    let itemLabel                   = UILabel(frame: .zero)
    let favoritesButton             = FavoriteButton(frame: .zero)
    let padding: CGFloat            = 10
    let model = CalculatorModel.shared
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configure() {
        backgroundColor             = .secondarySystemBackground
        arrowImageView.tintColor    = .link
        itemLabel.textColor         = .label
        itemLabel.font              = Fonts.sectionTitleText
        favoritesButton.isHidden    = true
        
        addSubviews(itemLabel, arrowImageView, arrowButton, favoritesButton)
     
        itemLabel.translatesAutoresizingMaskIntoConstraints         = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints    = false
        arrowButton.translatesAutoresizingMaskIntoConstraints       = false
        favoritesButton.translatesAutoresizingMaskIntoConstraints   = false
        
        NSLayoutConstraint.activate([
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            itemLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            itemLabel.leadingAnchor.constraint(equalTo: arrowImageView.trailingAnchor, constant: padding),
            arrowButton.topAnchor.constraint(equalTo: topAnchor),
            arrowButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            arrowButton.trailingAnchor.constraint(equalTo: favoritesButton.leadingAnchor, constant: -padding),
            arrowButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            favoritesButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            favoritesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
    }
    
    func set(data: FunctionData, expanded: Bool, section: Int) {
        
        // hides/unhides favorites button, and selects if the VC is showing only favorites
        if expanded && data.category == Categories.currency {
            favoritesButton.isHidden = false
            favoritesButton.isSelected = model.userDefaults.showingFavorites ?? false
        }
        else {
            favoritesButton.isHidden = true
        }
        
        arrowButton.tag = 200 + section
        arrowImageView.isHighlighted = expanded
        itemLabel.text = data.category
        
        
    }


}
