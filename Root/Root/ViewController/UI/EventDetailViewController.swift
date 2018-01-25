//
//  EventDetailViewController.swift
//  Root
//
//  Created by Jayden Garrick on 1/18/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import MessageUI
import CoreLocation

class EventDetailViewController: UIViewController, MFMailComposeViewControllerDelegate, CLLocationManagerDelegate{
    
    // MARK: - Constants and Variables
    var event: Event?
    var artist: User?
    var loggedInUser: User?
    let blockedUserNotification = Notification.Name("User Was Blocked")
    
    // Core Location
    let locationManager = CLLocationManager()
    var usersLocation = CLLocationCoordinate2D()
    
    static let bottomSpacing: CGFloat = 20.0
    
    // MARK: - IBOutlets
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var artistsWhoCreatedEventImageView: UIImageViewX!
    @IBOutlet weak var artistWhoCreatedEventLabel: UILabel!
    @IBOutlet weak var nameOfEventLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabelX!
    @IBOutlet weak var nameOfVenueLabel: UILabel!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var newCommentTextField: UITextField!
    @IBOutlet weak var postCommentButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // Core Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        getLocation()
        
        // Handle Nav Bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = UIColor(named: "Tint")
        
        
       
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "•••", style: .plain, target: self, action: #selector(blockUserButtonTapped))
      

        // Delegate
        self.commentsTableView.dataSource = self
        self.commentsTableView.delegate = self
        newCommentTextField.delegate = self
        self.scrollView.delegate = self
        guard let event = event,
            let loggedInUser = UserController.shared.loggedInUser,
            let loggedInUserProfilePictureAsData = loggedInUser.profilePicture
            else { return }
        
        //let loggedInUserProfilePictureAsImage = UIImage(data: loggedInUserProfilePictureAsData)
        //newCommentUserProfilePicture.image = loggedInUserProfilePictureAsImage
        
        
        
        UserController.shared.fetchEventCreator(event: event) { (user) in
            guard let user = user else { return }
            self.artist = user
            DispatchQueue.main.async {
                self.updateViews()
            }
            CommentController.shared.fetchCommentsForCurrent(event: event, completion: { (success) in
                
                DispatchQueue.main.async {
                    self.commentsTableView.reloadData()
                }
            })
        }
        
    }
    
    @objc func blockUserButtonTapped() {
        guard let event = self.event else { return }
        let eventActionAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let blockUserAction = UIAlertAction(title: "Block user", style: .destructive) { (action) in
            // Confirm that the user wants to block a user
            let confirmationAlertController = UIAlertController(title: "Are you sure you want to block this user?", message: nil, preferredStyle: .alert)
            let blockAction = UIAlertAction(title: "Block user", style: .destructive, handler: { (action) in
                self.blockUser(any: nil)
                EventController.shared.fetchEvents(usersLocation: self.usersLocation, completion: { (success) in
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                })
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            })
            
            confirmationAlertController.addAction(blockAction)
            confirmationAlertController.addAction(cancelAction)
            self.present(confirmationAlertController, animated: true, completion: nil)
            
        }
        
        let reportAction = UIAlertAction(title: "Report", style: .default) { (action) in
            let body = "I found the following event offensive: \n \(event.title) \n\n Event information (please do not delete): \n \(event.ckRecordID)"
            
            self.report(body: body)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            eventActionAlertController.dismiss(animated: true, completion: nil)
        }
        
        eventActionAlertController.addAction(blockUserAction)
        eventActionAlertController.addAction(reportAction)
        eventActionAlertController.addAction(cancelAction)
        present(eventActionAlertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToArtistProfileSegue" {
            guard let destinationVC = segue.destination as? ArtistProfileViewController,
                let artist = self.artist
                else { return }
            destinationVC.artist = artist
        }
    }
    
    // MARK: - IBActions
    @IBAction func postCommentButtonTapped(_ sender: UIButton) {
        if newCommentTextField.text == "" {
            self.fillOutRequiredFields()
        } else {
            guard let text = newCommentTextField.text,
                let event = self.event,
                let loggedInUser = UserController.shared.loggedInUser
                else { return }
            self.newCommentTextField.text = ""
            CommentController.shared.createNewCommentWith(text: text, event: event, loggedInUser: loggedInUser) { (success) in
                DispatchQueue.main.async {
                    self.commentsTableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Other functions
    
    func blockUser(any: Any?) {
        if any != nil {
        guard let event = self.event else { return }
        
        let indexPath = any as! IndexPath
        
        let comment = CommentController.shared.eventComments[indexPath.row]
        
        CommentController.shared.fetchCommentCreator(comment: comment, completion: { (user) in
            guard let user = user else { return }
            
            UserController.shared.block(user: user, vc: self, completion: { (success) in
                
                CommentController.shared.fetchCommentsForCurrent(event: event, completion: { (success) in
                    
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: self.blockedUserNotification, object: self)
                        self.commentsTableView.reloadData()
                    }
                })
            })
        })
        } else {
            guard let artist = self.artist else { return }
            UserController.shared.block(user: artist, vc: self, completion: { (success) in
                
            })
            
        }
    }
    
    func report(body: String) {
    
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        
        // Check to see if user has email enabled on their phone (a default alertview will present from if statement below).
        if !MFMailComposeViewController.canSendMail() {
            
        } else {
            
            // If user does have mail
            mailComposeViewController.setToRecipients(["fmartin0212@gmail.com"])
            mailComposeViewController.setSubject("Offensive material")
            mailComposeViewController.setMessageBody(body, isHTML: false)
            //
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    func getLocation() {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let coordinate = locations.last?.coordinate else { return }
            usersLocation = coordinate
        }
    }
}

// MARK: - Update Views Function
extension EventDetailViewController {
    func updateViews() {
        guard let event = event,
            let user = self.artist,
            let eventImageData = event.eventImage,
            let eventImage = UIImage(data: eventImageData),
            let userProfilePicture = user.profilePicture,
            let userProfilePictureAsImage = UIImage(data: userProfilePicture)
            else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        let date = dateFormatter.string(from: event.dateAndTime)
        
        eventImageView.image = eventImage
        artistsWhoCreatedEventImageView.image = userProfilePictureAsImage
        artistWhoCreatedEventLabel.text = user.username
        nameOfEventLabel.text = event.name
        eventDescriptionLabel.text = event.eventDescription
        nameOfVenueLabel.text = event.venue
        streetAddressLabel.text = event.venue
        dateLabel.text = date
    }
}



// MARK: - TableView Delegate and DataSource
extension EventDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return number of comments
        return CommentController.shared.eventComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentTableViewCell ?? CommentTableViewCell()
        
        let comment = CommentController.shared.eventComments[indexPath.row]
        
        cell.comment = comment
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // "Block user" action upon swipe
        let blockUserRowAction = UITableViewRowAction(style: .default, title: "Block user") { (rowAction, indexPath) in
            // Confirmation alert controller
            let confirmationAlertController = UIAlertController(title: "Are you sure you want to block this user?", message: nil, preferredStyle: .alert)
            let blockAction = UIAlertAction(title: "Block user", style: .destructive, handler: { (action) in
                self.blockUser(any: indexPath)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            })
            
            confirmationAlertController.addAction(blockAction)
            confirmationAlertController.addAction(cancelAction)
            self.present(confirmationAlertController, animated: true, completion: nil)
        }
        blockUserRowAction.backgroundColor = .red
        
        // "Report offensive" action upon swipe
        let reportOffensiveRowAction = UITableViewRowAction(style: .default, title: "Report as offensive") { (rowAction, indexPath) in
            let confirmationAlert = UIAlertController(title: "Would you also like to block this user?", message: nil, preferredStyle: .alert)
           
            let blockAndReportAction = UIAlertAction(title: "Block & report", style: .destructive, handler: { (action) in
                // block user
                self.blockUser(any: indexPath)
                // report user
                let body = "I found the following comment offensive: \n\n\"\(CommentController.shared.eventComments[indexPath.row].text)\" \n\n \n \n Comment information (please do not delete) \(CommentController.shared.eventComments[indexPath.row].creatorID))"
                self.report(body: body)
                
            })
            
            let reportAction = UIAlertAction(title: "Report", style: .default, handler: { (action) in
                //report user
                let body = "I found the following comment offensive: \n\n\"\(CommentController.shared.eventComments[indexPath.row].text)\" \n\n \n \n Comment information (do not delete) \(CommentController.shared.eventComments[indexPath.row].creatorID))"
                self.report(body: body)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            })
            
            confirmationAlert.addAction(blockAndReportAction)
            confirmationAlert.addAction(reportAction)
            confirmationAlert.addAction(cancelAction)
            
            self.present(confirmationAlert, animated: true, completion: nil)
            
        }
        reportOffensiveRowAction.backgroundColor = UIColor(named: "Tint")
        
        return [reportOffensiveRowAction, blockUserRowAction]
    }
    
}


// MARK: - TextField Delegate
extension EventDetailViewController: UITextFieldDelegate {
    
    
    // FIXME: Get this working once constraints are redone
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //scrollView.setContentOffset(CGPoint(x:0, y:250), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    
}


// MARK: - Mail Compose View Delegate Methods
extension EventDetailViewController {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension EventDetailViewController: UINavigationControllerDelegate {
    // Need this in order to get the mail compose view controller delegate to function properly.
    
}






