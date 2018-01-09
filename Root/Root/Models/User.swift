//
//  User.swift
//  Root
//
//  Created by Jayden Garrick on 1/9/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import MapKit
import CloudKit

class User {
    
    let username: String
    let fullName: String
    var profilePicture: Data
    var bio: String
    var homeTown: String
    var interests: [String]
    var websiteURL: String
    var eventsCreated: [Event] = []
    var eventsParticipatedIn: [Event] = []
    var isArtist: Bool
    
    var cloudKitRecordID: CKRecordID?
    let appleUserRef: CKReference
    
    init(username: String, fullName: String, profilePicture: Data, bio: String = "", homeTown: String, interests: [String], websiteURL: String = "", isArtist: Bool, appleUserRef: CKReference) {
        
        self.username = username
        self.fullName = fullName
        self.profilePicture = profilePicture
        self.bio = bio
        self.homeTown = homeTown
        self.interests = interests
        self.websiteURL = websiteURL
        self.isArtist = isArtist
        self.appleUserRef = appleUserRef
        
    }
    
    // CloudKit
    // Turn the CKRecord that we receive from the server to a User object.
    init?(ckRecord: CKRecord) {
        
        guard let username = ckRecord["username"] as? String,
            let fullName = ckRecord["fullName"] as? String,
            let profilePicture = ckRecord["profilePicture"] as? Data,
            let bio = ckRecord["bio"] as? String,
            let homeTown = ckRecord["homeTown"] as? String,
            let interests = ckRecord["interests"] as? [String],
            let websiteURL = ckRecord["websiteURL"] as? String,
            let isArtist = ckRecord["isArtist"] as? Bool,
            let appleUserRef = ckRecord["appleUserRef"] as? CKReference
            else { return nil }
        
        self.username = username
        self.fullName = fullName
        self.profilePicture = profilePicture
        self.bio = bio
        self.homeTown = homeTown
        self.interests = interests
        self.websiteURL = websiteURL
        self.isArtist = isArtist
        self.appleUserRef = appleUserRef
        
    }
    
}

// Turn the User model object into a CKRecrod before giving it to Apple's servers
extension CKRecord {
    
    convenience init(user: User) {
        
        let recordID = user.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: "User", recordID: recordID)
        
        self.setValue(user.username, forKey: "username")
        self.setValue(user.fullName, forKey: "fullName")
        self.setValue(user.profilePicture, forKey: "profilePicture")
        self.setValue(user.bio, forKey: "bio")
        self.setValue(user.homeTown, forKey: "homeTown")
        self.setValue(user.interests, forKey: "interests")
        self.setValue(user.websiteURL, forKey: "websiteURL")
        self.setValue(user.isArtist, forKey: "isArtist")
        self.setValue(user.appleUserRef, forKey: "appleUserRef")
        
    }
    
}
