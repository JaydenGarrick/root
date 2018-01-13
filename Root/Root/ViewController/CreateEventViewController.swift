//
//  CreateEventViewController.swift
//  Root
//
//  Created by Edmund Bollenbacher on 1/10/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var profilePictureAsData: Data? = nil
    let pickerController = UIImagePickerController()
    
    @IBOutlet weak var eventPictureImageView: UIImageView!
    @IBOutlet weak var nameOfArtistLabel: UILabel!
    @IBOutlet weak var titleOfEventTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var timeDateTextField: UITextField!
    @IBOutlet weak var typeOfEventTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboard()
        pickerController.delegate = self

    }

    @IBAction func addProfilePictureButton(_ sender: Any) {
        
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        pickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let profilePicture = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        eventPictureImageView.contentMode = .scaleAspectFit
        eventPictureImageView.image = profilePicture
        DispatchQueue.main.async {
            
            self.dismiss(animated: true, completion: nil)
            self.eventPictureImageView.alpha = 1
        }
        let profilePictureAsData = UIImagePNGRepresentation(profilePicture)
        self.profilePictureAsData = profilePictureAsData
    }
    
    @IBAction func paintButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func musicButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func photoButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func poetryButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func sketchButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func ceramicButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {

        guard let description = eventDescriptionTextView.text,
            let venue = locationTextField.text,
            let eventName = titleOfEventTextField.text,
            let image = eventPictureImageView.image,
            let imageAsData = UIImagePNGRepresentation(image),
            let user = UserController.shared.loggedInUser else { return }
        
        
        
        
        
        EventController.shared.createEventWith(name: eventName, eventImage: imageAsData, dataAndTime: Date(), description: description, venue: venue, artist: [user]) { (success) in
            if success {
                print("Success")
            } else {
                print("Not success")
            }
        }
        self.dismiss(animated: true, completion: nil)
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
