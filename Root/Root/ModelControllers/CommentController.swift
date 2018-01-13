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
    
    func createNewCommentWith(text: String, event: Event) {

        guard let eventCKRecordID = event.ckRecordID else { return }

        let eventID = CKReference(recordID: eventCKRecordID, action: .deleteSelf)
        
        let newComment = Comment(text: text, creatorID: event.creatorID, eventID: eventID)
        
        save(comment: newComment) { (success) in
           
        }
    
    }
    
    func fetchCommentsForCurrent(event: Event, comment: Comment) {
        
    
        let predicate = NSPredicate(format: "eventID == %@", comment.eventID )
        
        let query = CKQuery(recordType: "Comment", predicate: predicate)
        
        publicDataBase.perform(query, inZoneWith: nil) { (records, error) in
            
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
