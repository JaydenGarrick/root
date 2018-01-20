//
//  ListFeedViewController.swift
//  Root
//
//  Created by Frank Martin Jr on 1/11/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import MapKit

class ListFeedViewController: UIViewController, CLLocationManagerDelegate  {

    
    // MARK: - Constants and Variables
    var interestArray: [Event] = []
    var localFeed: Bool = true
    
    // CoreLocation
    let locationManager = CLLocationManager()
    var usersLocation = CLLocationCoordinate2D()
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createEventButton: UIBarButtonItem!
    
    // MARK: - ViewDidLoad / ViewWillAppear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setImageOnNavBar()
        
        
       
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        //self.navigationController?.isToolbarHidden = false
        
        
        // Delegate / DataSource
        tableView.dataSource = self
        tableView.delegate = self
        locationManager.delegate = self
        
    }
    
    
    // MARK: - IBActions
    
    @IBAction func feedToggled(_ sender: UISegmentedControl) {
       
        interestArray = []
        if sender.selectedSegmentIndex == 1 {
            localFeed = false
            for event in EventController.shared.fetchedEvents {
                for interest in (UserController.shared.loggedInUser?.interests)! {
                    if event.typeOfEvent.trimmingCharacters(in: .whitespaces) == interest {
                        if interestArray.isEmpty {
                            interestArray.append(event)
                        } else {
                            for interestEvent in interestArray {
                                if event == interestEvent {
                                    // Need to return if one matches, and if none matches, append
                                    return
                                } else {
                                    continue
                                }
                            }
                            interestArray.append(event)
                        }
                        print("\(interestArray.count) is the total number of items in the interest array")
                    }
                    tableView.reloadData()
                }
            }
        } else {
            localFeed = true
            tableView.reloadData()
        }
    }
    
  
    
 
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventDetailIdentifier" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let destinationVC = segue.destination as! EventDetailViewController
            let event = EventController.shared.fetchedEvents[indexPath.row]
            destinationVC.event = event

        }
        
    }

}

// MARK: TableView Delegate and DateSource Functions
extension ListFeedViewController: UITableViewDelegate, UITableViewDataSource, EventTableViewCellDelegate {
    func printStatus() {
        print(EventController.shared.fetchedEvents.count)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 127
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if localFeed == true {
            return EventController.shared.fetchedEvents.count
        } else {
            return interestArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventFeedCell", for: indexPath) as! EventTableViewCell
        cell.delegate = self
        if localFeed == true {
            let event = EventController.shared.fetchedEvents[indexPath.row]
            let eventImage = UIImage(data: event.eventImage!)
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = .full
            
            cell.eventPictureImageView.image = eventImage
            cell.dateEventLabel.text = dateFormatter.string(from: event.dateAndTime)
            cell.typeOfArtLabel.text = event.typeOfEvent
            cell.artistNameLabel.text = event.name
            //cell.typeOfArtImageView.image = UIImage(named: event.typeOfEvent)
        } else {
            let event = interestArray[indexPath.row]
            let eventImage = UIImage(data: event.eventImage!)
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = .full
            
            cell.eventPictureImageView.image = eventImage
            cell.dateEventLabel.text = "\(event.venue) \(dateFormatter.string(from: event.dateAndTime))"
            cell.typeOfArtLabel.text = event.typeOfEvent
            cell.artistNameLabel.text = event.name
            //cell.typeOfArtImageView.image = UIImage(named: event.typeOfEvent)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Set initial state
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -5, 10, 0)
        cell.layer.transform = transform
        // UIView animation method to change to the final state of the cell
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
        
        
    }
    
    
}

// Sets Image of NavBar
extension ListFeedViewController {
    func setImageOnNavBar() {
        
        let navController = navigationController!
        
        let image = #imageLiteral(resourceName: "NavigationBarImage")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - image.size.width / 2
        let bannerY = bannerHeight / 2 - image.size.height / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
        
    }
}




