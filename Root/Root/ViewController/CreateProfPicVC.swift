//
//  CreateProfPicVC.swift
//  Root
//
//  Created by Frank Martin Jr on 1/10/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class CreateProfPicVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    var isArtist: Bool?
    var fullName: String?
    var username: String?
    var hometown: String?
    var interests: [String]?
    
    var profilePictureAsData: Data? = nil
    let pickerController = UIImagePickerController()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var websiteURLTextField: UITextField!
    
    // MARK: - IBActions
    
    @IBAction func addProfPictButtonTapped(_ sender: UIButton) {
        
        pickerController.allowsEditing = false
        pickerController.sourceType = .photoLibrary
        pickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(pickerController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUserLabel()
        pickerController.delegate = self
    }
    
    func setUserLabel() {
        guard let isArtist = self.isArtist
            else { return }
        if isArtist == true {
            self.userLabel.text = "Artist"
        }
        else if isArtist == false {
            userLabel.text = "Art Seeker"
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        
        guard let username = self.username,
            let fullName = self.fullName,
            let profilePictureAsDatablah = self.profilePictureAsData,
            let hometown = self.hometown,
            let interests = self.interests,
            let websiteURL = websiteURLTextField.text,
            let isArtist = self.isArtist
            else { return }
        
        UserController.shared.createUserWith(username: username, fullName: fullName, profilePicture: profilePictureAsDatablah, bio: "", homeTown: hometown, interests: interests, websiteURL: websiteURL, isArtist: isArtist) { (success) in
            guard let user = UserController.shared.loggedInUser else { return }
            print(user.username, user.fullName, user.bio, user.homeTown, user.appleUserRef, user.isArtist)
        }
    }
    // MARK: - Image picker delegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      
        guard let profilePicture = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        profilePictureImageView.contentMode = .scaleAspectFit
        profilePictureImageView.image = profilePicture
        dismiss(animated: true, completion: nil)
        profilePictureImageView.alpha = 1
        let profilePictureAsData = UIImagePNGRepresentation(profilePicture)
        self.profilePictureAsData = profilePictureAsData
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let username = self.username,
            let fullName = self.fullName,
            let profilePicture = self.profilePictureAsData,
            let hometown = self.hometown,
            let interests = self.interests,
            let websiteURL = websiteURLTextField.text,
            let isArtist = self.isArtist
            else { return }
        
        UserController.shared.createUserWith(username: username, fullName: fullName, profilePicture: profilePicture, bio: "", homeTown: hometown, interests: interests, websiteURL: websiteURL, isArtist: isArtist) { (success) in
            
        }
        
    }
    
}
