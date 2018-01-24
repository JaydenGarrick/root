//
//  EventDetailViewController.swift
//  Root
//
//  Created by Jayden Garrick on 1/18/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    // MARK: - Constants and Variables
    var event: Event?
    var artist: User?
    var loggedInUser: User?
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
        
        // Delegate
        self.commentsTableView.dataSource = self
        self.commentsTableView.delegate = self
        newCommentTextField.delegate = self
        self.scrollView.delegate = self
        guard let event = event,
            let loggedInUser = UserController.shared.loggedInUser,
            let loggedInUserProfilePictureAsData = loggedInUser.profilePicture
            else { return }
        
        let loggedInUserProfilePictureAsImage = UIImage(data: loggedInUserProfilePictureAsData)
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




