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

class Event: NSObject, MKAnnotation {
    var name: String
    var eventImage: Data
    var dateAndTime: Date
    var eventDescription: String
    var venue: String
    var artists: [User] = []
    var comments: [Comment] = []
    
    
    // CloudKit
    let creatorID: CKReference
    var ckRecordID: CKRecordID?
    
    // Mapkit
    var coordinate: CLLocationCoordinate2D
    var title: String? {
        return name
    }
    var subtitle: String? {
        return venue
    }
    
    init(name: String, eventImage: Data, dateAndTime: Date, description: String, venue: String, creatorID: CKReference, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.eventImage = eventImage
        self.dateAndTime = dateAndTime
        self.eventDescription = description
        self.venue = venue
        self.creatorID = creatorID
        self.coordinate = coordinate
    }
    
    // CloudKit
    // Turn the CKRecord from Apple's servers into an Event object
    init?(ckRecord: CKRecord) {
        
        guard let name = ckRecord["name"] as? String,
            let eventImage = ckRecord["eventImage"] as? Data,
            let dateAndTime = ckRecord["dateAndTime"] as? Date,
            let description = ckRecord["eventDescription"] as? String,
            let venue = ckRecord["venue"] as? String,
            let creatorID = ckRecord["creatorID"] as? CKReference,
            // FIXME: - Change CKRecord for saving
            let latitude = ckRecord["latitude"] as? Double,
            let longitude = ckRecord["longitude"] as? Double else { return nil }
        
        self.name = name
        self.eventImage = eventImage
        self.dateAndTime = dateAndTime
        self.eventDescription = description
        self.venue = venue
        self.creatorID = creatorID
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
    }
    
}



// Turn Event model object into CKRecord before being sent to Apple's servers
extension CKRecord {
    
    convenience init(event: Event) {
        
        let recordID = event.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: "Event", recordID: recordID)
        
        // FIXME : - Change CKRecord for saving
        self.setValue(event.name, forKey: "name")
        self.setValue(event.eventImage, forKey: "eventImage")
        self.setValue(event.dateAndTime, forKey: "dateAndTime")
        self.setValue(event.eventDescription, forKey: "eventDescription")
        self.setValue(event.venue, forKey: "venue")
        self.setValue(event.creatorID, forKey: "creatorID")
        self.setValue(event.coordinate.latitude, forKey: "latitude")
        self.setValue(event.coordinate.longitude, forKey: "longitude")
        
    }
    
}


