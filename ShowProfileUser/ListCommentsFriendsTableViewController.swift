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
}

class ListCommentsFriendsTableViewController: UITableViewController {

    var getCommentsFriendsCount = Int()
    var getCommentsFriendsData = [NSObject]()
    
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("getCommentsFriendsCount", getCommentsFriendsCount)
        if getCommentsFriendsCount != 0 {
            return getCommentsFriendsCount
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellListCommentsFriends = tableView.dequeueReusableCell(withIdentifier: "cellListCommentsFriends", for: indexPath) as! ListCommentsFriendsTableViewCell
        let cellCommentsData = getCommentsFriendsData[indexPath.row] as! CommentsDataDetail
        cellListCommentsFriends.nameFriendsLabel.text = cellCommentsData.message

        return cellListCommentsFriends
    }

}
