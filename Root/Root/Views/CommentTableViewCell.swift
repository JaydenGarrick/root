//
//  CommentTableViewCell.swift
//  Root
//
//  Created by Frank Martin Jr on 1/17/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    //    var commentCreator: User?
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            CommentController.shared.fetchCommentCreator(comment: comment) { (user) in
                guard let user = user else { return }
                DispatchQueue.main.async {
                    self.updateViews(user)
                }
            }
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var commentCreatorProfileImageView: UIImageView!
    @IBOutlet weak var commentTextLabel: UILabel!
    
    func updateViews(_ commentCreator: User) {
        guard let commentCreatorProfilePictureAsData = commentCreator.profilePicture,
            let comment = comment else { return }
        
        
        let commentProfilePicture = UIImage(data: commentCreatorProfilePictureAsData)
        commentCreatorProfileImageView.image = commentProfilePicture
        commentTextLabel.text = comment.text
        
        
    }
}




