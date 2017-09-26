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
    @IBOutlet weak var titleVideosLabel: UILabel!
    @IBOutlet weak var updateTimePostsLabel: UILabel!
    @IBOutlet weak var friendsReactionImageView: UIImageView!
    @IBOutlet weak var friendsReactionButton: UIButton!
}

class VideosTableViewController: UITableViewController {
    
    @IBOutlet var tableListVideos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableListVideos.delegate = self
        tableListVideos.dataSource = self
        
        getDataUserResourceFriends()
    }
    
    var userResource: UserResource! = nil
    
    func getDataUserResourceFriends() {
        var url = String(format:"https://graph.facebook.com/v2.10/me/friends?fields=videos.limit(10){embed_html,picture,from,title,updated_time,source,reactions.limit(1){name,pic_large,type}}&access_token=EAACEdEose0cBAEnAfrJcjw3AnQqn7ZBxejxIbKt43iLDjwePOLvvupZACpGQ1VffquuLkLqZC7l5liQevCfZAm5JzkejvFY2wqWltZC2PTEbG6AVHGoVVdzJYZBM6fs9Ol8gN5HwC5yE1DEMZAn2fXDoWr3Vf9MG3OWUn194qPzcPHc35Aupa9ZC7RYl9XxDGIKJ42WP9cvnHAZDZD")
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(url, method: .get).validate().responseString { response in
            switch response.result {
            case .success(let value):
                self.userResource  = UserResource(json: value)
                print("userResource", self.userResource)
                self.tableListVideos.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  userResource != nil {
            return userResource.data!.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cellVideosList = tableView.dequeueReusableCell(withIdentifier: "cellVideosList", for: indexPath) as! VideosTableViewCell
        
        return cellVideosList
    }
}
