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
        missingFieldsAlertController.view.tintColor = UIColor(named: "Tint")
        missingFieldsAlertController.addAction(action)
        
        present(missingFieldsAlertController, animated: true)
        
    }
    
    func editButtonTappedAlert() {

        let actionSheetController = UIAlertController(title: "Settings", message: "🌲", preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor(named: "Tint")
        let editProfileButtonAction = UIAlertAction(title: "Edit Profile", style: .default) { (_) in
            self.performSegue(withIdentifier: "SegueID", sender: self)
        }
        actionSheetController.addAction(editProfileButtonAction)
        present(actionSheetController, animated: true)
        
    }
    
}



