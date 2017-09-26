//
//  VideosTableViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 26/9/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FacebookLogin
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit
import SDWebImage

class VideosTableViewCell: UITableViewCell {
    @IBOutlet weak var pictureVideoImageView: UIImageView!
    @IBOutlet weak var messageVideosLabel: UILabel!
    @IBOutlet weak var updateTimePostsLabel: UILabel!
    @IBOutlet weak var iconReaction1ImageView: UIImageView!
    @IBOutlet weak var iconReaction2ImageView: UIImageView!
    @IBOutlet weak var reactionFriendsButton: UIButton!
    @IBOutlet weak var commentsFriendsButton: UIButton!
}

class VideosTableViewController: UITableViewController {
    
    @IBOutlet var tableListVideos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableListVideos.delegate = self
        tableListVideos.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cellVideosList = tableView.dequeueReusableCell(withIdentifier: "cellVideosList", for: indexPath) as! VideosTableViewCell
        
        return cellVideosList
    }
}
