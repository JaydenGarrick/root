//
//  Event.swift
//  Root
//
//  Created by Jayden Garrick on 1/9/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation
import CloudKit
import MapKit

class Event: NSObject {
    var name: String
    var eventImage: Data
    var dateAndTime: Date
    var eventDescription: String
    var venue: String
    var artists: [User] = []
    var comments: [Comment] = []
    let creatorID: CKReference
    
    var ckRecordID: CKRecordID?
    
    init(name: String, eventImage: Data, dateAndTime: Date, description: String, venue: String, creatorID: CKReference) {
        self.name = name
        self.eventImage = eventImage
        self.dateAndTime = dateAndTime
        self.eventDescription = description
        self.venue = venue
        self.creatorID = creatorID
    }
    
    // CloudKit
    // Turn the CKRecord from Apple's servers into an Event object
    init?(ckRecord: CKRecord) {
        
        guard let name = ckRecord["name"] as? String,
            let eventImage = ckRecord["eventImage"] as? Data,
            let dateAndTime = ckRecord["dateAndTime"] as? Date,
            let description = ckRecord["description"] as? String,
            let venue = ckRecord["venue"] as? String,
            let creatorID = ckRecord["creatorID"] as? CKReference
            else { return nil }
        
        self.name = name
        self.eventImage = eventImage
        self.dateAndTime = dateAndTime
        self.eventDescription = description
        self.venue = venue
        self.creatorID = creatorID
        
    }
    
}

// Mapkit Annotation Protcol
extension Event: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        let geocoder = CLGeocoder()
        var returnedCoordinate = CLLocationCoordinate2D()
        geocoder.geocodeAddressString(venue) { (placemarks, error) in
            if let error = error {
                print("Geocoder error from venue name: \(error.localizedDescription)")
            }
            let placemark = placemarks?.first
            guard let coordinate = placemark?.location?.coordinate else { return }
            returnedCoordinate = coordinate
        }
        return returnedCoordinate
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return venue
    }
}

// Turn Event model object into CKRecord before being sent to Apple's servers
extension CKRecord {
    
    convenience init(event: Event) {
        
        let recordID = event.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: "Event", recordID: recordID)
        
        self.setValue(event.name, forKey: "name")
        self.setValue(event.eventImage, forKey: "eventImage")
        self.setValue(event.dateAndTime, forKey: "dateAndTime")
        self.setValue(event.eventDescription, forKey: "description")
        self.setValue(event.venue, forKey: "venue")
        self.setValue(event.creatorID, forKey: "creatorID")
        
    }
    
}
