//
//  UserController.swift
//  Root
//
//  Created by Jayden Garrick on 1/9/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    static let shared = UserController()
    
    var loggedInUser: User?
    
    func createUserWith(username: String, fullName: String, profilePicture: Data, bio: String, homeTown: String, interests: [String], websiteURL: String, isArtist: Bool, completion: @escaping (Bool) -> Void) {
        
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            if let error = error {
                print("There was an error fetching current user record ID. Error: \(error)")
                completion(false) ; return
            }
            guard let appleUserRecordID = appleUserRecordID else { completion(false) ; return }
            
            let refToAppleUser = CKReference(recordID: appleUserRecordID, action: .deleteSelf)
            
            let user = User(username: username, fullName: fullName, profilePicture: profilePicture, bio: bio, homeTown: homeTown, interests: interests, websiteURL: websiteURL, isArtist: isArtist, appleUserRef: refToAppleUser)
            
            let record = CKRecord(user: user)
            
            self.modifyRecords([record], perRecordCompletion: nil, completion: { (records, error) in
                if let error = error {
                    print("There was an error saving the current record. \(error)")
                    completion(false) ; return
                }
                // apple gives us the record right back so that we can use it/access the metadata that now exists
                guard let records = records,
                    let record = records.first,
                    let user = User(ckRecord: record)
                    else { completion(false) ; return }
                self.loggedInUser = user
                completion(true)
            })
            
        }
    }
    
    func modifyRecords(_ records: [CKRecord], perRecordCompletion: ((_ record: CKRecord?, _ error: Error?) -> Void)?, completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)?) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        
        operation.perRecordCompletionBlock = perRecordCompletion
        
        operation.modifyRecordsCompletionBlock = { (records, recordIDs, error) -> Void in
            (completion?(records, error))!
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
        
    }
    
    func fetchCurrentUser(completion: @escaping(Bool) -> Void) {
        
        // Fetch the apple user record ID tied to the user's iCloud account
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            
            if let error = error {
                print("There was an error fetching current user record ID. Error: \(error)")
                completion(false) ; return
            }
            
            guard let appleUserRecordID = appleUserRecordID else { completion(false) ; return }
            
            let predicate = NSPredicate(format: "appleUserRef == %@", appleUserRecordID)
            
            let query = CKQuery(recordType: "User", predicate: predicate)
            
            CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                if let error = error {
                    print("There was an error fetching current user record ID. Error: \(error)")
                    completion(false) ; return
                }
                
                guard let currentUserRecord = records?.first,
                    let user = User(ckRecord: currentUserRecord)
                    else { completion(false) ; return }
                self.loggedInUser = user
                completion(true)
            })
        }
    }
    
    // FIXME: UPDATE USER
    
}
