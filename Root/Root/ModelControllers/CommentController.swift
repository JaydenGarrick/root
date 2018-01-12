//
//  CommentController.swift
//  Root
//
//  Created by Jayden Garrick on 1/9/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation

class CommentController {
    
    static var shared = CommentController()
    
    func createNewCommentWith(text: String) {
        guard let user = UserController.shared.loggedInUser else { return }
        let predicate = NSPredicate(format: "appleUserRef == %@", user.appleUserRef)
        
//        let comment = Comment(text: text, creatorID: <#T##CKReference#>, eventID: <#T##CKReference#>)
//        let creatorID = UserController.shared.loggedInUser?.appleUserRef
    }
    
    
}
