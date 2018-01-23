//
//  EventController.swift
//  Root
//
//  Created by Jayden Garrick on 1/9/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation
import CloudKit
import MapKit

class EventController {
    
    // MARK: - Properties
    
    // CloudKit
    let publicDataBase = CKContainer.default().publicCloudDatabase
    
    let locationManager = CLLocationManager()
    
    // Shared Instance
    static let shared = EventController()
    
    // Local DataSources
    var fetchedEvents: [Event] = []
    var createdEvent: Event?
    var eventHappeningWithinTwentyFour: [Event] = []
    
    // MARK: - CRUD
    func createEventWith(name: String, eventImage: Data, dataAndTime: Date, description: String, venue: String, artist: [User], typeOfEvent: String, completion: @escaping (Bool) -> Void) {
        
        // Fetch User ID
//        guard let refToCreatorID = UserController.shared.loggedInUser?.appleUserRef else { completion(false) ; return }
        guard let userRecordID = UserController.shared.loggedInUser?.cloudKitRecordID else { completion(false) ; return }
        let refToCreator = CKReference(recordID: userRecordID, action: .none)
        // Geocoding venue into coordinates
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(venue, completionHandler: { (placemarks, error) in
            
            if let error = error {
                print("Error geocoding while creating event: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let placemarks = placemarks else { completion(false) ; return }
            guard let coordinate = placemarks.first?.location?.coordinate else { completion(false) ; return }
            
           
            
            // Initializing event
            let event = Event(name: name, eventImage: eventImage, dateAndTime: dataAndTime, description: description, venue: venue, creatorID: refToCreator, typeOfEvent: typeOfEvent, coordinate: coordinate)
            
            
            // Saving event
            self.save(event: event, completion: { (success) in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        
        
        })
        
    }
    
    
    func fetchEvents(usersLocation: CLLocationCoordinate2D, completion: @escaping ((Bool) -> Void)) {
        // FIXME: - Add a predicate that only fetches events in 50 mile radius
        guard let userLocation = locationManager.location,
            let loggedInUser = UserController.shared.loggedInUser
            else { completion(false); return}
        
        let maxLatitudePredicate = NSPredicate(format: "latitude < %f", userLocation.coordinate.latitude + 0.724)
        let maxLongitudePredicate = NSPredicate(format: "longitude < %f", userLocation.coordinate.longitude + 0.724)
        let minLatitudePredicate = NSPredicate(format: "latitude > %f", userLocation.coordinate.latitude - 0.724)
        let minLongitudePredicate = NSPredicate(format: "longitude > %f", userLocation.coordinate.longitude - 0.724)
        let blockedUsersPredicate = NSPredicate(format: "NOT(creatorID IN %@)", loggedInUser.blockedUsersRefs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [maxLatitudePredicate, maxLongitudePredicate, minLatitudePredicate, minLongitudePredicate, blockedUsersPredicate])
        
        
        let query = CKQuery(recordType: "Event", predicate: compoundPredicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching events: \(error.localizedDescription)")
                completion(false)
            } else {
                guard let records = records else { completion(false) ; return }
                var arrayOfEvents: [Event] = []
                for record in records {
                    guard let event = Event(ckRecord: record) else { completion(false) ; return }
                    arrayOfEvents.append(event)
                }
                self.fetchedEvents = arrayOfEvents
                completion(true)
            }
        }
    }
    
    func save(event: Event, completion: @escaping ((Bool)->Void)) {
        let record = CKRecord(event: event)
        
        publicDataBase.save(record) { (_, error) in
            if let error = error {
                print("Error saving event: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func deleteEvent(event: Event, completion: @escaping ((Bool)->Void)) {
        guard let recordID = event.ckRecordID else { completion(false) ; return }
        
        publicDataBase.delete(withRecordID: recordID) { (_, error) in
            if let error = error {
                completion(false)
                print("Error deleting event from public database: \(error.localizedDescription)")
            } else {
                completion(true)
            }
        }
        
        
    }
}















