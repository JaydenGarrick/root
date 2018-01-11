//
//  ListFeedViewController.swift
//  Root
//
//  Created by Frank Martin Jr on 1/11/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class ListFeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UserController.shared.fetchCurrentUser { (success) in
            if !success {
                let createAccountStoryboard = UIStoryboard(name: "CreateAccount", bundle: nil)
                let welcomeViewController = createAccountStoryboard.instantiateViewController(withIdentifier: "createAccountNavController")
                self.present(welcomeViewController, animated: true, completion: nil)
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
