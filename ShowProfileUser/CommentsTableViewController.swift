//
//  ListCommentsTableViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 8/31/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameFriendsLabel: UILabel!
    @IBOutlet weak var profileFriendImageView: UIImageView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var commentsMessageLabel: UILabel!
}

class CommentsTableViewController: UITableViewController {
    
    @IBOutlet var tableListComments: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableListComments.delegate = self
        tableListComments.dataSource = self
        self.tableListComments.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    var getUserResourceDataCommentsCount = Int()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if getUserResourceDataCommentsCount != 0 {
            return getUserResourceDataCommentsCount
        } else {
            return 0
        }
    }
    
    var getUserResourceDataCommentsData = [NSObject]()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellCommentsView = tableView.dequeueReusableCell(withIdentifier: "cellCommentsView", for: indexPath) as! CommentsTableViewCell
        let cellDataCommentsData = getUserResourceDataCommentsData[indexPath.row] as! CommentsDataDetail
        cellCommentsView.nameFriendsLabel.text = cellDataCommentsData.from?.name
        cellCommentsView.commentsMessageLabel.text = cellDataCommentsData.message
        
        let myLocale = Locale(identifier: "th_TH")
        let dateStringFormCommentsDataCreatedTime = cellDataCommentsData.created_time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateStringFormCommentsDataCreatedTime)
        dateFormatter.locale = myLocale
        dateFormatter.dateFormat = "EEEE" + " เวลา " + "hh:mm"
        let dateString = dateFormatter.string(from: date!)
        cellCommentsView.dateTimeLabel.text = dateString
        
        return cellCommentsView
    }
}
