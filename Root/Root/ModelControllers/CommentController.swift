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
    var commentCreators: [User] = []
    
    func createNewCommentWith(text: String, event: Event, loggedInUser: User) {
        
        guard let eventCKRecordID = event.ckRecordID,
            let userCKRecordID = loggedInUser.cloudKitRecordID else { return }
        let creatorID = CKReference(recordID: userCKRecordID, action: .deleteSelf)
        let eventID = CKReference(recordID: eventCKRecordID, action: .deleteSelf)
        
        let newComment = Comment(text: text, creatorID: creatorID, eventID: eventID)
        
        save(comment: newComment) { (success) in
            
        }
        
    }
    
    func fetchCommentsForCurrent(event: Event, completion: @escaping (Bool?) -> Void) {
        guard let eventCKRecordID = event.ckRecordID else { return }
        
        let predicate = NSPredicate(format: "eventID == %@", eventCKRecordID)
        
        let query = CKQuery(recordType: "Comment", predicate: predicate)
        
        publicDataBase.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records else { return }
            
            let eventComments = records.flatMap { Comment(ckRecord: $0) }
            
//            var eventComments = [Comment]()
//            for record in records {
//                guard let comment = Comment(ckRecord: record) else { return }
//                eventComments.append(comment)
//            }
            
            //            var commentCreators: [User] = []
            //            for record in records {
            //                guard let comment = Comment(ckRecord: record) else { completion(false) ; return }
            //                CommentController.shared.fetchCommentCreator(comment: comment, completion: { (commentCreator) in
            //                    guard let commentCreator = commentCreator else { completion(false) ; return }
            //                    commentCreators.append(commentCreator)
            //                })
            //                eventComments.append(comment)
            //
            //            }
            //            self.commentCreators = commentCreators
            self.eventComments = eventComments
            completion(true)
        }
        
    }
    
    
    func fetchCommentCreator(comment: Comment, completion: @escaping (User?) -> Void) {
        let commentCKRecordID = comment.creatorID
        let predicate = NSPredicate(format: "recordID == %@", commentCKRecordID)
        let query = CKQuery(recordType: "User", predicate: predicate)
        publicDataBase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("There was an error fetching the comment creator: \(error)")
                completion(nil)
                return
                
            }
            guard let records = records else { return }
            let firstCommentCreatorRecord = records[0]
            guard let commentCreator = User(ckRecord: firstCommentCreatorRecord) else { completion(nil) ; return }
            completion(commentCreator)
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


