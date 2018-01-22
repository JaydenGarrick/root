//
//  EditProfileTableViewController.swift
//  Root
//
//  Created by Frank Martin Jr on 1/14/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    let pickerController = UIImagePickerController()
    var profilePictureAsData: Data? = nil
    var interests: [String] = []
    
    // MARK: -IBOutlets
    
    @IBOutlet weak var userProfilePictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var interestsTextField: UITextField!
    @IBOutlet weak var websiteURLTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        // Clear navbar setup
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.hideKeyboardWhenTappedAround()
        
        pickerController.delegate = self
        
        
        // Set user's properties on VC
        guard let user = UserController.shared.loggedInUser,
            let data = user.profilePicture else { return }
        
        if user.isArtist == false {
            websiteURLTextField.isHidden = true
        }
        self.profilePictureAsData = data
        let image = UIImage(data: data)
        let username = user.username
        let fullName = user.fullName
        let websiteURLAsString = user.websiteURL
        self.interests = user.interests
        updateInterestsTextView()
        
        userProfilePictureImageView.image = image
        usernameLabel.text = username
        fullNameTextField.text = fullName
        bioTextField.text = user.bio
        websiteURLTextField.text = websiteURLAsString
        
        //        interestsTextView.text =
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        // Make profile picture image round
//        self.userProfilePictureImageView.layer.cornerRadius = self.userProfilePictureImageView.frame.size.width / 2
//        self.userProfilePictureImageView.clipsToBounds = true
        
    }
    
    
    // MARK: - IBActions
    
    @IBAction func cancelBarButtonItemTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        guard let user = UserController.shared.loggedInUser,
            let fullName = self.fullNameTextField.text,
            // let profilePicture
            let bio = self.bioTextField.text,
            let websiteURL = self.websiteURLTextField.text,
            let profilePicture = self.profilePictureAsData
            else { return }
        
        
        UserController.shared.updateUser(user: user, fullName: fullName, profilePicture: profilePicture, bio: bio, homeTown: user.homeTown, interests: self.interests, websiteURL: websiteURL) { (success) in
            DispatchQueue.main.async {
                print("success")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func imagePickerButtonTapped(_ sender: UIButton) {
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func paintButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#paintings") {
            return
        }
        self.interests.append("#paintings")
        updateInterestsTextView()
    }
    
    @IBAction func musicButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#music") {
            return
        }
        
        self.interests.append("#music")
        updateInterestsTextView()
    }
    
    @IBAction func photographyButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#photography") {
            return
        }
        self.interests.append("#photography")
        updateInterestsTextView()
    }
    
    @IBAction func sketchButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#sketch") {
            return
        }
        interests.append("#poetry")
        updateInterestsTextView()
    }
    
    @IBAction func potteryButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#pottery") {
            return
        }
        interests.append("#pottery")
        updateInterestsTextView()
    }
    
    
    // MARK: - Image picker delegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        pickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        guard let profilePicture = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        // let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        
        //        userProfilePictureImageView.contentMode = .scaleAspectFit
        userProfilePictureImageView.image = profilePicture
        //userProfilePictureImageView.image = profilePicture
        
        DispatchQueue.main.async {
            
            self.dismiss(animated: true, completion: nil)
            
        }
        let profilePictureAsData = UIImagePNGRepresentation(profilePicture)
        self.profilePictureAsData = profilePictureAsData
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateInterestsTextView() {
        
        var textFieldText: String = ""
        for interest in self.interests {
            textFieldText += " \(interest)"
        }
        interestsTextField.text = textFieldText
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
//        guard let user = UserController.shared.loggedInUser else { return 0 }
//        if user.isArtist == true {
//            return 3
//        } else if user.isArtist == false {
//            return 2
//        }
        return 3
    }
    
}

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//
//
//    }

/*
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
 
 // Configure the cell...
 
 return cell
 }
 */

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

