//
//  ArtistCreateUsernameVC.swift
//  Root
//
//  Created by Frank Martin Jr on 1/10/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class ArtistCreateUsernameVC: UIViewController {
    
    var isArtist: Bool?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var hometownTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToArtistCreateInterestsSegue" {
            guard let destinationVC = segue.destination as? ArtistCreateInterestsVC
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
