//
//  UIViewController + Ext.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/9/22.
//

import UIKit


extension UIViewController {
  
    
    func presentAlertOnMainThread(title: String, message: String) {
        
        // when called, it will print an alert on the main thread. So it can be called from an async method
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func presentMultipleChoiceAlertOnMainThread(title: String, message: String, actions:[String:UIAlertAction.Style], style: UIAlertController.Style, completed: @escaping(String) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for (action) in actions {
            alert.addAction(UIAlertAction(title: action.key, style: action.value, handler: { _ in
                completed(action.key)
            }))
        }        
        present(alert, animated: true)
    }
}
