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

    var setUserResourcePostsDataReactionCount = Int()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if setUserResourcePostsDataReactionCount != 0 {
            return setUserResourcePostsDataReactionCount
        } else {
            return 0
        }
    }
    
    var setUserResourcePostsDataReactionData = [NSObject]()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellListReactionFriends = tableView.dequeueReusableCell(withIdentifier: "cellListReactionFriends", for: indexPath) as! ListReactionFriendsTableViewCell
        let reactionData = setUserResourcePostsDataReactionData[indexPath.row] as! ReactionsDataDetail
        cellListReactionFriends.nameFriendsLabel.text = reactionData.name
        let profileFriendImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: reactionData.pic_large, width: 50, height: 50)
        cellListReactionFriends.profileFriendImageView.sd_setImage(with: profileFriendImageUrl, completed: nil)

        let reactionDataType = reactionData.type
        
        if reactionDataType == "LIKE" {
            cellListReactionFriends.reactionFriendImageView.image = UIImage(named:"iconLike")
        } else if reactionDataType == "LOVE" {
            cellListReactionFriends.reactionFriendImageView.image = UIImage(named:"iconLove")
        } else if reactionDataType == "HAHA" {
            cellListReactionFriends.reactionFriendImageView.image = UIImage(named:"iconHaHa")
        } else if reactionDataType == "SAD" {
            cellListReactionFriends.reactionFriendImageView.image = UIImage(named:"iconSad")
        } else if reactionDataType == "WOW" {
            cellListReactionFriends.reactionFriendImageView.image = UIImage(named:"iconWow")
        } else {
            cellListReactionFriends.reactionFriendImageView.image = UIImage(named:"iconAngry")
        }
        
        // MARK: Click NameFriendLabel Link
        let tapLinkUrlFriend = UITapGestureRecognizer(target: self, action: #selector(ListReactionFriendsTableViewController.tapLinkUrlProfileFriend))
        cellListReactionFriends.nameFriendsLabel.isUserInteractionEnabled = true
        cellListReactionFriends.nameFriendsLabel.tag = indexPath.row
        cellListReactionFriends.nameFriendsLabel.addGestureRecognizer(tapLinkUrlFriend)
        
        return cellListReactionFriends
    }
    
    func tapLinkUrlProfileFriend(_ sender: AnyObject) {
        let reactionData = setUserResourcePostsDataReactionData[sender.view.tag] as! ReactionsDataDetail
        if let linkUrlProfileFriend = URL(string: "\(reactionData.link)") {
            UIApplication.shared.open(linkUrlProfileFriend, options: [:], completionHandler: nil)
        }
    }

}
