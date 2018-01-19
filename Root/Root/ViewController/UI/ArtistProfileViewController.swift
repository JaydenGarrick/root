//
//  ArtistProfileViewController.swift
//  Root
//
//  Created by Jayden Garrick on 1/18/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class ArtistProfileViewController: UIViewController {

    // MARK: - Properties
    
    var artist: User?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var artistProfilePictureImageView: UIImageView!
    @IBOutlet weak var artistUserNameLabel: UILabel!
    @IBOutlet weak var artistBioLabel: UILabel!
    @IBOutlet weak var artistWebsiteURLButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Did Load / UpdateViews function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update The Views
        updateViews()
        
        // Handle Nav Bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor(named: "Tint")
        
        guard let artist = artist else { return }
        
        UserController.shared.fetchEventsFor(user: artist) { (success) in
            DispatchQueue.main.async {
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

}


// TableView DataSource and Delegate Methods
extension ArtistProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return number of events this artist has created
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SETIDENTIFIER", for: indexPath)
        // Customize cell based on event
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 111
    }
    
}







