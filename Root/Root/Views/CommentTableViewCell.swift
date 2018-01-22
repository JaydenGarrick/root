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
    @IBOutlet weak var backgroundShadowView: CommentTableViewCell!
    
    func updateViews(_ commentCreator: User) {
        guard let commentCreatorProfilePictureAsData = commentCreator.profilePicture,
            let comment = comment else { return }
        
        let commentProfilePicture = UIImage(data: commentCreatorProfilePictureAsData)
        commentCreatorProfileImageView.image = commentProfilePicture
        commentTextLabel.text = comment.text
        
    }
    

    override func awakeFromNib() {

//        // backgroundShadowView.backgroundColor = .whi
//        // contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
//        backgroundShadowView.layer.cornerRadius = 3.0
//        backgroundShadowView.layer.masksToBounds = false
//        backgroundShadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
//        backgroundShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        backgroundShadowView.layer.shadowOpacity = 0.8

        
    }

}




