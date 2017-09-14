//
//  ViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 7/27/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit
import SDWebImage
import Alamofire
import SwiftyJSON
import SKPhotoBrowser

class FeedPostsFriendTableViewCell: UITableViewCell {
    @IBOutlet weak var picturePostsImageView: UIImageView!
    @IBOutlet weak var messagePostsLabel: UILabel!
    @IBOutlet weak var profilePostsImageView: UIImageView!
    @IBOutlet weak var namePostsLabel: UILabel!
    @IBOutlet weak var createdTimePostsLabel: UILabel!
    @IBOutlet weak var placePostsLabel: UILabel!
    @IBOutlet weak var atPlacePostsLabel: UILabel!
    @IBOutlet weak var iconCheckInPostsImageView: UIImageView!
}

class StoryFriendsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var storyFriendsImageView: UIImageView!
    @IBOutlet weak var nameFriendsLabel: UILabel!
}

class FristViewController: UIViewController, FBSDKLoginButtonDelegate, UISearchBarDelegate, UITabBarControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var tablePostsFriends: UITableView!
    
    var accessToken: FBSDKAccessToken!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNavigationBarItem()
        
        self.loginButton.delegate = self
        
        profileImageButton.layer.masksToBounds = true
        profileImageButton.layer.cornerRadius = 20
        profileImageButton.layer.borderWidth = 2
        profileImageButton.layer.borderColor = UIColor.white.cgColor
        
        if  let token = FBSDKAccessToken.current() {
            fetchUserResource()
            fetchUserResourceFriends()
            accessToken = token
            print(accessToken.tokenString)
            print("Show >>> ", token.tokenString)
        }
    }
    // MARK: ViewController
    var userResourceData: UserResourceData! = nil
    
    func fetchUserResource() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), about, age_range, birthday, gender, cover, hometown, work,education,posts{created_time,message,full_picture,place}"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (_, result, _) in
            let dic = result as? NSDictionary
            let jsonString = dic?.toJsonString()
            self.userResourceData = UserResourceData(json: jsonString)
            let profileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.picture?.data?.url)!, width: 200, height: 200)
            self.profileImageButton.sd_setBackgroundImage(with: profileImageUrl, for: .normal, completed: nil)
        }
    }
    
    func customNavigationBarItem() {
        
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "ค้นหา"
        searchBar.delegate = self
        self.tabBarController?.navigationItem.titleView = searchBar
        
        let rightBarButton = UIButton(type: .custom)
        rightBarButton.setImage(UIImage(named: "iconMessengerFrist"), for: .normal)
        rightBarButton.frame = CGRect(x: 0, y:0, width: 30, height: 30)
        rightBarButton.tintColor = UIColor.white
        rightBarButton.addTarget(self, action: #selector(FristViewController.addTapped), for: .touchUpInside)
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        self.tabBarController?.navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
        
        let leftBarButton = UIButton(type: .custom)
        leftBarButton.setImage(UIImage(named: "iconCamera"), for: .normal)
        leftBarButton.frame = CGRect(x: 0, y:0, width: 30, height: 30)
        leftBarButton.tintColor = UIColor.white
        leftBarButton.addTarget(self, action: #selector(FristViewController.addTapped), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        self.tabBarController?.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
    }
    
    func addTapped() {
        print("addTapped")
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tabBarController?.navigationItem.titleView?.endEditing(true)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        fetchUserResource()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        self.profileImageButton.setImage(UIImage(named: "nill"), for: .normal)
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: TableView
    
    var userResource: UserResource! = nil
    
    func fetchUserResourceFriends() {
        var url = String(format:"https://graph.facebook.com/v2.10/me/friends?fields=name,picture{url},posts.limit(1){message,full_picture,created_time,place,reactions.limit(100){name,pic_large,type,link},comments{comment_count,message,from,created_time,comments{message,created_time,from}}}&limit=10&access_token=EAACEdEose0cBAKMyDAgC6J5eFj0fY6AzX74UKkLqDGTwRS2iJiSBk8ZCem8qpVLFmvnD0K0eGzanx0npcta06PHZBgh7aMrkTZCJxPxy5SBjZCjwkHqpezDmfnjcXVzAhgkZC2Xrpr6bigTk5XboZAosHIWeDZBs0EusaLyoWDFVODIXUnHIOekEVwmNa29kZCsjXNDA6WdBbAZDZD")
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(url, method: .get).validate().responseString { response in
            print(response)
            switch response.result {
            case .success(let value):
                self.userResource  = UserResource(json: value)
                self.tablePostsFriends.delegate = self
                self.tablePostsFriends.dataSource = self
                self.tablePostsFriends.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  userResource != nil {
            return userResource.data!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellFeedPostsFriendTableView = tableView.dequeueReusableCell(withIdentifier: "cellFeedPostsFriendTableView", for: indexPath) as! FeedPostsFriendTableViewCell
        let cellUserResourceData = userResource.data?[indexPath.row]
        let cellUserResourceDataPosts = cellUserResourceData?.posts?.data?[0]

        cellFeedPostsFriendTableView.namePostsLabel.text = cellUserResourceData?.name
        cellFeedPostsFriendTableView.messagePostsLabel.text = cellUserResourceDataPosts?.message
        cellFeedPostsFriendTableView.placePostsLabel.text = cellUserResourceDataPosts?.place?.name
        
        let profileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (cellUserResourceData?.picture?.data?.url)!, width: 300, height: 300)
        cellFeedPostsFriendTableView.profilePostsImageView.sd_setImage(with: profileImageUrl, completed: nil)

        cellFeedPostsFriendTableView.profilePostsImageView.layer.masksToBounds = true
        cellFeedPostsFriendTableView.profilePostsImageView.layer.cornerRadius = 17
        
        let userResourceDataPostsCreatedTime = cellUserResourceDataPosts?.created_time
        if userResourceDataPostsCreatedTime  != nil {
        let myLocale = Locale(identifier: "th_TH")
        let dateStringFormPostsDataCreatedTime = userResourceDataPostsCreatedTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateStringFormPostsDataCreatedTime!)
        dateFormatter.locale = myLocale
        dateFormatter.dateFormat = "EEEE" + " เวลา " + "hh:mm"
        let dateString = dateFormatter.string(from: date!)
        cellFeedPostsFriendTableView.createdTimePostsLabel.text = dateString
        } else {
            cellFeedPostsFriendTableView.createdTimePostsLabel.text = ""
        }
        
        let userResourceDataPostsPicture = cellUserResourceDataPosts?.full_picture
        if userResourceDataPostsPicture != nil && userResourceDataPostsPicture != "" {
            tablePostsFriends.rowHeight = 400
            cellFeedPostsFriendTableView.picturePostsImageView.sd_setImage(with: URL(string: (userResourceDataPostsPicture)!), completed: nil)
            cellFeedPostsFriendTableView.picturePostsImageView.contentMode = UIViewContentMode.scaleAspectFit
        } else {
            tablePostsFriends.rowHeight = 125
            cellFeedPostsFriendTableView.picturePostsImageView.image = nil
        }
        
        let userResourceDataPostsPlace = cellUserResourceDataPosts?.place
        if userResourceDataPostsPlace == nil {
            cellFeedPostsFriendTableView.atPlacePostsLabel.text = ""
            cellFeedPostsFriendTableView.iconCheckInPostsImageView.image = nil
        } else {
            cellFeedPostsFriendTableView.atPlacePostsLabel.text = "ที่"
            cellFeedPostsFriendTableView.iconCheckInPostsImageView.image = UIImage(named:"iconCheckin")
        }
        
        return cellFeedPostsFriendTableView
    }
}
