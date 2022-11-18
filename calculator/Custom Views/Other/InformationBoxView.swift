//
//  SelectInstructions.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/15/22.
//

import UIKit

enum InfoBoxState {
    case conversionFromPreset
    case formulaFromPreset
    case conversionFromNavbar
    case formulaFromNavbar
    case storeToKnownPreset
    case formulaSelected
}

class InformationBoxView: UIView {
    
    let boxTitle = UILabel(frame: .zero)
    let informationText = UILabel()
    let swapButton = UIButton(frame: .zero)
    let clearPresetButton = UIButton(frame: .zero)
    let storeButton = UIButton(frame: .zero)
    
    let symSwap = NSAttributedString(attachment: NSTextAttachment(image: ImageSymbols.arrowupdown!))
    let symStore = NSAttributedString(attachment: NSTextAttachment(image: ImageSymbols.store!))
    let symClear = NSAttributedString(attachment: NSTextAttachment(image: ImageSymbols.clear!))
    var functionString = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureComponents()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBoxState(state: InfoBoxState, functionString: String? = nil) {
        
        self.functionString = functionString ?? ""
        
        switch state {
            
        case .formulaFromNavbar:
            boxTitle.text = "Pre-programmed Formulas"
            
            clearPresetButton.isHidden = true
            swapButton.isHidden = true
            storeButton.isHidden = true
            
            informationText.attributedText = formatAsAttributedText(messageText(type: .formulaFromNavbar)[0])
            
        case .conversionFromNavbar:
            
            boxTitle.text = "Unit Conversions"
            
            clearPresetButton.isHidden = true
            swapButton.isHidden = true
            storeButton.isHidden = true
            
            let infoText_1 = messageText(type: .conversionFromNavbar)[0]
            let infoText_2 = messageText(type: .conversionFromNavbar)[1]
            
            let infoText = formatAsAttributedText(infoText_1)
            infoText.append(formatAsAttributedText(infoText_2))
            
            informationText.attributedText = infoText
            
        case .formulaSelected:
            
            boxTitle.text = "Formula Selected"
            
            clearPresetButton.isHidden = true
            swapButton.isHidden = true
            storeButton.isHidden = false
            
            informationText.attributedText = formatAsAttributedText(messageText(type: .formulaSelected)[0])
      
        case .conversionFromPreset:
            
            boxTitle.text = "Update Preset Button"
            clearPresetButton.isHidden = false
            swapButton.isHidden = true
            storeButton.isHidden = true
            let infoText = "Select two conversion units from the same cateogry from the list below that you would like to store in a preset. Tap the [clear] button to clear the current preset and return to the calculator."
            informationText.attributedText = formatAsAttributedText(infoText)
            
        case .formulaFromPreset:
            
            boxTitle.text = "Update Preset Button"
            clearPresetButton.isHidden = false
            swapButton.isHidden = true
            storeButton.isHidden = true
            let infoText = "Select a formula from the list below that you would like to store in a preset. Tap the [clear] button to clear the current preset and return to the calculator."
            informationText.attributedText = formatAsAttributedText(infoText)
            
       
            
            
        default:
            break
            
        }
        
        
    }
    
    private func configure() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 10
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureComponents() {
        
        boxTitle.textAlignment = .center
        boxTitle.font = Fonts.infoBoxTitle
        boxTitle.textColor = .label
        boxTitle.numberOfLines = 1
        boxTitle.translatesAutoresizingMaskIntoConstraints = false
        
        swapButton.setImage(ImageSymbols.arrowupdown, for: .normal)
        swapButton.setTitleColor(.link, for: .normal)
        swapButton.isHidden = true
        swapButton.translatesAutoresizingMaskIntoConstraints = false
        
        storeButton.setImage(ImageSymbols.store, for: .normal)
        storeButton.setTitleColor(.link, for: .normal)
        storeButton.isHidden = false
        storeButton.translatesAutoresizingMaskIntoConstraints = false
        
        clearPresetButton.setImage(ImageSymbols.clear, for: .normal)
        clearPresetButton.setTitleColor(.link, for: .normal)
        clearPresetButton.isHidden = true
        clearPresetButton.translatesAutoresizingMaskIntoConstraints = false
        
        informationText.textColor = .label
        informationText.font = Fonts.infoBoxText
        informationText.lineBreakMode = .byWordWrapping
        informationText.numberOfLines = 6
        informationText.textAlignment = .natural
        informationText.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layoutViews() {
        
        addSubviews(boxTitle, informationText, storeButton, clearPresetButton, swapButton)
        
        NSLayoutConstraint.activate([
            storeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            storeButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            clearPresetButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            clearPresetButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            swapButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            swapButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            boxTitle.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            boxTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            boxTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            informationText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            informationText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            informationText.topAnchor.constraint(equalTo: boxTitle.bottomAnchor, constant: 10),
        ])
    }
    
    func formatAsAttributedText(_ string: String) -> NSMutableAttributedString {
        
        let attrText = NSMutableAttributedString(string: string)
        
        let clearRange = (string as NSString).range(of: "[clear]")
        
        
        let swapRange = (string as NSString).range(of: "[swap]")
        let storeRange = (string as NSString).range(of: "[store]")
        
        if clearRange.length > 0 { attrText.replaceCharacters(in: clearRange, with: symClear) }
        if swapRange.length > 0 { attrText.replaceCharacters(in: swapRange, with: symSwap) }
        if storeRange.length > 0 { attrText.replaceCharacters(in: storeRange, with: symStore) }
        
        return attrText
        
    }
    
    func messageText(type: InfoBoxState) -> [String] {
        
        switch type {
        case .formulaFromNavbar:
            return ["""
Please select a formula from a category below that you wish to use in the calculator.

You may also save the formula to an empty preset button by tapping the [store] button.
"""]
            
        case .formulaSelected:
            return ["""
You've selected the formula \(functionString) to be used in the calculator. Tap select in the navbar to execute.


You may also save the formula to an empty preset button by tapping the [store] button.
"""]
        case .conversionFromNavbar:
            return ["""
Please select two units from the a category below to use in the calculator.  Use the [swap] button to toggle to and from.


""","""
You may also save the conversion to an empty preset button by tapping the [store] button.
"""]
        default:
            return [""]
        }
        
    }
}
