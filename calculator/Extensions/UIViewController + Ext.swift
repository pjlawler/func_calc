//
//  UIViewController + Ext.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/9/22.
//

import UIKit


extension UIViewController {
    
    func presentAlertOnMainThread(title: String, message: String) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}
