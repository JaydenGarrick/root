//
//  WelcomeViewController.swift
//  Root
//
//  Created by Frank Martin Jr on 1/10/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    
    // MARK: - IBActions
    @IBAction func artistButtonTapped(_ sender: UIButton) {
        
    }
    override func viewDidLoad() {
        
        self.hideKeyboardWhenTappedAround()
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToArtSeekerCreateUsernameSegue" {
            guard let destinationVC = segue.destination as? CreateUsernameVC else { return }
            let isArtist: Bool = false
            destinationVC.isArtist = isArtist
        }
        
        if segue.identifier == "ToArtistCreateUsernameSegue" {
            guard let destinationVC = segue.destination as? CreateUsernameVC else { return }
            let isArtist: Bool = true
            destinationVC.isArtist = isArtist
        }
        
    }
    
}
