//
//  CommentTableViewCell.swift
//  Root
//
//  Created by Frank Martin Jr on 1/17/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    var user: User?
    var comment: Comment? {
        didSet {
            updateViews()
            
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var commentTextLabel: UILabel!
    
    func updateViews() {
        guard let comment = comment else { print("wrong comment"); return }
        commentTextLabel.text = comment.text
    }
}




