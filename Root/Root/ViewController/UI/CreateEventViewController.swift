//
//  CreateEventViewController.swift
//  Root
//
//  Created by Edmund Bollenbacher on 1/10/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import MapKit

class CreateEventViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    // MARK: - Constants and Variables
    var profilePictureAsData: Data? = nil
    let pickerController = UIImagePickerController()
    var interests: [String] = []
    var activityIndicator = UIActivityIndicatorView()
    let datePicker = UIDatePicker()
    var dateOfEvent: Date? = Date()
    let locationManager = CLLocationManager()
    var usersLocation = CLLocationCoordinate2D()

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
        self.navigationController?.isNavigationBarHidden = false
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        self.hideKeyboardWhenTappedAround()
        createDatePicker()
        pickerController.delegate = self
        nameOfArtistLabel.text = UserController.shared.loggedInUser?.username

    }
    
    func getLocation() {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let coordinate = locations.last?.coordinate else { return }
            usersLocation = coordinate
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    

   
    
    
    // MARK: - IBAction Functions
    @IBAction func addProfilePictureButton(_ sender: Any) {
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
//        pickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func paintButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#paintings") {
            self.interests.removeAll(keepingCapacity: false)
            updateInterestsTextView()
            return
        }
        self.interests.removeAll(keepingCapacity: false)
        self.interests.append("#paintings")
        updateInterestsTextView()
    }
    
    @IBAction func musicButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#music") {
            self.interests.removeAll(keepingCapacity: false)
            updateInterestsTextView()
            return
        }
        self.interests.removeAll(keepingCapacity: false)
        self.interests.append("#music")
        updateInterestsTextView()
    }
    
    @IBAction func photoButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#photography") {
            self.interests.removeAll(keepingCapacity: false)
            updateInterestsTextView()
            return
        }
        self.interests.removeAll(keepingCapacity: false)
        self.interests.append("#photography")
        updateInterestsTextView()
    }
    
    @IBAction func poetryButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#poetry") {
            self.interests.removeAll(keepingCapacity: false)
            updateInterestsTextView()
            return
        }
        self.interests.removeAll(keepingCapacity: false)
        interests.append("#poetry")
        updateInterestsTextView()
    }
    
    @IBAction func sketchButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#sketch") {
            self.interests.removeAll(keepingCapacity: false)
            updateInterestsTextView()
            return
        }
        self.interests.removeAll(keepingCapacity: false)
        interests.append("#sketch")
        updateInterestsTextView()
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func ceramicButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#pottery") {
            self.interests.removeAll(keepingCapacity: false)
            updateInterestsTextView()
            return
        }
        self.interests.removeAll(keepingCapacity: false)
        interests.append("#pottery")
        updateInterestsTextView()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if titleOfEventTextField.text == "" || eventDescriptionTextField.text == "" || addVenueButton.titleLabel?.text == "Add Venue" || profilePictureAsData == nil || timeDateTextField.text == "" || typeOfEventTextField.text == "" {
            self.fillOutRequiredFields()
        } else {
            activityIndicator.center = self.view.center
            activityIndicator.tintColor = UIColor(named: "Tint")
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
                    EventController.shared.fetchEvents(usersLocation: self.usersLocation, completion: { (success) in
                        if success {
                            // Current date plus 24 hours
                            let dateToCheckFromAsDouble = Date().timeIntervalSince1970 + 86400 // 86400 represents 24 hours
                            let dateToCheckFrom = Date(timeIntervalSince1970: dateToCheckFromAsDouble)
                            for event in EventController.shared.fetchedEvents {
                                if event.dateAndTime < dateToCheckFrom && event.dateAndTime > Date()  {
                                    for alreadyFetchedEvent in EventController.shared.eventHappeningWithinTwentyFour {
                                        if event != alreadyFetchedEvent {
                                            EventController.shared.eventHappeningWithinTwentyFour.append(event)
                                        }
                                    }
                                }
                            }
                                self.performSegue(withIdentifier: "tabBarID", sender: self)
                
                            print("Success fetching events after creating event! :)")
                        } else {
                            print("Failure fetching events within 50 miles. :(")
                        }
                    })
                } else {
                    print("Failure! :(")
                }
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
            guard let name = placemark.name,
                let postalCode = placemark.postalCode,
                let administrativeArea = placemark.administrativeArea,
                let subThoroughFare = placemark.subThoroughfare,
                let locality = placemark.locality else {
                    self.geoCodeAlert()
                    return
            }
            self.addVenueButton.setTitle("\(name), \(postalCode), \(administrativeArea), \(subThoroughFare), \(locality)", for: .normal)
        }
    }
    
    
}

// MARK: - ImagePicker Delegate and Functions
extension CreateEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let profilePicture = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
       // let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        eventPictureImageView.image = profilePicture
        eventPictureImageView.contentMode = .scaleAspectFill
        //eventPictureImageView.image = profilePicture
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
        doneButton.tintColor = UIColor(named: "Tint")        
        timeDateTextField.inputAccessoryView = toolbar
        timeDateTextField.inputView = datePicker
        
    }
    
    
    @objc func donePressed() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let dateAsString = dateFormatter.string(from: datePicker.date)
        timeDateTextField.text = dateAsString
        dateOfEvent = datePicker.date
        
        self.view.endEditing(true)
    }
}

// MARK: - Setting up alert
extension CreateEventViewController {
    func geoCodeAlert() {
        let alertController = UIAlertController(title: "☹️", message: "We were unable to find that location.", preferredStyle: .alert)
        alertController.view.tintColor = UIColor(named: "Tint")
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}





















