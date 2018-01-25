//
//  FetchItemsViewController.swift
//  Root
//
//  Created by Jayden Garrick on 1/16/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import MapKit

class FetchItemsViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var usersLocation = CLLocationCoordinate2D()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Core Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        getLocation()
        performFetches()
   
    }
    
    // Gets the users current location
    func getLocation() {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let coordinate = locations.last?.coordinate else { return }
            usersLocation = coordinate
        }
    }
    
    
    // Performs fetches
    func performFetches() {
        
        UserController.shared.fetchCurrentUser { (success) in
           
            if !success {
                DispatchQueue.main.async {
                    
                    let createAccountStoryboard = UIStoryboard(name: "CreateAccount", bundle: nil)
                    let welcomeViewController = createAccountStoryboard.instantiateViewController(withIdentifier: "createAccountNavController")
                    self.present(welcomeViewController, animated: true, completion: nil)
                    print("Couldn't get current user")
                    
                }
            } else {
                
                EventController.shared.fetchEvents(usersLocation: self.usersLocation, completion: { (success) in
                    if success {
                        // Current date plus 24 hours
                        let dateToCheckFromAsDouble = Date().timeIntervalSince1970 + 86400.0 // 86400 represents 24 hours
                        let dateToCheckFrom = Date(timeIntervalSince1970: dateToCheckFromAsDouble)
                        for event in EventController.shared.fetchedEvents {
                            if event.dateAndTime < dateToCheckFrom && event.dateAndTime > Date()  {
                                EventController.shared.eventHappeningWithinTwentyFour.append(event)
                            }
                        }
                            self.performSegue(withIdentifier: "LaunchSegue", sender: self)
                            if UserController.shared.loggedInUser?.isArtist == false {
                                self.navigationController?.navigationBar.isHidden = true
                            }
                        print("Success fetching events within 50 miles! :)")
                    } else {
                        print("Failure fetching events within 50 miles. :(")
                    }
                })
                print("\(String(describing: UserController.shared.loggedInUser?.cloudKitRecordID)) \(String(describing: UserController.shared.loggedInUser?.fullName)), \(String(describing: UserController.shared.loggedInUser?.appleUserRef))")
            }
        }
    }

   

}
