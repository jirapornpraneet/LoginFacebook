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
    
    var setDataPostsCommentsCount = Int()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if setDataPostsCommentsCount != 0 {
            return setDataPostsCommentsCount
        } else {
            return 0
        }
    }
    
    var setDataPostsComments = [NSObject]()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellComments = tableView.dequeueReusableCell(withIdentifier: "cellComments", for: indexPath) as! CommentsFriendsTableViewCell
        let cellDataComments = setDataPostsComments[indexPath.row] as! CommentsDataDetail
        cellComments.commentsMessageLabel.text = cellDataComments.message
        cellComments.nameFriendsLabel.text = cellDataComments.from?.name
        
        let cellDataCommentsCount = cellDataComments.comment_count
        if cellDataCommentsCount == 0 {
            cellComments.commentsCountButton.setTitle("", for: .normal)
        } else {
            cellComments.commentsCountButton.setTitle(String(format: "%ความคิดเห็น %i %รายการ", cellDataCommentsCount), for: .normal)
            cellComments.commentsCountButton.tag = indexPath.row
        }
        
        let myLocale = Locale(identifier: "th_TH")
        let dateStringFormCommentsDataCreatedTime = cellDataComments.created_time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateStringFormCommentsDataCreatedTime)
        dateFormatter.locale = myLocale
        dateFormatter.dateFormat = "EEEE" + " เวลา " + "hh:mm"
        let dateString = dateFormatter.string(from: date!)
        cellComments.dateTimeLabel.text = dateString
        
        return cellComments
    }
    
    @IBAction func clickButtonToViewCommentsTableViewController(_ sender: AnyObject) {
        let senderCommentsFriendsButton = sender as! UIButton
        let getCellDataComments = setDataPostsComments[senderCommentsFriendsButton.tag] as! CommentsDataDetail
        let getDataComments = getCellDataComments.comments?.data
        let getDataCommentsCount = getCellDataComments.comments?.data?.count
    
        let commentsTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "CommentsView") as! CommentsTableViewController
        let navigationCommentsTableViewController = UINavigationController(rootViewController: commentsTableViewController)
        commentsTableViewController.getDataComments = getDataComments!
        commentsTableViewController.getDataCommentsCount = getDataCommentsCount!
        navigationCommentsTableViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        let popCommentsTableViewController = navigationCommentsTableViewController.popoverPresentationController
        popCommentsTableViewController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popCommentsTableViewController?.delegate = self
        popCommentsTableViewController?.sourceView = sender as? UIView
        popCommentsTableViewController?.sourceRect = sender.bounds
        
        self.present(navigationCommentsTableViewController, animated: true, completion: nil)
        
    }
    
}
