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
        self.navigationController?.view.backgroundColor = .clear
        
        let font = UIFont.systemFont(ofSize: 33)
        barButtonItem.setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font], for: .normal)
        barButtonItem.setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font], for: .selected)
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.userProfilePictureImageView.layer.cornerRadius = self.userProfilePictureImageView.frame.size.width / 2
        self.userProfilePictureImageView.clipsToBounds = true

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
//
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let user = self.user else { return 0 }
        if user.isArtist == true {
            return 3
        } else if user.isArtist == false {
            return 2
        }
            return 0
        }
    
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }
    //
    //
    //     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    //
    //     // Configure the cell...
    //
    //     return cell
    //     }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
