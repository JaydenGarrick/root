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
        self.dismissKeyboard()
        
        guard let userImageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "photo-camera")) else { print("not success") ; return }
        
        EventController.shared.createEventWith(name: "Test", eventImage: userImageData, dataAndTime: Date(), description: "Test123", venue: "Kilby Court", artist: [UserController.shared.loggedInUser!]) { (success) in
            if success {
                print("Success!")
            }
        }

        UserController.shared.fetchCurrentUser { (success) in
            if !success {
                DispatchQueue.main.async {
                    
                    let createAccountStoryboard = UIStoryboard(name: "CreateAccount", bundle: nil)
                    let welcomeViewController = createAccountStoryboard.instantiateViewController(withIdentifier: "createAccountNavController")
                    self.present(welcomeViewController, animated: true, completion: nil)
                    
                }
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
