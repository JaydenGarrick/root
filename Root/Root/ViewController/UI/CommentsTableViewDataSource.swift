//
//  CommentsTableViewDataSource.swift
//  Root
//
//  Created by Frank Martin Jr on 1/17/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class CommentsTableViewDataSource: NSObject, UITableViewDataSource {
 
    var eventComments: [Comment]?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let eventComments = eventComments else { return 0 }
        print("COUNT: \(eventComments.count)")
        
        return eventComments.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as? CommentTableViewCell else { return UITableViewCell() }
        guard let eventComments = eventComments else { return UITableViewCell() }
        let comment = eventComments[indexPath.row]
        cell.comment = comment
        
        return cell
    }
}
