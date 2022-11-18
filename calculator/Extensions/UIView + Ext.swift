//
//  UIView + Ext.swift
//  function_calculator
//
//  Created by Patrick Lawler on 11/15/22.
//
import UIKit

extension UIView {
    
    
    func addSubviews(_ views: UIView...) {
        
        //allows to addSubviews with one line of code versus multiple add addSubview calls
        
        for view in views { self.addSubview(view)}
    }
}
