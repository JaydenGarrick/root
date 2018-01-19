//
//  CommentTableViewTableViewCell.swift
//  Root
//
//  Created by Frank Martin Jr on 1/18/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class CommentTableViewTableViewCell: UITableViewCell, UITableViewDataSource {
    
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommentController.shared.eventComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        
        let comment = CommentController.shared.eventComments[indexPath.row]
        
        cell.comment = comment
        
        return cell
    }
}
