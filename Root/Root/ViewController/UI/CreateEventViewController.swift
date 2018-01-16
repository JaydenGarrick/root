//
//  CreateEventViewController.swift
//  Root
//
//  Created by Edmund Bollenbacher on 1/10/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import MapKit

class CreateEventViewController: UIViewController {

    
    // MARK: - Constants and Variables
    var profilePictureAsData: Data? = nil
    let pickerController = UIImagePickerController()
    var interests: [String] = []
    var activityIndicator = UIActivityIndicatorView()
    let datePicker = UIDatePicker()
    var dateOfEvent: Date? = Date()
    
   
    // MARK: - IBOutlets
    @IBOutlet weak var eventPictureImageView: UIImageView!
    @IBOutlet weak var nameOfArtistLabel: UILabel!
    @IBOutlet weak var titleOfEventTextField: UITextField!
    @IBOutlet weak var timeDateTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextField: UITextField!
    @IBOutlet weak var typeOfEventTextField: UITextField!
    @IBOutlet weak var addVenueButton: UIButton!
    @IBOutlet weak var barItem: UINavigationBar!
    @IBOutlet weak var interestsTextView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        createDatePicker()
        
        pickerController.delegate = self
        barItem.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        nameOfArtistLabel.text = UserController.shared.loggedInUser?.username

    }

   
    
    
    // MARK: - IBAction Functions
    @IBAction func addProfilePictureButton(_ sender: Any) {
        
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        pickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(pickerController, animated: true, completion: nil)
        
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
    
    @IBAction func photoButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#photography") {
            return
        }
        self.interests.append("#photography")
        updateInterestsTextView()
    }
    
    @IBAction func poetryButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#poetry") {
            return
        }
        interests.append("#poetry")
        updateInterestsTextView()
    }
    
    @IBAction func sketchButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#sketch") {
            return
        }
        interests.append("#sketch")
        updateInterestsTextView()
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func ceramicButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#pottery") {
            return
        }
        interests.append("#pottery")
        updateInterestsTextView()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        sender.isEnabled = false
        
        guard let name = titleOfEventTextField.text,
            let description = eventDescriptionTextField.text,
            let venue = addVenueButton.titleLabel?.text,
            let eventImageData = profilePictureAsData,
            let dateOfEvent = dateOfEvent,
            let typeOfEvent = typeOfEventTextField.text,
        let user = UserController.shared.loggedInUser else { return }
        
        
        
        EventController.shared.createEventWith(name: name, eventImage: eventImageData, dataAndTime: dateOfEvent, description: description, venue: venue, artist: [user], typeOfEvent: typeOfEvent) { (success) in
            if success {
                print("Success! :)")
                DispatchQueue.main.async {
                    
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print("Failure! :(")
            }
        }
    }
    
  
    
    func updateInterestsTextView() {
        var textFieldText: String = ""
        for interest in self.interests {
            textFieldText += " \(interest)"
        }
        interestsTextView.text = textFieldText
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? SearchViewController else { return }
        destinationVC.delegate = self
    }
}

// MARK: - Delegate Functions
extension CreateEventViewController: SearchViewControllerDelegate {
    func updateLongLat(long: Double, lat: Double) {
        let geocoder = CLGeocoder()
        
        let location = CLLocation(latitude: lat, longitude: long)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error reverse geocoding while creating event: \(error.localizedDescription)")
            }
            guard let placemark = placemarks?.first else { return }
            
            self.addVenueButton.setTitle("\(placemark.name!), \(placemark.postalCode!), \(placemark.administrativeArea!), \(placemark.subThoroughfare!)", for: .normal)
            
        }
        
    }
    
    
}

// MARK: - ImagePicker Delegate and Functions
extension CreateEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let profilePicture = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        eventPictureImageView.contentMode = .scaleAspectFill
        eventPictureImageView.image = profilePicture
        DispatchQueue.main.async {

            self.dismiss(animated: true, completion: nil)
            self.eventPictureImageView.alpha = 1
        }
        let profilePictureAsData = UIImagePNGRepresentation(profilePicture)
        self.profilePictureAsData = profilePictureAsData
    }
}

// MARK: - Setting up DatePicker as keyboard for Date
extension CreateEventViewController {
    
    func createDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        timeDateTextField.inputAccessoryView = toolbar
        timeDateTextField.inputView = datePicker
        
    }
    
    
    @objc func donePressed() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateAsString = dateFormatter.string(from: datePicker.date)
        timeDateTextField.text = dateAsString
        dateOfEvent = datePicker.date
        
        self.view.endEditing(true)
    }
}





















