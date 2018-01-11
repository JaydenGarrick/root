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
    
    static let shared = EventController()
    
    var createdEvent: Event?
    
    func createEventWith(name: String, eventImage: Data, dataAndTime: Date, description: String, venue: String, artist: [User], completion: @escaping (Bool) -> Void) {
        
        CKContainer.default().fetchUserRecordID { (creatorRecordID, error) in
            if let error = error {
                print("Error fetching current recordID while creating event. Error : \(error.localizedDescription)")
                completion(false) ;  return }
                
                guard let creatorRecordID = creatorRecordID else { completion(false) ; return }
                
                let refToCreatorID = CKReference(recordID: creatorRecordID, action: .deleteSelf)
            
            // FIXME: - Event model changed, will have to update VVVVVV
            
            let geocoder = CLGeocoder()
            var coordinate: CLLocationCoordinate2D?
            geocoder.geocodeAddressString(venue, completionHandler: { (placemarks, error) in
                if let error = error {
                    print("Error geocoding while creating event: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                guard let placemarks = placemarks else { completion(false) ; return }
                guard let tempCoordinate = placemarks.first?.location?.coordinate else { completion(false) ; return }
                coordinate = tempCoordinate
            })
            guard let newCoordinate = coordinate else { completion(false) ; return }
            let event = Event(name: name, eventImage: eventImage, dateAndTime: dataAndTime, description: description, venue: venue, creatorID: refToCreatorID, coordinate: newCoordinate)
                
                let eventRecord = CKRecord(event: event)
                
                CKContainer.default().publicCloudDatabase.save(eventRecord, completionHandler: { (record, error) in
                    if let error = error {
                        print("Error fetching current event ID while creating event. \(error.localizedDescription)")
                        completion(false) ; return
                    }
                    
                    guard let record = record,
                        let event = Event(ckRecord: record)
                        else { completion(false) ; return }
                    self.createdEvent = event
                    completion(true)
                })
            
        }
        
    }
}
