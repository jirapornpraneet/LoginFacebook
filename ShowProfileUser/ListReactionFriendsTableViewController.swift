//
//  ListReactionFriendsTableViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 8/25/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit

class ListReactionFriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameFriendsLabel: UILabel!
    @IBOutlet weak var profileFriendImageView: UIImageView!
    @IBOutlet weak var reactionFriendImageView: UIImageView!
}

class ListReactionFriendsTableViewController: UITableViewController {
    
    var getReactionsFriendsCount = Int()
    var getReactionsFriendsData = [NSObject]()
    
    @IBOutlet var tableListReactionFriends: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableListReactionFriends.delegate = self
        tableListReactionFriends.dataSource = self
        self.tableListReactionFriends.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if getReactionsFriendsCount != 0 {
            return getReactionsFriendsCount
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellListReactionFriends = tableView.dequeueReusableCell(withIdentifier: "cellListReactionFriends", for: indexPath) as! ListReactionFriendsTableViewCell
        let cellReactionData = getReactionsFriendsData[indexPath.row] as! ReactionsDataDetail
        cellListReactionFriends.nameFriendsLabel.text = cellReactionData.name
        let profileFriendImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: cellReactionData.pic_large, width: 50, height: 50)
        cellListReactionFriends.profileFriendImageView.sd_setImage(with: profileFriendImageUrl, completed: nil)

        let cellReactionType = cellReactionData.type
        
        if cellReactionType == "LIKE" {
            cellListReactionFriends.reactionFriendImageView.image = UIImage(named:"iconLike")
        } else if cellReactionType == "LOVE" {
            cellListReactionFriends.reactionFriendImageView.image = UIImage(named:"iconLove")
        } else if cellReactionType == "HAHA" {
            cellListReactionFriends.reactionFriendImageView.image = UIImage(named:"iconHaHa")
        } else if cellReactionType == "SAD" {
            cellListReactionFriends.reactionFriendImageView.image = UIImage(named:"iconSad")
        } else if cellReactionType == "WOW" {
            cellListReactionFriends.reactionFriendImageView.image = UIImage(named:"iconWow")
        } else {
            cellListReactionFriends.reactionFriendImageView.image = UIImage(named:"iconAngry")
        }
        return cellListReactionFriends
    }

}
