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
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var hometownTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
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
//            userLabel.text
        }
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
