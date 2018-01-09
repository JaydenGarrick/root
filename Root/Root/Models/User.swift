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
    let email: String
    let password: String
    let name: String
    var profilePicture: Data
    var bio: String?
    var baseCity: CLLocation
    var interests: [String]
    var websiteURL: String?
    var events: [Event]?
    var isArtist: Bool
    
    var cloudKitRecordID: CKRecordID?
    let appleUserRef: CKReference
    
    init(username: String, email: String, password: String, name: String, profilePicture: Data, bio: String?, baseCity: CLLocation, interests: [String], websiteURL: String?, events: [Events]?, isArtist: Bool, appleUserRef: CKReference) {
        self.username = username
        self.email = email
        self.password = password
        self.name = name
        self.profilePicture = profilePicture
        self.bio = bio
        self.baseCity = baseCity
        self.interests = interests
        self.websiteURL = websiteURL
        self.events = events
        self.isArtist = isArtist
        self.appleUserRef = appleUserRef
    }
    
    // Turn the CKRecord that we receive from the server to a User object.
    init?(ckRecord: CKRecord) {
        guard let username = ckRecord["username"] as? String,
        let email = ckRecord["email"] as? String,
            let password = ckRecord["password"] as? String,
        let profilePicture = ckRecord["profilePicture"] as? Data?,
            let bio = ckRecord["bio"] as? String?,
        let baseCity = ckRecord["baseCity"] as? CLLocation,
            let interests = ckRecord["interests"] as? [String],
        let websiteURL = ckRecord["websiteURL"] as? String?,
        let events = ckRecord["events"] as? [Event]?,
        let isArtist = ckRecord["isArtist"] as? Bool,
            let appleUserRef = ckRecord["appleUserRef"] as? CKReference
            else { return nil }
        
        self.username = username
        self.email = email
        self.password = password
        self.profilePicture = profilePicture
        self.bio = bio
        self.baseCity = baseCity
        self.interests = interests
        self.websiteURL = websiteURL
        self.events = events
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
        self.setValue(user.email, forKey: "email")
        self.setValue(user.password, forKey: "password")
        self.setValue(user.name, forKey: "name")
        self.setValue(user.profilePicture, forKey: "profilePicture")
        self.setValue(user.bio, forKey: "bio")
        self.setValue(user.baseCity, forKey: "baseCity")
        self.setValue(user.interests, forKey: "interests")
        self.setValue(user.websiteURL, forKey: "websiteURL")
        self.setValue(user.events, forKey: "events")
        self.setValue(user.isArtist, forKey: "isArtist")
        self.setValue(user.appleUserRef, forKey: "appleUserRef")
    }
}
