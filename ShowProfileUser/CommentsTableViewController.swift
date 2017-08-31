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
        print("CountSend", getUserResourceDataCommentsCount)
        if getUserResourceDataCommentsCount != 0 {
            return getUserResourceDataCommentsCount
        } else {
            return 0
        }
    }
    
    var getUserResourceDataCommentsData = [NSObject]()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellListComments = tableView.dequeueReusableCell(withIdentifier: "cellListComments", for: indexPath) as! CommentsTableViewCell
        let cellCommentsData = getUserResourceDataCommentsData[indexPath.row] as! CommentsDataDetail
        cellListComments.nameFriendsLabel.text = cellCommentsData.from?.name
        cellListComments.commentsMessageLabel.text = cellCommentsData.message
        
        let myLocale = Locale(identifier: "th_TH")
        let dateStringFormCommentsDataCreatedTime = cellCommentsData.created_time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateStringFormCommentsDataCreatedTime)
        dateFormatter.locale = myLocale
        dateFormatter.dateFormat = "EEEE" + " เวลา " + "hh:mm"
        let dateString = dateFormatter.string(from: date!)
        cellListComments.dateTimeLabel.text = dateString
        
        return cellListComments
    }
}
