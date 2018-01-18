//
//  CommentController.swift
//  Root
//
//  Created by Jayden Garrick on 1/9/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation
import CloudKit

class CommentController {
    
    // CloudKit
    let publicDataBase = CKContainer.default().publicCloudDatabase
    
    static var shared = CommentController()
    var eventComments: [Comment] = []
    
    func createNewCommentWith(text: String, event: Event) {

        guard let eventCKRecordID = event.ckRecordID else { return }
        
        let eventCreatorID = CKReference(recordID: event.creatorID.recordID, action: .deleteSelf)
        let eventID = CKReference(recordID: eventCKRecordID, action: .deleteSelf)
        
        let newComment = Comment(text: text, creatorID: eventCreatorID, eventID: eventID)
        
        save(comment: newComment) { (success) in
           
        }
    
    }
    
    func fetchCommentsForCurrent(event: Event, completion: @escaping ([Comment]?) -> Void) {
        guard let eventCKRecordID = event.ckRecordID else { return }
    
        let predicate = NSPredicate(format: "eventID == %@", eventCKRecordID)
        
        let query = CKQuery(recordType: "Comment", predicate: predicate)
        
        publicDataBase.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records else { return }
            
            var eventComments: [Comment] = []
            
            for record in records {
                guard let comment = Comment(ckRecord: record) else { completion([]) ; return }
                eventComments.append(comment)
                
            }
//            self.eventComments = eventComments
            completion(eventComments)
        }
        
    }
    
    func save(comment: Comment, completion: @escaping ((Bool)->Void)) {
        let record = CKRecord(comment: comment)
        
        publicDataBase.save(record) { (_, error) in
            if let error = error {
                print("Error saving comment: \(error.localizedDescription)")
                completion(false)
            } else {
                 print("Comment successfully saved!")
                completion(true)
            }
        }
    }
    
}
