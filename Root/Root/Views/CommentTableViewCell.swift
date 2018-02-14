//
//  CommentTableViewCell.swift
//  Root
//
//  Created by Frank Martin Jr on 1/17/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
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
    @IBOutlet weak var commentCreatorProfileImageView: UIImageViewX!
    @IBOutlet weak var commentTextLabel: UILabel!
    @IBOutlet weak var backgroundShadowView: UIView!
    
    func updateViews(_ commentCreator: User) {
        guard let commentCreatorProfilePictureAsData = commentCreator.profilePicture,
            let comment = comment else { return }
        let commentProfilePicture = UIImage(data: commentCreatorProfilePictureAsData)
        commentCreatorProfileImageView.image = commentProfilePicture
        commentTextLabel.text = comment.text
    }
    
    override func awakeFromNib() {
        backgroundShadowView.layer.cornerRadius = 3.0
        backgroundShadowView.layer.masksToBounds = false
        backgroundShadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        backgroundShadowView.layer.shadowOffset = CGSize(width: 0, height: -1)
        backgroundShadowView.layer.shadowOpacity = 0.2
    }

}




