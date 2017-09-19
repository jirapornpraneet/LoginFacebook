//
//  ListReactionFriendsTableViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 8/25/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit

class ReactionFriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameFriendsLabel: UILabel!
    @IBOutlet weak var profileFriendImageView: UIImageView!
    @IBOutlet weak var reactionFriendImageView: UIImageView!
}

class ReactionFriendsTableViewController: UITableViewController {
    
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
        let cellReactionFriends = tableView.dequeueReusableCell(withIdentifier: "cellReactionFriends", for: indexPath) as! ReactionFriendsTableViewCell
        let reactionData = setUserResourcePostsDataReactionData[indexPath.row] as! ReactionsDataDetail
        cellReactionFriends.nameFriendsLabel.text = reactionData.name
        let profileFriendImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: reactionData.pic_large, width: 50, height: 50)
        cellReactionFriends.profileFriendImageView.sd_setImage(with: profileFriendImageUrl, completed: nil)
        
        let reactionDataType = reactionData.type
        
        if reactionDataType == "LIKE" {
            cellReactionFriends.reactionFriendImageView.image = UIImage(named:"iconLike")
        } else if reactionDataType == "LOVE" {
            cellReactionFriends.reactionFriendImageView.image = UIImage(named:"iconLove")
        } else if reactionDataType == "HAHA" {
            cellReactionFriends.reactionFriendImageView.image = UIImage(named:"iconHaHa")
        } else if reactionDataType == "SAD" {
            cellReactionFriends.reactionFriendImageView.image = UIImage(named:"iconSad")
        } else if reactionDataType == "WOW" {
            cellReactionFriends.reactionFriendImageView.image = UIImage(named:"iconWow")
        } else {
            cellReactionFriends.reactionFriendImageView.image = UIImage(named:"iconAngry")
        }
        
        // MARK: Click NameFriendLabel Link
        let tapLinkUrlFriend = UITapGestureRecognizer(target: self, action: #selector(ReactionFriendsTableViewController.tapLinkUrlProfileFriend))
        cellReactionFriends.nameFriendsLabel.isUserInteractionEnabled = true
        cellReactionFriends.nameFriendsLabel.tag = indexPath.row
        cellReactionFriends.nameFriendsLabel.addGestureRecognizer(tapLinkUrlFriend)
        
        return cellReactionFriends
    }
    
    func tapLinkUrlProfileFriend(_ sender: AnyObject) {
        let reactionData = setUserResourcePostsDataReactionData[sender.view.tag] as! ReactionsDataDetail
        if let linkUrlProfileFriend = URL(string: "\(reactionData.link)") {
            UIApplication.shared.open(linkUrlProfileFriend, options: [:], completionHandler: nil)
        }
    }
    
}
