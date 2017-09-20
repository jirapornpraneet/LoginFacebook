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
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CommentsTableViewController.actionBackButtonToViewController))
        self.navigationItem.leftBarButtonItem =  backButton
    }
    
    func actionBackButtonToViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    var getDataCommentsCount = Int()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if getDataCommentsCount != 0 {
            return getDataCommentsCount
        } else {
            return 0
        }
    }
    
    var getDataComments = [NSObject]()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellCommentsView = tableView.dequeueReusableCell(withIdentifier: "cellCommentsView", for: indexPath) as! CommentsTableViewCell
        let cellDataComments = getDataComments[indexPath.row] as! CommentsDataDetail
        cellCommentsView.nameFriendsLabel.text = cellDataComments.from?.name
        cellCommentsView.commentsMessageLabel.text = cellDataComments.message
        
        let myLocale = Locale(identifier: "th_TH")
        let dateStringFormCellDataCommentsCreatedTime = cellDataComments.created_time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateStringFormCellDataCommentsCreatedTime)
        dateFormatter.locale = myLocale
        dateFormatter.dateFormat = "EEEE" + " เวลา " + "hh:mm"
        let dateString = dateFormatter.string(from: date!)
        cellCommentsView.dateTimeLabel.text = dateString
        
        return cellCommentsView
    }
}
