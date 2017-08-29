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

class PostsUserTableViewCell: UITableViewCell {
    @IBOutlet weak var picturePostsImageView: UIImageView!
    @IBOutlet weak var messagePostsLabel: UILabel!
    @IBOutlet weak var profilePostsImageView: UIImageView!
    @IBOutlet weak var namePostsLabel: UILabel!
    @IBOutlet weak var createdTimePostsLabel: UILabel!
    @IBOutlet weak var placePostsLabel: UILabel!
    @IBOutlet weak var atPlacePostsLabel: UILabel!
    @IBOutlet weak var iconCheckInPostsImageView: UIImageView!
    @IBOutlet weak var friendsReactionLabel: UILabel!
    @IBOutlet weak var iconReaction1ImageView: UIImageView!
    @IBOutlet weak var iconReaction2ImageView: UIImageView!
    @IBOutlet weak var commentsFriendsLabel: UILabel!

}

class ViewController: UITableViewController {
    @IBOutlet var tablePosts: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var showFriendButton: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var collegeNameLabel: UILabel!
    @IBOutlet weak var concentrationNameLabel: UILabel!
    @IBOutlet weak var profileUpdateImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablePosts.dataSource = self
        tablePosts.delegate = self

        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 4
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        
        let tapZoomProfilePicture = UITapGestureRecognizer(target: self, action: #selector(ViewController.ZoomProfilePicture))
        profileImageView.addGestureRecognizer(tapZoomProfilePicture)
        profileImageView.isUserInteractionEnabled = true
        
        let tapZoomCoverPicture = UITapGestureRecognizer(target: self, action: #selector(ViewController.ZoomCoverPicture))
        coverImageView.addGestureRecognizer(tapZoomCoverPicture)
        coverImageView.isUserInteractionEnabled = true
        
         if (FBSDKAccessToken.current()) != nil {
            fetchProfile()
        }
        
    }
    
    var userResourceData: UserResourceData! = nil
    
    func ZoomProfilePicture() {
        var profileImages = [SKPhoto]()
        let photoProfile = SKPhoto.photoWithImageURL((userResourceData.picture?.data?.url)!)
        photoProfile.shouldCachePhotoURLImage = true
        profileImages.append(photoProfile)
        let browser = SKPhotoBrowser(photos: profileImages)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
    
    func ZoomCoverPicture() {
        var coverImages = [SKPhoto]()
        let photoCover = SKPhoto.photoWithImageURL((userResourceData.cover?.source)!)
        photoCover.shouldCachePhotoURLImage = true
        coverImages.append(photoCover)
        let browser = SKPhotoBrowser(photos: coverImages)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
    
    func ZoomPicture​Posts(_ sender: AnyObject) {
        let userResourcePostsData = userResourceData.posts?.data?[sender.view.tag]
        var picturePostsImages = [SKPhoto]()
        let photosPosts = SKPhoto.photoWithImageURL((userResourcePostsData?.full_picture)!)
        photosPosts.shouldCachePhotoURLImage = true
        picturePostsImages.append(photosPosts)
        let browser = SKPhotoBrowser(photos: picturePostsImages)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
   
    func fetchProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), about, age_range, birthday, gender, cover, hometown, work, education, posts{created_time, message, full_picture, place,reactions.limit(500){name,pic_large,type,link},comments{comment_count,message,from,created_time}}, albums{created_time, count, description,name, photos.limit(10){picture,name}}"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (_, result, _) in
            let resultDictionary = result as? NSDictionary
            let jsonString = resultDictionary?.toJsonString()
            self.userResourceData = UserResourceData(json: jsonString)
    
            self.nameLabel.text = self.userResourceData.first_name + "  " + self.userResourceData.last_name
            self.schoolNameLabel.text = self.userResourceData.education?[2].school?.name
            self.concentrationNameLabel.text = self.userResourceData.education?[2].concentration?[0].name
            self.collegeNameLabel.text = self.userResourceData.education?[1].school?.name
            
            let profileUpdateImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.picture?.data?.url)!, width: 200, height: 200)
            self.profileUpdateImageView.sd_setImage(with: profileUpdateImageUrl, completed:nil)
           
            let profileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.picture?.data?.url)!, width: 200, height: 230)
            self.profileImageView.sd_setImage(with: profileImageUrl, completed:nil)
            self.profileImageView.contentMode = UIViewContentMode.scaleAspectFit
            
            let coverImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.cover?.source)!, width: 480, height: 260)
            self.coverImageView.sd_setImage(with: coverImageUrl, completed:nil)
            
            self.tablePosts.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userResourceData != nil {
            return (userResourceData.posts?.data?.count)!
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellPostsUserTableView = tableView.dequeueReusableCell(withIdentifier: "cellPostsUserTableView", for: indexPath) as! PostsUserTableViewCell
        let userResourcePostsData = userResourceData.posts?.data?[indexPath.row]
        
        cellPostsUserTableView.messagePostsLabel.text = (userResourcePostsData?.message)!
        cellPostsUserTableView.namePostsLabel.text = self.userResourceData.first_name + "  " + self.userResourceData.last_name
        cellPostsUserTableView.placePostsLabel.text = userResourcePostsData?.place?.name
        
        let profileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.picture?.data?.url)!, width: 160, height: 160)
        cellPostsUserTableView.profilePostsImageView.sd_setImage(with: profileImageUrl, completed:nil)
        
        let userResourcePostsDataFullPicture = userResourcePostsData?.full_picture
        if  userResourcePostsDataFullPicture   == "" {
            tablePosts.rowHeight = 135
            cellPostsUserTableView.picturePostsImageView.image = nil
        } else {
            tablePosts.rowHeight = 400
            cellPostsUserTableView.picturePostsImageView.sd_setImage(with: URL(string: (userResourcePostsData?.full_picture)!), completed: nil)
            cellPostsUserTableView.picturePostsImageView.contentMode = UIViewContentMode.scaleAspectFit
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.ZoomPicture​Posts(_:)))
            cellPostsUserTableView.picturePostsImageView.isUserInteractionEnabled = true
            cellPostsUserTableView.picturePostsImageView.tag = indexPath.row
            cellPostsUserTableView.picturePostsImageView.addGestureRecognizer(tapGestureRecognizer)
        }
        
        let myLocale = Locale(identifier: "th_TH")
        let dateStringFormUserResourcePostsDataCreatedTime = userResourcePostsData?.created_time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateStringFormUserResourcePostsDataCreatedTime!)
        dateFormatter.locale = myLocale
        dateFormatter.dateFormat = "EEEE" + " เวลา " + "hh:mm"
        let dateString = dateFormatter.string(from: date!)
        cellPostsUserTableView.createdTimePostsLabel.text = dateString
        
        let userResourcePostsDataPlacePosts = userResourcePostsData?.place
        let image = UIImage(named:"iconCheckin")
        if userResourcePostsDataPlacePosts == nil {
            cellPostsUserTableView.atPlacePostsLabel.text = ""
            cellPostsUserTableView.iconCheckInPostsImageView.image = nil
        } else {
            cellPostsUserTableView.atPlacePostsLabel.text = "ที่"
            cellPostsUserTableView.iconCheckInPostsImageView.image = image
        }
        
        let userResourcePostsDataCommentsDataCount = userResourcePostsData?.comments?.data?.count
        if userResourcePostsDataCommentsDataCount == nil {
            cellPostsUserTableView.commentsFriendsLabel.text = ""
        } else {
            cellPostsUserTableView.commentsFriendsLabel.text = String(format: "%ความคิดเห็น %i %รายการ", userResourcePostsDataCommentsDataCount!)
            
            let tapShowCommentsFriends = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapClickCommentsFriendsLabel))
            cellPostsUserTableView.commentsFriendsLabel.isUserInteractionEnabled = true
            cellPostsUserTableView.commentsFriendsLabel.tag = indexPath.row
            cellPostsUserTableView.commentsFriendsLabel.addGestureRecognizer(tapShowCommentsFriends)
        }
      
        let userResourcePostsDataReactionsData = userResourcePostsData?.reactions?.data?[0]
        var userResourcePostsDataReactionsDataCount = userResourcePostsData?.reactions?.data?.count
        if userResourcePostsDataReactionsData == nil && userResourcePostsDataReactionsDataCount == nil {
            cellPostsUserTableView.friendsReactionLabel.text = ""
            userResourcePostsDataReactionsDataCount = 0
            cellPostsUserTableView.iconReaction1ImageView.image = nil
            getUserResourcePostsDataReactionCount = 0
        } else {
            getUserResourcePostsDataReactionCount = userResourcePostsDataReactionsDataCount!
            
            let nameFriendReactions = userResourcePostsDataReactionsData?.name
            let length = nameFriendReactions?.characters.count
        
            if length! >= 10 {
                cellPostsUserTableView.friendsReactionLabel.text = String(format:"%i", userResourcePostsDataReactionsDataCount!)
                let tapShowReactionFriends = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapClickFriendsReactionLabel))
                cellPostsUserTableView.friendsReactionLabel.isUserInteractionEnabled = true
                cellPostsUserTableView.friendsReactionLabel.tag = indexPath.row
                cellPostsUserTableView.friendsReactionLabel.addGestureRecognizer(tapShowReactionFriends)
            } else {
                let reactionsCount = userResourcePostsDataReactionsDataCount! - 1
                cellPostsUserTableView.friendsReactionLabel.text = String(format:"%@ %และคนอื่นๆอีก %i %คน", (userResourcePostsDataReactionsData?.name)!, reactionsCount)
                let tapShowReactionFriends = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapClickFriendsReactionLabel))
                cellPostsUserTableView.friendsReactionLabel.isUserInteractionEnabled = true
                cellPostsUserTableView.friendsReactionLabel.tag = indexPath.row
                cellPostsUserTableView.friendsReactionLabel.addGestureRecognizer(tapShowReactionFriends)
            }
            
            let userResourcePostsDataReactionType = userResourcePostsDataReactionsData?.type
            
            if userResourcePostsDataReactionType == "LIKE" {
                cellPostsUserTableView.iconReaction1ImageView.image = UIImage(named:"iconLike")
            } else if userResourcePostsDataReactionType == "LOVE" {
                cellPostsUserTableView.iconReaction1ImageView.image = UIImage(named:"iconLove")
            } else if userResourcePostsDataReactionType == "HAHA" {
                cellPostsUserTableView.iconReaction1ImageView.image = UIImage(named:"iconHaHa")
            } else if userResourcePostsDataReactionType == "SAD" {
                cellPostsUserTableView.iconReaction1ImageView.image = UIImage(named:"iconSad")
            } else if userResourcePostsDataReactionType == "WOW" {
                cellPostsUserTableView.iconReaction1ImageView.image = UIImage(named:"iconWow")
            } else {
                cellPostsUserTableView.iconReaction1ImageView.image = UIImage(named:"iconAngry")
            }
        }
        
        if userResourcePostsDataReactionsDataCount == 1 {
            cellPostsUserTableView.iconReaction2ImageView.image = nil
        } else {
            let userResourcePostsDataReactionDataIndex1 = userResourcePostsData?.reactions?.data?[1]
            let userResourcePostsDataReactionTypeIndex1 = userResourcePostsDataReactionDataIndex1?.type
            let userResourcePostsDataReactionType = userResourcePostsDataReactionsData?.type
            if userResourcePostsDataReactionDataIndex1 == nil {
                cellPostsUserTableView.iconReaction2ImageView.image = nil
            } else {
                if userResourcePostsDataReactionTypeIndex1 == userResourcePostsDataReactionType {
                    cellPostsUserTableView.iconReaction2ImageView.image = nil
                } else {
                    if userResourcePostsDataReactionTypeIndex1 == "LIKE" {
                        cellPostsUserTableView.iconReaction2ImageView.image = UIImage(named:"iconLike")
                    } else if userResourcePostsDataReactionTypeIndex1 == "LOVE" {
                        cellPostsUserTableView.iconReaction2ImageView.image = UIImage(named:"iconLove")
                    } else if userResourcePostsDataReactionTypeIndex1 == "HAHA" {
                        cellPostsUserTableView.iconReaction2ImageView.image = UIImage(named:"iconHaHa")
                    } else if userResourcePostsDataReactionTypeIndex1 == "SAD" {
                        cellPostsUserTableView.iconReaction2ImageView.image = UIImage(named:"iconSad")
                    } else if userResourcePostsDataReactionTypeIndex1 == "WOW" {
                        cellPostsUserTableView.iconReaction2ImageView.image = UIImage(named:"iconWow")
                    } else {
                        cellPostsUserTableView.iconReaction2ImageView.image = UIImage(named:"iconAngry")
                    }
                }
            }
        }
        return cellPostsUserTableView
  }
    
    var getUserResourcePostsDataReactionCount = Int()
    var getUserResourcePostsDataReactionData = [NSObject]()
    
    func tapClickFriendsReactionLabel(_ sender: AnyObject) {
        
        let getUserResourcePostsData = userResourceData.posts?.data?[sender.view.tag]
        let getUserResourcePostsDataReaction = getUserResourcePostsData?.reactions?.data
        getUserResourcePostsDataReactionData = getUserResourcePostsDataReaction!
        let getUserResourcePostsDataCount = getUserResourcePostsData?.reactions?.data?.count
        getUserResourcePostsDataReactionCount = getUserResourcePostsDataCount!

        self.performSegue(withIdentifier: "ListReactionFriendsView", sender: nil)
    }
    
    var getUserResourcePostsDataCommentsCount = Int()
    var getUserResourcePostsDataCommentsData = [NSObject]()
    
    func tapClickCommentsFriendsLabel(_ sender: AnyObject) {
        
        let getUserResourcePostsData = userResourceData.posts?.data?[sender.view.tag]
        let getUserResourcePostsDataComments = getUserResourcePostsData?.comments?.data
        getUserResourcePostsDataCommentsData = getUserResourcePostsDataComments!
        let getUserResourcePostsDataCount = getUserResourcePostsData?.comments?.data?.count
        getUserResourcePostsDataCommentsCount = getUserResourcePostsDataCount!
        
        self.performSegue(withIdentifier: "ListCommentsFriendsView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListReactionFriendsView" {
            let setReactionsDataToListReactionFriendsTableView = segue.destination as! ListReactionFriendsTableViewController
            setReactionsDataToListReactionFriendsTableView.setUserResourcePostsDataReactionData = getUserResourcePostsDataReactionData
            setReactionsDataToListReactionFriendsTableView.setUserResourcePostsDataReactionCount = getUserResourcePostsDataReactionCount
        } else if segue.identifier == "ListCommentsFriendsView" {
            let setCommentsDataToListCommentsFriendsTableView = segue.destination as! ListCommentsFriendsTableViewController
            setCommentsDataToListCommentsFriendsTableView.setUserResourcePostsDataCommentsData = getUserResourcePostsDataCommentsData
            setCommentsDataToListCommentsFriendsTableView.setUserResourcePostsDataCommentsCount = getUserResourcePostsDataCommentsCount
        }
    }
}
