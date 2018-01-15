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
    @IBOutlet weak var typeOfArtImageView: UIImageView!
    @IBOutlet weak var typeOfArtLabel: UILabel!
    @IBOutlet weak var eventPictureImageView: UIImageView!
    
    weak var delegate: EventTableViewCellDelegate?
    
    

}
