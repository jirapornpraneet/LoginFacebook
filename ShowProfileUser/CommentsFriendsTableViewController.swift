//
//  ListCommentsFriendsTableViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 8/28/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit

class CommentsFriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameFriendsLabel: UILabel!
    @IBOutlet weak var profileFriendImageView: UIImageView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var commentsMessageLabel: UILabel!
    @IBOutlet weak var commentsCountButton: UIButton!
}

class CommentsFriendsTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
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
        let cellListCommentsFriends = tableView.dequeueReusableCell(withIdentifier: "cellListCommentsFriends", for: indexPath) as! CommentsFriendsTableViewCell
        let cellCommentsData = setUserResourcePostsDataCommentsData[indexPath.row] as! CommentsDataDetail
        cellListCommentsFriends.commentsMessageLabel.text = cellCommentsData.message
        cellListCommentsFriends.nameFriendsLabel.text = cellCommentsData.from?.name
        
        let cellListCommentsDataCount = cellCommentsData.comment_count
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
    
    @IBAction func clickButtonToViewCommentsTableViewController(_ sender: AnyObject) {
        let senderCommentsFriendsButton = sender as! UIButton
        let getCommentsData = setUserResourcePostsDataCommentsData[senderCommentsFriendsButton.tag] as! CommentsDataDetail
        let getCommentsDataCommentsData = getCommentsData.comments?.data
        let getCommentsDataCommentsCount = getCommentsData.comments?.data?.count
        
        let popListCommentsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListComments") as! CommentsTableViewController
        popListCommentsTableViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        popListCommentsTableViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popListCommentsTableViewController.popoverPresentationController?.delegate = self
        popListCommentsTableViewController.popoverPresentationController?.sourceView = sender as? UIView // button
        popListCommentsTableViewController.popoverPresentationController?.sourceRect = sender.bounds
        
        popListCommentsTableViewController.getUserResourceDataCommentsData = getCommentsDataCommentsData!
        popListCommentsTableViewController.getUserResourceDataCommentsCount = getCommentsDataCommentsCount!
        
        self.present(popListCommentsTableViewController, animated: true, completion: nil)
        
    }
    
}
