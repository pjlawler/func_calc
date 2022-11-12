//
//  UserInstructionsVC.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/10/22.
//
import UIKit

class UserInstructionsVC: UIViewController {
    
    let instructionsLabel   = UITextView()
    var attrText: NSMutableAttributedString!
  

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    

    @objc func doneButtonTapped() { dismiss(animated: true) }
    
    func getDynamicBoxHeight(text: NSAttributedString, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: .zero)
        let labelFrame = CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude)
        label.numberOfLines = 0
        label.attributedText = text
        let labelHeight = label.textRect(forBounds: labelFrame, limitedToNumberOfLines: 0).height
        return labelHeight
    }
}


// MARK: - UI Configuration
extension UserInstructionsVC: UITextViewDelegate {
    
    func configureView() {
        title = "FunctionCalc Instructions"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
  
        instructionsLabel.attributedText = InformationText.instructions
        instructionsLabel.scrollsToTop = true
        instructionsLabel.isMultipleTouchEnabled = true
        instructionsLabel.dataDetectorTypes = .link
        instructionsLabel.isSelectable = true
        instructionsLabel.isEditable = false
        instructionsLabel.backgroundColor = .systemBackground
        instructionsLabel.textColor = .label
   
        view.addSubview(instructionsLabel)
    
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            instructionsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            instructionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            instructionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            instructionsLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
}
