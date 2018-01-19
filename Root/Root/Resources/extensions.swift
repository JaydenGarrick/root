//
//  extensions.swift
//  Root
//
//  Created by Jayden Garrick on 1/11/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func fillOutRequiredFields() {
        
        let missingFieldsAlertController = UIAlertController(title: "🌲", message: "You missed filling out one or more of the fields", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        // FIXME : - Fix color
        missingFieldsAlertController.view.tintColor = UIColor(named: "Tint")
        missingFieldsAlertController.addAction(action)
        
        present(missingFieldsAlertController, animated: true)
        
    }
    
}



