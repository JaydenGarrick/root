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
                DispatchQueue.main.async {
                    
                    let createAccountStoryboard = UIStoryboard(name: "CreateAccount", bundle: nil)
                    let welcomeViewController = createAccountStoryboard.instantiateViewController(withIdentifier: "createAccountNavController")
                    self.present(welcomeViewController, animated: true, completion: nil)
                    
                }
            } else {
                print(UserController.shared.loggedInUser?.cloudKitRecordID, UserController.shared.loggedInUser?.fullName, UserController.shared.loggedInUser?.appleUserRef)
            }
        }
    }


    /*
    // MARK: - Navigation
ain 
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
