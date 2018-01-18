//
//  ProfileTableViewController.swift
//  Root
//
//  Created by Edmund Bollenbacher on 1/11/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import CloudKit

class ProfileTableViewController: UITableViewController {
    
    // MARK: - Properties
    var user: User?

    // MARK: - IBOutlets
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBOutlet weak var userProfilePictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        guard let user = UserController.shared.loggedInUser,
            let data = user.profilePicture else { return }
        
        self.user = user
        
        UserController.shared.fetchEventsFor(user: user) { (success) in
            print("Succesfully fetched the events for the user")
            self.tableView.reloadData()
        }
        
        let image = UIImage(data: data)
        let username = user.username
        let websiteURLAsString = user.websiteURL
        
        userProfilePictureImageView.image = image
        usernameLabel.text = username
        fullNameLabel.text = user.fullName
        bioLabel.text = user.bio
        urlButton.setTitle(websiteURLAsString, for: .normal)
        print(user.username, user.bio)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let user = UserController.shared.loggedInUser,
            let data = user.profilePicture else { return }

        self.user = user

        let image = UIImage(data: data)
        let username = user.username
        let websiteURLAsString = user.websiteURL

        userProfilePictureImageView.image = image
        usernameLabel.text = username
        fullNameLabel.text = user.fullName
        bioLabel.text = user.bio
        urlButton.setTitle(websiteURLAsString, for: .normal)
        print(user.username, user.bio)


    }

    @IBAction func editProfileButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editProfileAlertAction = UIAlertAction(title: "Edit Profile", style: .default) { (action) in
            let createAccountStoryboard = UIStoryboard(name: "Profile", bundle: nil)
            let editProfileTableViewController = createAccountStoryboard.instantiateViewController(withIdentifier: "editProfileTVC")

             self.present(editProfileTableViewController, animated: true, completion: nil)
        }
        let logOutAlertAction = UIAlertAction(title: "Log Out", style: .destructive) { (action) in
            
        }
        alertController.addAction(editProfileAlertAction)
        alertController.addAction(logOutAlertAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func urlButtonTapped(_ sender: UIButton) {
        guard let user = self.user else { return }
        guard let url = URL(string: user.websiteURL) else { return }
        
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
}
    // MARK: - Table view data source

extension ProfileTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let user = self.user else { return 0 }
        if user.isArtist == true {
            return UserController.shared.eventsCreated?.count ?? 2
        } else if user.isArtist == false {
            return 2
        }
        return 0
    }
    
}


