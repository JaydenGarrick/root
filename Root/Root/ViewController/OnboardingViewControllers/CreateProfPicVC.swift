//
//  CreateProfPicVC.swift
//  Root
//
//  Created by Frank Martin Jr on 1/10/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import CloudKit
import MapKit

class CreateProfPicVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    var isArtist: Bool?
    var fullName: String?
    var username: String?
    var hometown: String?
    var interests: [String]?
    var activityIndicator = UIActivityIndicatorView()
    let locationManager = CLLocationManager()
    var usersLocation = CLLocationCoordinate2D()

    
    var profilePictureAsData: Data? = nil
    let pickerController = UIImagePickerController()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var websiteURLTextField: UITextField!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        websiteURLTextField.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        getLocation()
        
        setUserLabel()
        pickerController.delegate = self
    }
    
    // MARK: - IBActions
    
    @IBAction func addProfPictButtonTapped(_ sender: UIButton) {
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        //pickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!

        present(pickerController, animated: true, completion: nil)
        
    }
    func setUserLabel() {
        guard let isArtist = self.isArtist
            else { return }
        if isArtist == true {
            self.userLabel.text = "Creator"
        }
        else if isArtist == false {
            userLabel.text = "Art Seeker"
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        
        if profilePictureAsData == nil && websiteURLTextField.text == "" {
            self.fillOutRequiredFields()
        } else {
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            sender.isEnabled = false
            
            guard let username = self.username,
                let fullName = self.fullName,
                let profilePictureAsData = self.profilePictureAsData,
                let hometown = self.hometown,
                let interests = self.interests,
                let websiteURL = websiteURLTextField.text,
                let isArtist = self.isArtist
                else { alert(error: "Something is missing line 91") ; return  }
            
            UserController.shared.createUserWith(username: username, fullName: fullName, profilePicture: profilePictureAsData, bio: "", homeTown: hometown, interests: interests, websiteURL: websiteURL, isArtist: isArtist) { (success) in
                if success {
                    guard let user = UserController.shared.loggedInUser else { self.alert(error: "Line 95") ; return }
                    print(user.username, user.fullName, user.bio, user.homeTown, user.appleUserRef, user.isArtist)

                    EventController.shared.fetchEvents(usersLocation: self.usersLocation, completion: { (success) in
                        if success {
                            // Current date plus 24 hours
                            let dateToCheckFromAsDouble = Date().timeIntervalSince1970 + 86400 // 86400 represents 24 hours
                            let dateToCheckFrom = Date(timeIntervalSince1970: dateToCheckFromAsDouble)
                            for event in EventController.shared.fetchedEvents {
                                if event.dateAndTime > dateToCheckFrom  {
                                    EventController.shared.eventHappeningWithinTwentyFour.append(event)
                                }
                            }
                            print("Success fetching events within 50 miles! :)")
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "SegueToTabBarID", sender: self)
                            }
                        } else {
                            self.alert(error: "Line 113")
                            print("Failure fetching events within 50 miles. :(")
                        }
                    })
                } else {
                    self.alert(error: "Error line 118")
                    return
                }
            }
        }
    }
    
    
    
    // MARK: - Image picker delegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      
        
        guard let profilePicture = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
       // let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        profilePictureImageView.image = profilePicture
        profilePictureImageView.contentMode = .scaleAspectFit
        //profilePictureImageView.image = profilePicture
        DispatchQueue.main.async {
            
            self.dismiss(animated: true, completion: nil)
            self.profilePictureImageView.alpha = 1
        }
        let profilePictureAsData = UIImagePNGRepresentation(profilePicture)
        self.profilePictureAsData = profilePictureAsData
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    // Gets the users current location
    func getLocation() {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let coordinate = locations.last?.coordinate else { return }
            usersLocation = coordinate
        }
    }
    
}

extension CreateProfPicVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



// MARK: - DELETE ME LATER
extension CreateProfPicVC {
    
    func alert(error: String) {
        let alertController = UIAlertController(title: "what's the error?", message: "\(error)", preferredStyle: .alert)
        let action = UIAlertAction(title: "🙃🙃🙃🙃🙃🙃🙃🙃", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

}





