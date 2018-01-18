//
//  EventDetailTableViewController.swift
//  Root
//
//  Created by Jayden Garrick on 1/12/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class EventDetailTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var artistsWhoCreatedEventImageView: UIImageView!
    @IBOutlet weak var artistWhoCreatedEventLabel: UILabel!
    @IBOutlet weak var nameOfEventLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var nameOfVenueLabel: UILabel!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newCommentTextField: UITextField!
    @IBOutlet weak var commentsTableView: UITableView!
   
    // MARK: - Constants and Variables
    var event: Event?
    var artist: User?
    var commentDataSource: CommentsTableViewDataSource = CommentsTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableView.delegate = self
        commentsTableView.dataSource = self.commentDataSource

        
        
        self.hideKeyboardWhenTappedAround()
        
        guard let event = event else { return }
        
//        
//        CommentController.shared.fetchCommentsForCurrent(event: event, completion: { (comments) in
//            DispatchQueue.main.async {
//                guard let comments = comments else { return }
//
//                self.commentDataSource.eventComments = comments
//                print("number of event comments: \(comments.count)")
//                self.commentsTableView.reloadData()
//                
//            }
//        })

        UserController.shared.fetchEventCreator(event: event) { (user) in
            guard let user = user else { return }
            self.artist = user
            DispatchQueue.main.async {
                
                self.updateViews()
            }
        }
        
    }
    
    // MARK: - IBActions
    
    @IBAction func postComment(_ sender: UIButton) {
        guard let text = newCommentTextField.text,
        let event = event
        else { return }
        CommentController.shared.createNewCommentWith(text: text, event: event)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToArtistProfileSegue" {
            guard let destinationVC = segue.destination as? ArtistProfileTableViewController,
                let artist = self.artist
                else { return }
            destinationVC.artist = artist
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
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
