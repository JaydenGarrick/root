//
//  Event.swift
//  Root
//
//  Created by Jayden Garrick on 1/9/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation
import CloudKit

class Event {
    var name: String
    var eventImage: Data
    var dateAndTime: Date
    var description: String
    var venue: String
    var artists: [User] = []
    var comments: [Comment] = []
    let creatorID: CKReference
    
    var ckRecordID: CKRecordID?
    
    init(name: String, eventImage: Data, dateAndTime: Date, description: String, venue: String, creatorID: CKReference) {
        self.name = name
        self.eventImage = eventImage
        self.dateAndTime = dateAndTime
        self.description = description
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
        self.description = description
        self.venue = venue
        self.creatorID = creatorID
        
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
        self.setValue(event.description, forKey: "description")
        self.setValue(event.venue, forKey: "venue")
        self.setValue(event.creatorID, forKey: "creatorID")
        
    }
    
}
