//
//  FavoriteButton.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/8/22.
//

import UIKit

class FavoriteButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        setImage(ImageSymbols.favoriteStar, for: .normal)
        setImage(ImageSymbols.favoriteStarFill, for: .selected)
    }
    
    func toggle() {
        isSelected = !isSelected
    }

}
