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
    var fullName: String
    var profilePicture: Data?
    var bio: String
    var homeTown: String
    var interests: [String]
    var websiteURL: String
    var isArtist: Bool
    //    var eventsCreated: [Event] = []
    //    var eventsParticipatedIn: [Event] = []
    
    // Not MVP - use this when "participated in" feature added
//    var eventsParticipatedInRefs: [CKReference] = []
    
    
    var cloudKitRecordID: CKRecordID?
    let appleUserRef: CKReference
    var blockedUsersRefs: [CKReference] = []
    
    fileprivate var temporaryPhotoURL: URL {
        
        // Must write to temporary directory to be able to pass image file path url to CKAsset
        
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        
        try? profilePicture?.write(to: fileURL, options: [.atomic])
        
        return fileURL
    }
    
    init(username: String, fullName: String, profilePicture: Data?, bio: String, homeTown: String, interests: [String], websiteURL: String, isArtist: Bool, appleUserRef: CKReference) {
        
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
            let profilePicture = ckRecord["profilePicture"] as? CKAsset,
            let bio = ckRecord["bio"] as? String,
            let homeTown = ckRecord["homeTown"] as? String,
            let interests = ckRecord["interests"] as? [String],
            let websiteURL = ckRecord["websiteURL"] as? String,
            let isArtist = ckRecord["isArtist"] as? Bool,
            let appleUserRef = ckRecord["appleUserRef"] as? CKReference
//            let ownedEventReferences = ckRecord["ownedEventReferences"] as? [CKReference]
            else { return nil }
        
        let photoData = try? Data(contentsOf: profilePicture.fileURL)
        let blockedUsersRefs = ckRecord["blockedUsersRefs"] as? [CKReference] ?? []
    
        self.username = username
        self.fullName = fullName
        self.profilePicture = photoData
        self.bio = bio
        self.homeTown = homeTown
        self.interests = interests
        self.websiteURL = websiteURL
        self.isArtist = isArtist
        self.appleUserRef = appleUserRef
        self.cloudKitRecordID = ckRecord.recordID
        self.blockedUsersRefs = blockedUsersRefs
        // Set the ownedEventReferences array
//        self.ownedEventReferences = ownedEventReferences
    }
    
}

// Turn the User model object into a CKRecord before giving it to Apple's servers
extension CKRecord {
    
    convenience init(user: User) {
        
        let recordID = user.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        let profilePictureAsset = CKAsset(fileURL: user.temporaryPhotoURL)
        
        self.init(recordType: "User", recordID: recordID)
        
        self.setValue(user.username, forKey: "username")
        self.setValue(user.fullName, forKey: "fullName")
        self.setValue(profilePictureAsset, forKey: "profilePicture")
        self.setValue(user.bio, forKey: "bio")
        self.setValue(user.homeTown, forKey: "homeTown")
        self.setValue(user.interests, forKey: "interests")
        self.setValue(user.websiteURL, forKey: "websiteURL")
        self.setValue(user.isArtist, forKey: "isArtist")
        self.setValue(user.appleUserRef, forKey: "appleUserRef")
        self.setValue(user.blockedUsersRefs, forKey: "blockedUsersRefs")
        
    }
    
}
