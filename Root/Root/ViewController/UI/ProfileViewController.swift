//
//  ProfileViewController.swift
//  Root
//
//  Created by Jayden Garrick on 1/18/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    // MARK: - Properties
    var user: User?
    
    // MARK: - IBOutlets
    @IBOutlet weak var userProfilePictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - View Will Appear / Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        // Handle NavBar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        // Set User with outlets
        guard let user = UserController.shared.loggedInUser,
            let data = user.profilePicture else { return }
        
        self.user = user
        
        let image = UIImage(data: data)
        let username = user.username
        let websiteURLAsString = user.websiteURL
        
        userProfilePictureImageView.image = image
        usernameLabel.text = username
        fullNameLabel.text = user.fullName
        bioLabel.text = user.bio
        urlButton.setTitle(websiteURLAsString, for: .normal)
        
        UserController.shared.fetchEventsFor(user: user) { (success) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let user = UserController.shared.loggedInUser,
            let data = user.profilePicture else { return }
        
        self.user = user
        
        let image = UIImage(data: data)
        let username = user.username
        let websiteURLAsString = user.websiteURL
        
        userProfilePictureImageView.image = image
        usernameLabel.text = username
        fullNameLabel.text = user.fullName
        bioLabel.text = user.bio
        urlButton.setTitle(websiteURLAsString, for: .normal)
        print(user.username, user.bio)
        
        
    }
    
    @IBAction func editProfileButtonTapped(_ sender: Any) {
        self.editButtonTappedAlert()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WebViewID" {
            if let destinationVC = segue.destination as? WebViewController {
                let websiteURLAsString = urlButton.titleLabel!.text!
                destinationVC.websiteURLAsString = websiteURLAsString
            }
        }
        
        if segue.identifier == "ToEventDetailSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let eventsCreated = UserController.shared.eventsCreated
                else { return }
            let destinationVC = segue.destination as! EventDetailViewController
            let event = eventsCreated[indexPath.row]
            destinationVC.event = event
        }
    }
    
}


// MARK: - TableViewDataSource Functions
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return # of comments
        guard let eventsCreated = UserController.shared.eventsCreated else { return 0 }
        return eventsCreated.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventFeedCell", for: indexPath) as! EventTableViewCell
        // configure cell with custom cell
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
}





