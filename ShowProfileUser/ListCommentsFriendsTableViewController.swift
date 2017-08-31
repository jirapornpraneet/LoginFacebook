//
//  ListCommentsFriendsTableViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 8/28/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit

class ListCommentsFriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameFriendsLabel: UILabel!
    @IBOutlet weak var profileFriendImageView: UIImageView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var commentsMessageLabel: UILabel!
    @IBOutlet weak var commentsCountButton: UIButton!
}

class ListCommentsFriendsTableViewController: UITableViewController {
    
    @IBOutlet var tableListCommentsFriends: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableListCommentsFriends.delegate = self
        tableListCommentsFriends.dataSource = self
        self.tableListCommentsFriends.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    var setUserResourcePostsDataCommentsCount = Int()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if setUserResourcePostsDataCommentsCount != 0 {
            return setUserResourcePostsDataCommentsCount
        } else {
            return 0
        }
    }
    
    var setUserResourcePostsDataCommentsData = [NSObject]()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellListCommentsFriends = tableView.dequeueReusableCell(withIdentifier: "cellListCommentsFriends", for: indexPath) as! ListCommentsFriendsTableViewCell
        let cellCommentsData = setUserResourcePostsDataCommentsData[indexPath.row] as! CommentsDataDetail
        cellListCommentsFriends.commentsMessageLabel.text = cellCommentsData.message
        cellListCommentsFriends.nameFriendsLabel.text = cellCommentsData.from?.name
        
        var cellListCommentsDataCount = cellCommentsData.comment_count
        if cellListCommentsDataCount == 0 {
            cellListCommentsFriends.commentsCountButton.setTitle("", for: .normal)
        } else {
            cellListCommentsFriends.commentsCountButton.setTitle(String(format: "%ความคิดเห็น %i %รายการ", cellListCommentsDataCount), for: .normal)
            cellListCommentsFriends.commentsCountButton.tag = indexPath.row
        }

        let myLocale = Locale(identifier: "th_TH")
        let dateStringFormCommentsDataCreatedTime = cellCommentsData.created_time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateStringFormCommentsDataCreatedTime)
        dateFormatter.locale = myLocale
        dateFormatter.dateFormat = "EEEE" + " เวลา " + "hh:mm"
        let dateString = dateFormatter.string(from: date!)
        cellListCommentsFriends.dateTimeLabel.text = dateString
        
        return cellListCommentsFriends
    }
}
