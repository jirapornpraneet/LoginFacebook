//
//  ListCommentsTableViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 8/31/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit

class ListCommentsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameFriendsLabel: UILabel!
    @IBOutlet weak var profileFriendImageView: UIImageView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var commentsMessageLabel: UILabel!
}

class ListCommentsTableViewController: UITableViewController {
    
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
        print("Count", getUserResourceDataCommentsCount)
        if getUserResourceDataCommentsCount != 0 {
            return getUserResourceDataCommentsCount
        } else {
            return 0
        }
    }

    var getUserResourceDataCommentsData = [NSObject]()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellListComments = tableView.dequeueReusableCell(withIdentifier: "cellListComments", for: indexPath) as! ListCommentsTableViewCell
        let cellCommentsData = getUserResourceDataCommentsData[indexPath.row] as! CommentsDataDetail
        return cellListComments
    }
}
