//
//  Comment.swift
//  Root
//
//  Created by Jayden Garrick on 1/9/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation
import CloudKit

class Comment {
    let text: String
    var timestamp: Date? = nil
    let creatorID: CKReference
    let eventID: CKReference
    
    var cloudKitRecordID: CKRecordID?
    
    init(text: String, creatorID: CKReference, eventID: CKReference) {
        self.text = text
        self.creatorID = creatorID
        self.eventID = eventID
    }
    
    // CloudKit
    // Turn the CKRecord that we receive from the server to a Comment object.
    init?(ckRecord: CKRecord) {
        
        guard let text = ckRecord["text"] as? String,
            let creatorID = ckRecord["creatorID"] as? CKReference,
            let eventID = ckRecord["eventID"] as? CKReference
            else { return nil }
        
        self.text = text
        self.creatorID = creatorID
        self.eventID = eventID
        self.timestamp = ckRecord.creationDate
        
    }
    
}

// Turn the Comment model object into a CKRecrod before giving it to Apple's servers
extension CKRecord {
    
    convenience init(comment: Comment) {
        let recordID = comment.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: "Comment", recordID: recordID)        
        self.setValue(comment.text, forKey: "text")
        self.setValue(comment.creatorID, forKey: "creatorID")
        self.setValue(comment.eventID, forKey: "eventID")
        
        
    }
    
}

