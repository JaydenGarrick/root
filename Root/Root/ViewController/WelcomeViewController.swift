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
        
        super.viewDidLoad()

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToArtistCreateUsernameSegue" {
            guard let destinationVC = segue.destination as? ArtistCreateUsernameVC else { return }
            let isArtist: Bool = true
            destinationVC.isArtist = isArtist
        }
    
    }

}
