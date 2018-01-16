//
//  CreateUsernameVC.swift
//  Root
//
//  Created by Frank Martin Jr on 1/10/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class CreateUsernameVC: UIViewController {
    
    var isArtist: Bool?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var hometownTextField: UITextField!
    
    
    override func viewDidLoad() {
        
        self.hideKeyboardWhenTappedAround()
        
        super.viewDidLoad()
        
        setUserLabel()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    func setUserLabel() {
        guard let isArtist = self.isArtist
            else { return }
        if isArtist == true {
            userLabel?.text = "Artist"
        }
        else if isArtist == false {
            userLabel?.text = "Art Seeker"
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToCreateInterestsSegue" {
            guard let destinationVC = segue.destination as? CreateInterestsVC
                else { return }
            
            let fullName = fullNameTextField.text
            let username = usernameTextField.text
            let hometown = hometownTextField.text
            
            destinationVC.isArtist = self.isArtist
            destinationVC.fullName = fullName
            destinationVC.username = username
            destinationVC.hometown = hometown
        }
        
    }
    
}