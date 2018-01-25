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
    
    // MARK: - ViewDidLoad
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
    
    
    // MARK: - IBActions
    @IBAction func cancelBarButtonItemTapped(_ sender: UIBarButtonItem) {
        unsavedChangesAlert()
    }
    
    
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        if fullNameTextField.text == "" || websiteURLTextField.text == "" || interestsTextField.text == "" {
            self.fillOutRequiredFields()
        } else {
            guard let user = UserController.shared.loggedInUser,
                let fullName = self.fullNameTextField.text,
                // let profilePicture
                let bio = bioTextField.text,
                let websiteURL = websiteURLTextField.text,
                let profilePicture = profilePictureAsData
                else { return }
            
            
            UserController.shared.updateUser(user: user, fullName: fullName, profilePicture: profilePicture, bio: bio, homeTown: user.homeTown, interests: self.interests, websiteURL: websiteURL) { (success) in
                DispatchQueue.main.async {
                    print("success")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func imagePickerButtonTapped(_ sender: UIButton) {
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func paintButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#paintings") {
            let indexPath = self.interests.index(of: "#paintings")
            interests.remove(at: indexPath!)
            updateInterestsTextView()
            return
        }
        self.interests.append("#paintings")
        updateInterestsTextView()
    }
    
    @IBAction func musicButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#music") {
            let indexPath = self.interests.index(of: "#music")
            interests.remove(at: indexPath!)
            updateInterestsTextView()
            return
        }
        self.interests.append("#music")
        updateInterestsTextView()
    }
    
    @IBAction func photographyButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#photography") {
            let indexPath = self.interests.index(of: "#photography")
            interests.remove(at: indexPath!)
            updateInterestsTextView()
            return
        }
        self.interests.append("#photography")
        updateInterestsTextView()
    }
    
    @IBAction func poetryButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#poetry") {
            let indexPath = self.interests.index(of: "#poetry")
            interests.remove(at: indexPath!)
            updateInterestsTextView()
            return
        }
        self.interests.append("#poetry")
        updateInterestsTextView()
    
    }
    
    @IBAction func sketchButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#sketch") {
            let indexPath = self.interests.index(of: "#sketch")
            interests.remove(at: indexPath!)
            updateInterestsTextView()
            return
        }
        self.interests.append("#sketch")
        updateInterestsTextView()
    }
    
    @IBAction func potteryButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#pottery") {
            let indexPath = self.interests.index(of: "#pottery")
            interests.remove(at: indexPath!)
            updateInterestsTextView()
            return
        }
        self.interests.append("#pottery")
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

        return 3
    }
    
}


// MARK: - Setting up alerts notifying users they have unsaved changes
extension EditProfileTableViewController {
    func unsavedChangesAlert() {
        let unsavedChangesAlert = UIAlertController(title: "Unsaved Changes", message: "You may have unsaved changes. Are you sure you want to cancel?", preferredStyle: .alert)
        unsavedChangesAlert.view.tintColor = UIColor(named: "Tint")
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        unsavedChangesAlert.addAction(yesAction)
        unsavedChangesAlert.addAction(noAction)
        present(unsavedChangesAlert, animated: true)
    }
    
}







