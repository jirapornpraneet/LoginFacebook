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
        print("counttt",getReactionsFriendsCount)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count2", getReactionsFriendsCount)
        if getReactionsFriendsCount != 0 {
            return getReactionsFriendsCount
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellListReactionFriends = tableView.dequeueReusableCell(withIdentifier: "cellListReactionFriends", for: indexPath) as! ListReactionFriendsTableViewCell
        let cellReactionFriendsData = getReactionsFriendsData[indexPath.row] as! ReactionsDataDetail
       print("Data1",getReactionsFriendsData[indexPath.row])
        cellListReactionFriends.nameFriendsLabel.text = cellReactionFriendsData.name

        return cellListReactionFriends
    }
    
}
