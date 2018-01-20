//
//  EventTableViewCell.swift
//  Root
//
//  Created by Edmund Bollenbacher on 1/9/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

protocol EventTableViewCellDelegate : class {
    func printStatus()
}

class EventTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var dateEventLabel: UILabel!
    //@IBOutlet weak var typeOfArtImageView: UIImageView!
    @IBOutlet weak var typeOfArtLabel: UILabel!
    @IBOutlet weak var eventPictureImageView: UIImageView!
    @IBOutlet weak var backgroundShadowView: UIView!
    
    weak var delegate: EventTableViewCellDelegate?
    
    override func awakeFromNib() {
        // backgroundShadowView.backgroundColor = .whi
        // contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        backgroundShadowView.layer.cornerRadius = 3.0
        backgroundShadowView.layer.masksToBounds = false
        backgroundShadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        backgroundShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundShadowView.layer.shadowOpacity = 0.8
        
    }

}
