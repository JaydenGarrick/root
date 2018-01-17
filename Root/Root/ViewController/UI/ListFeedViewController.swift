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
        
       
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        
        // Delegate / DataSource
        tableView.dataSource = self
        tableView.delegate = self
        locationManager.delegate = self
        
        
   
    }
    
    // MARK - IBActions
    
    @IBAction func feedToggled(_ sender: UISegmentedControl) {
//        if sender.selectedSegmentIndex == 1 {
//            var interestArray: [Event] = []
//            for event in EventController.shared.fetchedEvents {
//                if event.typeOfEvent == UserController.shared.loggedInUser?.interests
//            }
//        }
    }
    
  
    
 
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventDetailIdentifier" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let destinationVC = segue.destination as! EventDetailTableViewController
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
        return 111
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventController.shared.fetchedEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventFeedCell", for: indexPath) as! EventTableViewCell
        cell.delegate = self
        let event = EventController.shared.fetchedEvents[indexPath.row]
        let eventImage = UIImage(data: event.eventImage!)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .full
        
        cell.eventPictureImageView.image = eventImage
        cell.dateEventLabel.text = dateFormatter.string(from: event.dateAndTime)
        cell.typeOfArtLabel.text = event.typeOfEvent
        cell.artistNameLabel.text = event.name
        cell.typeOfArtImageView.image = UIImage(named: event.typeOfEvent)
        return cell
    }
}



