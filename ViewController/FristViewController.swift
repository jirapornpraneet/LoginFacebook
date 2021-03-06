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

class FristViewController: UIViewController, FBSDKLoginButtonDelegate, UISearchBarDelegate, UITabBarControllerDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIPopoverPresentationControllerDelegate {
    
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
            let thumborProfileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.picture?.data?.url)!, width: 200, height: 200)
            self.profileImageButton.sd_setBackgroundImage(with: thumborProfileImageUrl, for: .normal, completed: nil)
        }
    }
    
    func customNavigationBarItem() {
        
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "ค้นหา"
        searchBar.delegate = self
        self.tabBarController?.navigationItem.titleView = searchBar
        
        let rightBarButton = UIButton(type: .custom)
        rightBarButton.setImage(UIImage(named: "iconMessenger"), for: .normal)
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
        var url = String(format:"https://graph.facebook.com/v2.10/me/friends?fields=name,picture{url},link,posts.limit(1){message,full_picture,created_time,place,reactions.limit(100){name,pic_large,type,link},comments{comment_count,message,from,created_time,comments{message,created_time,from}}}&limit=10&access_token=EAACEdEose0cBALTVinqSCIHZBHXLmvUO09of8jYRbnGruzX2arCqmuZBnAOdNDleef1bZAOs5rRwxUIoAkHaRuZBcHG5w8H5KGy7hp3tzfHi2DR0TZB9vmfghMRpOpBZB99roZBkr0JyzMGIeVPIDtxuKNDq0ZCUJ8knC6hHU0rH568ZAs6WSWXMz2F3sM1Xpo3JQ0Vn2lxZBVrwZDZD")
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(url, method: .get).validate().responseString { response in
            switch response.result {
            case .success(let value):
                self.userResource  = UserResource(json: value)
                
                self.collectionviewStoryFriends.reloadData()
                self.tablePostsFriends.reloadData()
            case .failure( _): break
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
        let cellData = userResource.data?[indexPath.row]
        let cellDataPosts = cellData?.posts?.data?[0]
        
        cellFeedPostsFriendTableView.messagePostsLabel.text = cellDataPosts?.message
        cellFeedPostsFriendTableView.placePostsLabel.text = cellDataPosts?.place?.name
        
        let thumborProfileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (cellData?.picture?.data?.url)!, width: 300, height: 300)
        cellFeedPostsFriendTableView.profilePostsImageView.sd_setImage(with: thumborProfileImageUrl, completed: nil)
        
        cellFeedPostsFriendTableView.profilePostsImageView.layer.masksToBounds = true
        cellFeedPostsFriendTableView.profilePostsImageView.layer.cornerRadius = 17
        
        let cellDataPostsCreatedTime = cellDataPosts?.created_time
        if cellDataPostsCreatedTime  != nil {
            let myLocale = Locale(identifier: "th_TH")
            let dateStringFormPostsDataCreatedTime = cellDataPostsCreatedTime
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
        
        let cellDataPostsPicture = cellDataPosts?.full_picture
        if cellDataPostsPicture != nil && cellDataPostsPicture != "" {
            tablePostsFriends.rowHeight = 400
            cellFeedPostsFriendTableView.picturePostsImageView.sd_setImage(with: URL(string: (cellDataPostsPicture)!), completed: nil)
            cellFeedPostsFriendTableView.picturePostsImageView.contentMode = UIViewContentMode.scaleAspectFit
        } else {
            tablePostsFriends.rowHeight = 125
            cellFeedPostsFriendTableView.picturePostsImageView.image = nil
        }
        
        let cellDataPostsPlace = cellDataPosts?.place
        if cellDataPostsPlace == nil {
            cellFeedPostsFriendTableView.namePostsLabel.text = cellData?.name
            cellFeedPostsFriendTableView.iconCheckInPostsImageView.image = nil
        } else {
            cellFeedPostsFriendTableView.namePostsLabel.text = String(format:"%@   %ที่", (cellData?.name)!)
            cellFeedPostsFriendTableView.iconCheckInPostsImageView.image = UIImage(named:"iconCheckin")
        }
        
        let cellDataPostsCommentsCount = cellDataPosts?.comments?.data?.count
        if cellDataPostsCommentsCount == nil {
            cellFeedPostsFriendTableView.commentsFriendsButton.setTitle("", for: .normal)
        } else {
            cellFeedPostsFriendTableView.commentsFriendsButton.setTitle(String(format:"%ความคิดเห็น %i %รายการ", cellDataPostsCommentsCount!), for: .normal)
            cellFeedPostsFriendTableView.commentsFriendsButton.tag = indexPath.row
            cellFeedPostsFriendTableView.commentsFriendsButton.contentHorizontalAlignment = .right
        }
        
        let cellDataPostsReactions = cellDataPosts?.reactions?.data?[0]
        var cellDataPostsReactionsCount = cellDataPosts?.reactions?.data?.count
        
        if cellDataPostsReactions == nil && cellDataPostsReactionsCount == nil {
            cellFeedPostsFriendTableView.reactionFriendsButton.setTitle("", for: .normal)
            cellDataPostsReactionsCount = 0
            cellFeedPostsFriendTableView.iconReaction1ImageView.image = nil
        } else {
            
            let cellDataNameFriendReactions = cellDataPostsReactions?.name
            let lengthNameFriendReactions = cellDataNameFriendReactions?.characters.count
            
            if lengthNameFriendReactions! >= 10 {
                cellFeedPostsFriendTableView.reactionFriendsButton.setTitle(String(format:"%i", cellDataPostsReactionsCount!), for: .normal)
                cellFeedPostsFriendTableView.reactionFriendsButton.tag = indexPath.row
                cellFeedPostsFriendTableView.reactionFriendsButton.contentHorizontalAlignment = .left
            } else {
                let reactionCount = cellDataPostsReactionsCount! - 1
                cellFeedPostsFriendTableView.reactionFriendsButton.setTitle(String(format:"%@ %และคนอื่นๆอีก %i %คน", (cellDataPostsReactions?.name)!, reactionCount), for: .normal)
                cellFeedPostsFriendTableView.reactionFriendsButton.tag = indexPath.row
                cellFeedPostsFriendTableView.reactionFriendsButton.contentHorizontalAlignment = .left
            }
            
            let cellDataReactionsType = cellDataPostsReactions?.type
            
            if cellDataReactionsType == "LIKE" {
                cellFeedPostsFriendTableView.iconReaction1ImageView.image = UIImage(named:"iconLike")
            } else if  cellDataReactionsType == "LOVE" {
                cellFeedPostsFriendTableView.iconReaction1ImageView.image = UIImage(named:"iconLove")
            } else if cellDataReactionsType == "HAHA" {
                cellFeedPostsFriendTableView.iconReaction1ImageView.image = UIImage(named:"iconHaHa")
            } else if cellDataReactionsType == "SAD" {
                cellFeedPostsFriendTableView.iconReaction1ImageView.image = UIImage(named:"iconSad")
            } else if cellDataReactionsType == "WOW" {
                cellFeedPostsFriendTableView.iconReaction1ImageView.image = UIImage(named:"iconWow")
            } else {
                cellFeedPostsFriendTableView.iconReaction1ImageView.image = UIImage(named:"iconAngry")
            }
        }
        
        if cellDataPostsReactionsCount == 1 {
            cellFeedPostsFriendTableView.iconReaction2ImageView.image = nil
        } else {
            let cellDataReactionsIndex1 = cellDataPosts?.reactions?.data?[1]
            let cellDataReactionsTypeIndex1 = cellDataReactionsIndex1?.type
            let cellDataReactionsType = cellDataPostsReactions?.type
            if cellDataReactionsIndex1 == nil {
                cellFeedPostsFriendTableView.iconReaction2ImageView.image = nil
            } else {
                if cellDataReactionsTypeIndex1 == cellDataReactionsType {
                    cellFeedPostsFriendTableView.iconReaction2ImageView.image = nil
                } else {
                    if cellDataReactionsTypeIndex1 == "LIKE" {
                        cellFeedPostsFriendTableView.iconReaction2ImageView.image = UIImage(named:"iconLike")
                    } else if cellDataReactionsTypeIndex1 == "LOVE" {
                        cellFeedPostsFriendTableView.iconReaction2ImageView.image = UIImage(named:"iconLove")
                    } else if cellDataReactionsTypeIndex1 == "HAHA" {
                        cellFeedPostsFriendTableView.iconReaction2ImageView.image = UIImage(named:"iconHaHa")
                    } else if cellDataReactionsTypeIndex1 == "SAD" {
                        cellFeedPostsFriendTableView.iconReaction2ImageView.image = UIImage(named:"iconSad")
                    } else if cellDataReactionsTypeIndex1 == "WOW" {
                        cellFeedPostsFriendTableView.iconReaction2ImageView.image = UIImage(named:"iconWow")
                    } else {
                        cellFeedPostsFriendTableView.iconReaction2ImageView.image = UIImage(named:"iconAngry")
                    }
                }
            }
        }
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
        
        let cellData = userResource.data?[indexPath.row]
        cellStoryFriendsCollectionView.nameFriendsLabel.text = cellData?.name
        
        let thumborProfileFriendImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (cellData?.picture?.data?.url)!, width: 300, height: 300)
        cellStoryFriendsCollectionView.storyFriendsImageView.sd_setImage(with: thumborProfileFriendImageUrl, completed: nil)
        
        cellStoryFriendsCollectionView.storyFriendsImageView.layer.masksToBounds = true
        cellStoryFriendsCollectionView.storyFriendsImageView.layer.cornerRadius = 27
        cellStoryFriendsCollectionView.storyFriendsImageView.layer.borderWidth = 2
        cellStoryFriendsCollectionView.storyFriendsImageView.layer.borderColor = UIColor(red:0.17, green:0.38, blue:0.90, alpha:1.0).cgColor
        return cellStoryFriendsCollectionView
    }
    
    @IBAction func clickButtonToShowProfileUserViewController(_ sender: Any) {
        
        let showProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.show(showProfileViewController, sender: nil)
    }
    
    @IBAction func clickButtonToViewReactionFriendsTableViewController(_ sender: AnyObject) {
        
        let senderReactionFriendsButton = sender as! UIButton
        let getCellData = userResource.data?[senderReactionFriendsButton.tag]
        let getCellDataPosts = getCellData?.posts?.data?[0]
        let getCellDataPostsReaction = getCellDataPosts?.reactions?.data
        let getCellDataPostsReactionData = getCellDataPostsReaction!
        let getCellDataPostsCount = getCellDataPosts?.reactions?.data?.count
        let getCellDataPostsReactionCount = getCellDataPostsCount!
        
        let popReactionFriendsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReactionFriendsTableView") as! ReactionFriendsTableViewController
        popReactionFriendsTableViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        popReactionFriendsTableViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popReactionFriendsTableViewController.popoverPresentationController?.delegate = self
        popReactionFriendsTableViewController.popoverPresentationController?.sourceView = sender as? UIView
        popReactionFriendsTableViewController.popoverPresentationController?.sourceRect = sender.bounds
        
        popReactionFriendsTableViewController.setDataPostsReaction = getCellDataPostsReactionData
        popReactionFriendsTableViewController.setDataPostsReactionCount = getCellDataPostsReactionCount
        
        self.present(popReactionFriendsTableViewController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func clickButtonToViewCommentsFriendsTableViewController(_ sender: AnyObject) {
        
        let senderCommentsFriendsButton = sender as! UIButton
        let getCellData = userResource.data?[senderCommentsFriendsButton.tag]
        let getCellDataPosts = getCellData?.posts?.data?[0]
        let getCellDataPostsComments = getCellDataPosts?.comments?.data
        let getCellDataPostsCommentsData = getCellDataPostsComments!
        let getCellDataPostsCount = getCellDataPosts?.comments?.data?.count
        let getCellDataPostsCommentsCount = getCellDataPostsCount!
        
        let popCommentsFriendsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentsFriendsTableView") as! CommentsFriendsTableViewController
        popCommentsFriendsTableViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        popCommentsFriendsTableViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popCommentsFriendsTableViewController.popoverPresentationController?.delegate = self
        popCommentsFriendsTableViewController.popoverPresentationController?.sourceView = sender as? UIView
        popCommentsFriendsTableViewController.popoverPresentationController?.sourceRect = sender.bounds
        
        popCommentsFriendsTableViewController.setDataPostsComments = getCellDataPostsCommentsData
        popCommentsFriendsTableViewController.setDataPostsCommentsCount = getCellDataPostsCommentsCount
        
        self.present(popCommentsFriendsTableViewController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}
