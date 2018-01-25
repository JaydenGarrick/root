//
//  ArtistProfileViewController.swift
//  Root
//
//  Created by Jayden Garrick on 1/18/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import CloudKit

class ArtistProfileViewController: UIViewController {

    // MARK: - Properties
    
    var artist: User?
    var usersLocation = CLLocationCoordinate2D()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var artistProfilePictureImageView: UIImageView!
    @IBOutlet weak var artistUserNameLabel: UILabel!
    @IBOutlet weak var artistBioLabel: UILabel!
    @IBOutlet weak var artistWebsiteURLButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
   
    
    // MARK: - View Did Load / UpdateViews function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate DataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Block user button gone if it's on users profile
        if artist?.username == UserController.shared.loggedInUser?.username && artist?.fullName == UserController.shared.loggedInUser?.fullName {
            navigationItem.rightBarButtonItem = nil
        }
        
        // Update The Views
        updateViews()
        
        // Handle Nav Bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor(named: "Tint")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "•••", style: .plain, target: self, action: #selector(blockUserButtonTapped))
        
        guard let artist = artist else { return }
        
        UserController.shared.fetchEventsFor(user: artist) { (success) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print("\(String(describing: UserController.shared.eventsCreated?.count)) is the total amount of events created by this artist!")
            }
        }
    }

    
    func updateViews() {
        
        guard let artist = artist,
            let data = artist.profilePicture else { return }
        let artistProfilePictureAsImage = UIImage(data: data)
        
        artistProfilePictureImageView.image = artistProfilePictureAsImage
        artistUserNameLabel.text = artist.username
        artistBioLabel.text = artist.bio
        artistWebsiteURLButton.setTitle("\(artist.websiteURL)", for: .normal)
    }

    // MARK: - IBActions
    @IBAction func profileActionButtonTapped(_ sender: UIButton) {
     
    }
   
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WebSegue" {
            guard let destinationVC = segue.destination as? WebViewController else { return }
            let urlAsString = (artistWebsiteURLButton.titleLabel?.text)!
            destinationVC.websiteURLAsString = urlAsString
        }
    }
}




// MARK : - TableView DataSource and Delegate Methods
extension ArtistProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return number of events this artist has created
        guard let eventsCreated = UserController.shared.eventsCreated else { return 0 }
        return eventsCreated.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventFeedCell", for: indexPath) as! EventTableViewCell
        guard let eventsCreated = UserController.shared.eventsCreated else { return UITableViewCell() }
        let event = eventsCreated[indexPath.row]
        let eventImage = UIImage(data: event.eventImage!)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .full
        
        cell.eventPictureImageView.image = eventImage
        cell.dateEventLabel.text = dateFormatter.string(from: event.dateAndTime)
        cell.typeOfArtLabel.text = event.typeOfEvent
        cell.artistNameLabel.text = event.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 111
    }
    
}

// Handling Blocking a user
extension ArtistProfileViewController {
    @objc func blockUserButtonTapped() {
        let actionSheetAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let blockUserAction = UIAlertAction(title: "Block user", style: .destructive) { (action) in
            let confirmationAlertController = UIAlertController(title: "Are you sure you want to block this user?", message: nil, preferredStyle: .alert)
            let blockUserAction = UIAlertAction(title: "Block user", style: .destructive, handler: { (action) in
                guard let artist = self.artist
                    else { return }
                UserController.shared.block(user: artist, vc: self, completion: { (success) in
                    EventController.shared.fetchEvents(usersLocation: self.usersLocation, completion: { (success) in
                        DispatchQueue.main.async {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    })
                })
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                
            })
            confirmationAlertController.addAction(blockUserAction)
            confirmationAlertController.addAction(cancelAction)
            self.present(confirmationAlertController, animated: true, completion: nil)
        }
        actionSheetAlertController.addAction(blockUserAction)
        self.present(actionSheetAlertController, animated: true, completion: nil)
    }
}







