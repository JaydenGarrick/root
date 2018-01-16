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

    
    // CoreLocation
    let locationManager = CLLocationManager()
    var usersLocation = CLLocationCoordinate2D()
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
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
        
        performFetches()
   
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
        //cell.artistNameLabel.text = event.artists[0].username
        cell.artistNameLabel.text = "Fix me"
        //cell.eventPictureImageView.image = UIImage(named: event.typeOfEvent)
        return cell
    }
}


// MARK: - Corelocation And Fetch - getting users location
extension ListFeedViewController {
    func getUserLocation() {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let coordinate = locations.last?.coordinate else { return }
            usersLocation = coordinate
        }
    }
    
    func performFetches() {
        UserController.shared.fetchCurrentUser { (success) in
            if !success {
                DispatchQueue.main.async {
                    
                    let createAccountStoryboard = UIStoryboard(name: "CreateAccount", bundle: nil)
                    let welcomeViewController = createAccountStoryboard.instantiateViewController(withIdentifier: "createAccountNavController")
                    self.present(welcomeViewController, animated: true, completion: nil)
                    
                }
            } else {
                
                // CoreLocation
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.startUpdatingLocation()
                self.getUserLocation()
                EventController.shared.fetchEvents(usersLocation: self.usersLocation, completion: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        print("Success! :)")
                    } else {
                        print("Failure :(")
                    }
                })
                print("\(String(describing: UserController.shared.loggedInUser?.cloudKitRecordID)) \(String(describing: UserController.shared.loggedInUser?.fullName)), \(String(describing: UserController.shared.loggedInUser?.appleUserRef))")
            }
        }
    }
}
