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
    
    func createUserWith(username: String, fullName: String, profilePicture: Data, homeTown: String, interests: [String], isArtist: Bool, completion: @escaping (Bool) -> Void) {
        
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            if let error = error {
                print("There was an error fetching current user record ID. Error: \(error)")
                completion(false) ; return
            }
            guard let appleUserRecordID = appleUserRecordID else { completion(false) ; return }
            
            let refToAppleUser = CKReference(recordID: appleUserRecordID, action: .deleteSelf)
            
            let user = User(username: username, fullName: fullName, profilePicture: profilePicture, homeTown: homeTown, interests: interests, isArtist: isArtist, appleUserRef: refToAppleUser)
            
            let record = CKRecord(user: user)
            
            CKContainer.default().publicCloudDatabase.save(record, completionHandler: { (record, error) in
                if let error = error {
                    print("There was an error fetching current user record ID. \(error)")
                    completion(false) ; return
                }
                
                guard let record = record,
                    let user = User(ckRecord: record)
                    else { completion(false) ; return }
                // FIXME: set a property on the singleton for loggedInUser?
                completion(true)
            
            })
        }
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
                // FIXME: set a property on the singleton for loggedInUser?
                completion(true)
            })
        }
    }

    
}
