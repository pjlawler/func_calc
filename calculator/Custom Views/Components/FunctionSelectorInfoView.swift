//
//  FunctionSelectorInfoView.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/15/22.
//

import UIKit

protocol InfoBoxViewDelegate {
    func swapButtonTapped()
    func storeButtonTapped(completed: @escaping() -> Void)
}

class FunctionSelectorInfoView: UIView {
    
    let titleLabel = UILabel(frame: .zero)
    let messageLabel = UILabel()
    let swapButton = UIButton(frame: .zero)
    let storeButton = UIButton(frame: .zero)
    let model = CalculatorModel.shared
    let symSwap = NSAttributedString(attachment: NSTextAttachment(image: ImageSymbols.swap!))
    var displayAs: TableDisplay!
    var functionString: String?
    var presetTag: Int?
    
    var infoBoxDelegate: InfoBoxViewDelegate?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureComponents()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: User Inputs
    
    @objc func swapButtonTapped() { infoBoxDelegate?.swapButtonTapped() }
    @objc func storeButtonTapped() {
        infoBoxDelegate?.storeButtonTapped(completed: { [self] in
            storeButton.setTitle(isFunctionStored ? "Preset Saved" : "Save to Preset Button", for: .normal)
        })
    }
   
    
    // MARK: Derrieved Proporties
    
    private var functionComplete: Bool {
        if functionString == nil { return false }
        if displayAs == .formulas { return true }
        if displayAs == .conversions && functionString!.contains(Symbols.convertTo) { return true }
        
        return false
    }
    
    private var isFunctionStored: Bool {
        if functionComplete {
            return model.userDefaults.functionButtons.contains(functionString!)
        }
        
        return false
    }
    
    private var functionTitle: String? {
        guard functionString != nil else { return nil }
        guard let item = functionString?.split(separator: Symbols.convertTo)[0] else { return nil }
        return Utilities().functionTitle(symbol: String(item))
    }
    
    private var toTitle: String? {
        guard functionString != nil else { return nil }
        guard let items = functionString?.split(separator: Symbols.convertTo) else { return nil }
        guard items.count == 2 else { return nil }
        return Utilities().functionTitle(symbol: String(items[1]))
    }
    
    func setStoreButtonTitle(title: String) {
        storeButton.setTitle(title, for: .normal)
    }

    
    func setInfoBox(displayAs: TableDisplay, presetTag: Int?, functionString: String?) {
        
        self.displayAs = displayAs
        self.functionString = functionString
        self.presetTag = presetTag
        
        // gets a prepared message string depending on conditions
        var message = displayMessage()
        
        // sets the title and button states for different conditions
        var title: String!
        
        if functionComplete {
            title = "\(functionString!)"
            if presetTag == nil && !isFunctionStored {
                message = "\(message) You may also store into an empty preset before you execute."
            }
            storeButton.isHidden = false
            storeButton.isEnabled = !isFunctionStored
            swapButton.isHidden = displayAs == .formulas
        }
        else {
            if functionString != nil {title = "Convert \(functionString ?? "") to ???" }
            else if displayAs == .conversions { title = "Unit Conversions" }
            else { title = "Pre-programmed Formulas"}
            storeButton.isHidden = true
            storeButton.isEnabled = false
            swapButton.isHidden = true
        }
        
        storeButton.setTitle(isFunctionStored ? "Preset Saved" : "Save to Preset Button", for: .normal)
        titleLabel.text = title
        messageLabel.text = message
    }
    
    
    private func configure() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func configureComponents() {
        
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.infoBoxTitle
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        swapButton.setTitle("\u{1F501}", for: .normal)
        swapButton.addTarget(self, action: #selector(swapButtonTapped), for: .touchUpInside)
        swapButton.isEnabled = true
        swapButton.translatesAutoresizingMaskIntoConstraints = false
        storeButton.backgroundColor = .systemIndigo.withAlphaComponent(0.75)
        storeButton.setTitleColor(.label, for: .normal)
        storeButton.layer.cornerRadius = 10
        storeButton.addTarget(self, action: #selector(storeButtonTapped), for: .touchUpInside)
        storeButton.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .label
        messageLabel.font = Fonts.infoBoxText
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.numberOfLines = 4
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layoutViews() {
        
        addSubviews(titleLabel, messageLabel, storeButton, swapButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            swapButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            swapButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            storeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            storeButton.widthAnchor.constraint(equalToConstant: 200),
            storeButton.heightAnchor.constraint(equalToConstant: 40),
            storeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}

extension FunctionSelectorInfoView {
    
    func displayMessage() -> String {
        
        // MARK: Messages to be displayed in message box
        
        var message = ""
        
        switch displayAs {
            
        case .conversions:
            if functionString == nil && presetTag == nil {
                // initial conversions from navbar
                message = "Select two a units from a category below.  Once selected, tapping 'Execute' in the navbar will immediately run the conversion in the calculator. "
            }
            else if functionString == nil && presetTag != nil {
                // initial conversions from preset
                message = "Select two a units from a category below.  Once selected, you may save the conversion to the present button."
            }
            else if functionString != nil && !functionComplete {
                // one conversion unit is selected
                
                message = "Select another unit from the same category to convert \(functionTitle ?? "") to."
            }
            else if functionComplete && presetTag == nil {
                // conversion selection completed
                message = "Convert \(functionTitle ?? "") to \(toTitle ?? ""). Tap 'Execute' to run in the calculator.  You may toggle from/to by tapping the swap button"
            }
            else if functionComplete && presetTag != nil {
                // conversion selection completed
                message = "Convert \(functionTitle ?? "") to \(toTitle ?? ""). You may toggle from/to by tapping the swap button."
            }
            
        case .formulas:
            if functionString == nil && presetTag == nil {
                //initial formulas from navbar
                message = "Select a formula a category below.  Once selected, tapping 'Execute' in the navbar will immediately run it in the calculator."
            }
            if functionString == nil && presetTag != nil {
                // initial formulas from preset
                message = "Select a formula from a category below.  Once selected, you may save it the present button."
            }
            if functionComplete && presetTag == nil {
                // formula selected from navbar
                message = "\(functionTitle ?? "") has been selected.  Tap 'Execute' to run it in the calculator."
            }
            if functionComplete && presetTag != nil {
                // formula selected from preset
                message = "\(functionTitle ?? "") has been selected."
            }
            
        default:
            break
        }
    
        return message
    }
    
}
