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
    @IBOutlet weak var iconReaction1ImageView: UIImageView!
    @IBOutlet weak var iconReaction2ImageView: UIImageView!
    @IBOutlet weak var reactionFriendsButton: UIButton!
    @IBOutlet weak var commentsFriendsButton: UIButton!
}

class StoryFriendsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var storyFriendsImageView: UIImageView!
    @IBOutlet weak var nameFriendsLabel: UILabel!
}

class FristViewController: UIViewController, FBSDKLoginButtonDelegate, UISearchBarDelegate, UITabBarControllerDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var tablePostsFriends: UITableView!
    @IBOutlet weak var collectionviewStoryFriends: UICollectionView!
    
    var accessToken: FBSDKAccessToken!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNavigationBarItem()
        
        self.loginButton.delegate = self
        
        profileImageButton.layer.masksToBounds = true
        profileImageButton.layer.cornerRadius = 20
        profileImageButton.layer.borderWidth = 2
        profileImageButton.layer.borderColor = UIColor.white.cgColor
        
        self.tablePostsFriends.delegate = self
        self.tablePostsFriends.dataSource = self
        self.collectionviewStoryFriends.delegate = self
        self.collectionviewStoryFriends.dataSource = self
        
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
        var url = String(format:"https://graph.facebook.com/v2.10/me/friends?fields=name,picture{url},posts.limit(1){message,full_picture,created_time,place,reactions.limit(100){name,pic_large,type,link},comments{comment_count,message,from,created_time,comments{message,created_time,from}}}&limit=10&access_token=EAACEdEose0cBAHaVLwZC2kldMqQuNPWfByqin9J1YcSFaaanWhlSscKYHqrMtEfAxcvvQDtZBTgRCw8TslGC9CtYrZARXRWKZAjKq0y2ZBZBBgmj4TQvOXiDe2JZBdGZCmQtQKN9uVZBSauZBAN35ZBAMWmQMGTLZA9CjYw8sXp7XwXVVZAoDHAtzt4sEhZCqzTylhjZAZC60cwm1Ay3tQZDZD")
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(url, method: .get).validate().responseString { response in
            print(response)
            switch response.result {
            case .success(let value):
                self.userResource  = UserResource(json: value)
                
                self.collectionviewStoryFriends.reloadData()
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
        let userResourceData = userResource.data?[indexPath.row]
        let userResourceDataPosts = userResourceData?.posts?.data?[0]
        
        cellFeedPostsFriendTableView.messagePostsLabel.text = userResourceDataPosts?.message
        cellFeedPostsFriendTableView.placePostsLabel.text = userResourceDataPosts?.place?.name
        
        let profileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (userResourceData?.picture?.data?.url)!, width: 300, height: 300)
        cellFeedPostsFriendTableView.profilePostsImageView.sd_setImage(with: profileImageUrl, completed: nil)
        
        cellFeedPostsFriendTableView.profilePostsImageView.layer.masksToBounds = true
        cellFeedPostsFriendTableView.profilePostsImageView.layer.cornerRadius = 17
        
        let userResourceDataPostsCreatedTime = userResourceDataPosts?.created_time
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
        
        let userResourceDataPostsPicture = userResourceDataPosts?.full_picture
        if userResourceDataPostsPicture != nil && userResourceDataPostsPicture != "" {
            tablePostsFriends.rowHeight = 400
            cellFeedPostsFriendTableView.picturePostsImageView.sd_setImage(with: URL(string: (userResourceDataPostsPicture)!), completed: nil)
            cellFeedPostsFriendTableView.picturePostsImageView.contentMode = UIViewContentMode.scaleAspectFit
        } else {
            tablePostsFriends.rowHeight = 125
            cellFeedPostsFriendTableView.picturePostsImageView.image = nil
        }
        
        let userResourceDataPostsPlace = userResourceDataPosts?.place
        if userResourceDataPostsPlace == nil {
              cellFeedPostsFriendTableView.namePostsLabel.text = userResourceData?.name
            cellFeedPostsFriendTableView.iconCheckInPostsImageView.image = nil
        } else {
            cellFeedPostsFriendTableView.namePostsLabel.text = String(format:"%@   %ที่", (userResourceData?.name)!)
            cellFeedPostsFriendTableView.iconCheckInPostsImageView.image = UIImage(named:"iconCheckin")
        }
                
        let userResourcePostsCommentsDataCount = userResourceDataPosts?.comments?.data?.count
        if userResourcePostsCommentsDataCount == nil {
            cellFeedPostsFriendTableView.commentsFriendsButton.setTitle("", for: .normal)
        } else {
            cellFeedPostsFriendTableView.commentsFriendsButton.setTitle(String(format:"%ความคิดเห็น %i %รายการ", userResourcePostsCommentsDataCount!), for: .normal)
            cellFeedPostsFriendTableView.commentsFriendsButton.tag = indexPath.row
            cellFeedPostsFriendTableView.commentsFriendsButton.contentHorizontalAlignment = .right
        }
              
//        let cellUserResourcePostsDataReactionsData = cellUserResourcePostsData?.reactions?.data?[0]
//        var cellUserResourcePostsDataReactionsDataCount = cellUserResourcePostsData?.reactions?.data?.count
//        if cellUserResourcePostsDataReactionsData == nil && cellUserResourcePostsDataReactionsDataCount == nil {
//            cellPostsUserTableView.reactionFriendsButton.setTitle("", for: .normal)
//            cellUserResourcePostsDataReactionsDataCount = 0
//            cellPostsUserTableView.iconReaction1ImageView.image = nil
//        } else {
//            
//            let cellNameFriendReactions = cellUserResourcePostsDataReactionsData?.name
//            let length = cellNameFriendReactions?.characters.count
//            
//            if length! >= 10 {
//                cellPostsUserTableView.reactionFriendsButton.setTitle(String(format:"%i", cellUserResourcePostsDataReactionsDataCount!), for: .normal)
//                cellPostsUserTableView.reactionFriendsButton.tag = indexPath.row
//                cellPostsUserTableView.reactionFriendsButton.contentHorizontalAlignment = .left
//            } else {
//                let reactionsCount = cellUserResourcePostsDataReactionsDataCount! - 1
//                cellPostsUserTableView.reactionFriendsButton.setTitle(String(format:"%@ %และคนอื่นๆอีก %i %คน", (cellUserResourcePostsDataReactionsData?.name)!, reactionsCount), for: .normal)
//                cellPostsUserTableView.reactionFriendsButton.tag = indexPath.row
//                cellPostsUserTableView.reactionFriendsButton.contentHorizontalAlignment = .left
//            }
//            
//            let cellUserResourcePostsDataReactionType = cellUserResourcePostsDataReactionsData?.type
//            
//            if cellUserResourcePostsDataReactionType == "LIKE" {
//                cellPostsUserTableView.iconReaction1ImageView.image = UIImage(named:"iconLike")
//            } else if cellUserResourcePostsDataReactionType == "LOVE" {
//                cellPostsUserTableView.iconReaction1ImageView.image = UIImage(named:"iconLove")
//            } else if cellUserResourcePostsDataReactionType == "HAHA" {
//                cellPostsUserTableView.iconReaction1ImageView.image = UIImage(named:"iconHaHa")
//            } else if cellUserResourcePostsDataReactionType == "SAD" {
//                cellPostsUserTableView.iconReaction1ImageView.image = UIImage(named:"iconSad")
//            } else if cellUserResourcePostsDataReactionType == "WOW" {
//                cellPostsUserTableView.iconReaction1ImageView.image = UIImage(named:"iconWow")
//            } else {
//                cellPostsUserTableView.iconReaction1ImageView.image = UIImage(named:"iconAngry")
//            }
//        }
//        
//        if cellUserResourcePostsDataReactionsDataCount == 1 {
//            cellPostsUserTableView.iconReaction2ImageView.image = nil
//        } else {
//            let cellUserResourcePostsDataReactionDataIndex1 = cellUserResourcePostsData?.reactions?.data?[1]
//            let cellUserResourcePostsDataReactionTypeIndex1 = cellUserResourcePostsDataReactionDataIndex1?.type
//            let cellUserResourcePostsDataReactionType = cellUserResourcePostsDataReactionsData?.type
//            if cellUserResourcePostsDataReactionDataIndex1 == nil {
//                cellPostsUserTableView.iconReaction2ImageView.image = nil
//            } else {
//                if cellUserResourcePostsDataReactionTypeIndex1 == cellUserResourcePostsDataReactionType {
//                    cellPostsUserTableView.iconReaction2ImageView.image = nil
//                } else {
//                    if cellUserResourcePostsDataReactionTypeIndex1 == "LIKE" {
//                        cellPostsUserTableView.iconReaction2ImageView.image = UIImage(named:"iconLike")
//                    } else if cellUserResourcePostsDataReactionTypeIndex1 == "LOVE" {
//                        cellPostsUserTableView.iconReaction2ImageView.image = UIImage(named:"iconLove")
//                    } else if cellUserResourcePostsDataReactionTypeIndex1 == "HAHA" {
//                        cellPostsUserTableView.iconReaction2ImageView.image = UIImage(named:"iconHaHa")
//                    } else if cellUserResourcePostsDataReactionTypeIndex1 == "SAD" {
//                        cellPostsUserTableView.iconReaction2ImageView.image = UIImage(named:"iconSad")
//                    } else if cellUserResourcePostsDataReactionTypeIndex1 == "WOW" {
//                        cellPostsUserTableView.iconReaction2ImageView.image = UIImage(named:"iconWow")
//                    } else {
//                        cellPostsUserTableView.iconReaction2ImageView.image = UIImage(named:"iconAngry")
//                    }
//                }
//            }
//        }

        
        return cellFeedPostsFriendTableView
    }
    
    // MARK: CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  userResource != nil {
            return userResource.data!.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellStoryFriendsCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "cellStoryFriendsCollectionView", for: indexPath) as! StoryFriendsCollectionViewCell
        
        let userResourceData = userResource.data?[indexPath.row]
        cellStoryFriendsCollectionView.nameFriendsLabel.text = userResourceData?.name
        
        let profileFriendImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (userResourceData?.picture?.data?.url)!, width: 300, height: 300)
        cellStoryFriendsCollectionView.storyFriendsImageView.sd_setImage(with: profileFriendImageUrl, completed: nil)
        
        cellStoryFriendsCollectionView.storyFriendsImageView.layer.masksToBounds = true
        cellStoryFriendsCollectionView.storyFriendsImageView.layer.cornerRadius = 27

        return cellStoryFriendsCollectionView
        
    }
}
