//
//  DetailFriendViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 8/2/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import SDWebImage
import SKPhotoBrowser
import FacebookLogin
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit
import Alamofire
import SwiftyJSON

class PostsFriendTableViewCell: UITableViewCell {
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

class DetailFriendViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    @IBOutlet var tablePostsFriend: UITableView!
    @IBOutlet weak var profileFriendImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var hometownLabel: UILabel!
    @IBOutlet weak var messengerToFriendLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var educationImage: UIImageView!
    @IBOutlet weak var hometownImage: UIImageView!
    @IBOutlet weak var profileUserImage: UIImageView!
    //profile
    var getDataName = String()
    var getDataProfileImageUrl = String()
    var getDataGender = String()
    var getDataBirthDay = String()
    var getDataCoverImageUrl = String()
    var getDataEducation = String()
    var getDataHometown = String()
    var getDataEducationImage = UIImage()
    var getDataHometownImage = UIImage()
    //posts
    var getDataPostsCreatedTime = String()
    var getDataPostsMeaasge = String()
    var getDataPostsFullPicture = String()
    var getDataPostsDataPlace = String()
    var getDataPostsCount = Int()
    var getDataPosts = [NSObject]()
    var getDataFriendsResource = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileFriendImageView.layer.masksToBounds = true
        profileFriendImageView.layer.cornerRadius = 4
        profileFriendImageView.layer.borderWidth = 2
        profileFriendImageView.layer.borderColor = UIColor.white.cgColor
        
        let thumborProfileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: getDataProfileImageUrl, width: 150, height: 150)
        profileFriendImageView.sd_setImage(with: thumborProfileImageUrl, completed:nil)
        
        let tapZoomPictureProfile = UITapGestureRecognizer(target: self, action: #selector(DetailFriendViewController.ZoomPictureProfile))
        profileFriendImageView.addGestureRecognizer(tapZoomPictureProfile)
        profileFriendImageView.isUserInteractionEnabled = true
        
        nameLabel.text! = getDataName
        birthdayLabel.text? = getDataBirthDay
        genderLabel.text? = getDataGender
        hometownLabel.text? = getDataHometown
        educationLabel.text = getDataEducation
        educationImage.image = getDataEducationImage
        hometownImage.image = getDataHometownImage
        messengerToFriendLabel.text = String(format: "%เขียนอะไรบางอย่างถึง  %@ %.........", getDataName)
        
        let thumborCoverImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (getDataCoverImageUrl), width: 480, height: 260)
        coverImage.sd_setImage(with: thumborCoverImageUrl, completed:nil)
        
        let tapZoomCoverPicture = UITapGestureRecognizer(target: self, action: #selector(DetailFriendViewController.ZoomCoverPicture))
        coverImage.addGestureRecognizer(tapZoomCoverPicture)
        coverImage.isUserInteractionEnabled = true
        
        tablePostsFriend.dataSource = self
        tablePostsFriend.delegate = self
        
        self.tablePostsFriend.reloadData()
        
        getUserResource()
    }
    
    var userResourceData: UserResourceData! = nil
    
    func getUserResource() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), about, age_range, birthday, gender, cover, hometown, work,education,posts{created_time,message,full_picture,place}"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (_, result, _) in
            let resultDictionary = result as? NSDictionary
            let jsonString = resultDictionary?.toJsonString()
            self.userResourceData = UserResourceData(json: jsonString)
            
            let thumborProfileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.picture?.data?.url)!, width: 160, height: 160)
            self.profileUserImage.sd_setImage(with: thumborProfileImageUrl, completed:nil)
            self.profileUserImage.contentMode = UIViewContentMode.scaleAspectFit
        }
    }
    
    func ZoomPictureProfile() {
        var images = [SKPhoto]()
        let photoProfile = SKPhoto.photoWithImageURL(getDataProfileImageUrl)
        photoProfile.shouldCachePhotoURLImage = true
        images.append(photoProfile)
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
    
    func ZoomCoverPicture() {
        var images = [SKPhoto]()
        let photoCover = SKPhoto.photoWithImageURL(getDataCoverImageUrl)
        photoCover.shouldCachePhotoURLImage = true
        images.append(photoCover)
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
    
    func ZoomPicture​Posts(_ sender: AnyObject) {
        let cellDataPosts = getDataPosts[sender.view.tag] as? PostsDataDetail
        var images = [SKPhoto]()
        let photosPosts = SKPhoto.photoWithImageURL((cellDataPosts?.full_picture)!)
        photosPosts.shouldCachePhotoURLImage = true
        images.append(photosPosts)
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if getDataPostsCount != 0 {
            return getDataPostsCount
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellPostsFriendTableView = tableView.dequeueReusableCell(withIdentifier: "cellPostsFriendTableView", for: indexPath) as! PostsFriendTableViewCell
        let cellDataPosts = getDataPosts[indexPath.row] as! PostsDataDetail
        
        cellPostsFriendTableView.messagePostsLabel.text = cellDataPosts.message
        cellPostsFriendTableView.placePostsLabel.text = cellDataPosts.place?.name
        
        let thumborProfileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (getDataProfileImageUrl), width: 150, height: 150)
        cellPostsFriendTableView.profilePostsImageView.sd_setImage(with:thumborProfileImageUrl, completed:nil)
        
        let myLocale = Locale(identifier: "th_TH")
        let dateStringFormCellDataPostsCreatedTime = cellDataPosts.created_time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateStringFormCellDataPostsCreatedTime)
        dateFormatter.locale = myLocale
        dateFormatter.dateFormat = "EEEE" + " เวลา " + "hh:mm"
        let dateString = dateFormatter.string(from: date!)
        cellPostsFriendTableView.createdTimePostsLabel.text = dateString
        
        let cellDataPostsPicturePost = cellDataPosts.full_picture
        if  cellDataPostsPicturePost  == "" {
            tablePostsFriend.rowHeight = 135
            cellPostsFriendTableView.picturePostsImageView.image = nil
        } else {
            tablePostsFriend.rowHeight = 400
            cellPostsFriendTableView.picturePostsImageView.sd_setImage(with: URL(string: (cellDataPosts.full_picture)), completed: nil)
            cellPostsFriendTableView.picturePostsImageView.contentMode = UIViewContentMode.scaleAspectFit
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.ZoomPicture​Posts(_:)))
            cellPostsFriendTableView.picturePostsImageView.isUserInteractionEnabled = true
            cellPostsFriendTableView.picturePostsImageView.tag = indexPath.row
            cellPostsFriendTableView.picturePostsImageView.addGestureRecognizer(tapGestureRecognizer)
        }
        
        
        let cellDataPostsPlace = cellDataPosts.place
        if cellDataPostsPlace == nil {
            cellPostsFriendTableView.namePostsLabel.text = getDataName
            cellPostsFriendTableView.iconCheckInPostsImageView.image = nil
        } else {
            cellPostsFriendTableView.namePostsLabel.text = String(format:"%@   %ที่", (getDataName))
            cellPostsFriendTableView.iconCheckInPostsImageView.image = UIImage(named:"iconCheckin")
        }
        
        let cellDataPostsCommentsCount = cellDataPosts.comments?.data?.count
        if cellDataPostsCommentsCount == nil {
            cellPostsFriendTableView.commentsFriendsButton.setTitle("", for: .normal)
        } else {
            cellPostsFriendTableView.commentsFriendsButton.setTitle(String(format:"%ความคิดเห็น %i %รายการ", cellDataPostsCommentsCount!), for: .normal)
            cellPostsFriendTableView.commentsFriendsButton.tag = indexPath.row
            cellPostsFriendTableView.commentsFriendsButton.contentHorizontalAlignment = .right
        }
        
        let cellDataPostsReactions = cellDataPosts.reactions?.data?[0]
        var cellDataPostsReactionsCount = cellDataPosts.reactions?.data?.count
        
        if cellDataPostsReactions == nil && cellDataPostsReactionsCount == nil {
            cellPostsFriendTableView.reactionFriendsButton.setTitle("", for: .normal)
            cellDataPostsReactionsCount = 0
            cellPostsFriendTableView.iconReaction1ImageView.image = nil
        } else {
            
            let cellDataNameFriendReactions = cellDataPostsReactions?.name
            let lengthNameFriendReactions = cellDataNameFriendReactions?.characters.count
            
            if lengthNameFriendReactions! >= 10 {
                cellPostsFriendTableView.reactionFriendsButton.setTitle(String(format:"%i", cellDataPostsReactionsCount!), for: .normal)
                cellPostsFriendTableView.reactionFriendsButton.tag = indexPath.row
                cellPostsFriendTableView.reactionFriendsButton.contentHorizontalAlignment = .left
            } else {
                let reactionCount = cellDataPostsReactionsCount! - 1
                cellPostsFriendTableView.reactionFriendsButton.setTitle(String(format:"%@ %และคนอื่นๆอีก %i %คน", (cellDataPostsReactions?.name)!, reactionCount), for: .normal)
                cellPostsFriendTableView.reactionFriendsButton.tag = indexPath.row
                cellPostsFriendTableView.reactionFriendsButton.contentHorizontalAlignment = .left
            }
            
            let cellDataReactionsType = cellDataPostsReactions?.type
            
            if cellDataReactionsType == "LIKE" {
                cellPostsFriendTableView.iconReaction1ImageView.image = UIImage(named:"iconLike")
            } else if  cellDataReactionsType == "LOVE" {
                cellPostsFriendTableView.iconReaction1ImageView.image = UIImage(named:"iconLove")
            } else if cellDataReactionsType == "HAHA" {
                cellPostsFriendTableView.iconReaction1ImageView.image = UIImage(named:"iconHaHa")
            } else if cellDataReactionsType == "SAD" {
                cellPostsFriendTableView.iconReaction1ImageView.image = UIImage(named:"iconSad")
            } else if cellDataReactionsType == "WOW" {
                cellPostsFriendTableView.iconReaction1ImageView.image = UIImage(named:"iconWow")
            } else {
                cellPostsFriendTableView.iconReaction1ImageView.image = UIImage(named:"iconAngry")
            }
        }
        
        if cellDataPostsReactionsCount == 1 {
            cellPostsFriendTableView.iconReaction2ImageView.image = nil
        } else {
            let cellDataReactionsIndex1 = cellDataPosts.reactions?.data?[1]
            let cellDataReactionsTypeIndex1 = cellDataReactionsIndex1?.type
            let cellDataReactionsType = cellDataPostsReactions?.type
            if cellDataReactionsIndex1 == nil {
                cellPostsFriendTableView.iconReaction2ImageView.image = nil
            } else {
                if cellDataReactionsTypeIndex1 == cellDataReactionsType {
                    cellPostsFriendTableView.iconReaction2ImageView.image = nil
                } else {
                    if cellDataReactionsTypeIndex1 == "LIKE" {
                        cellPostsFriendTableView.iconReaction2ImageView.image = UIImage(named:"iconLike")
                    } else if cellDataReactionsTypeIndex1 == "LOVE" {
                        cellPostsFriendTableView.iconReaction2ImageView.image = UIImage(named:"iconLove")
                    } else if cellDataReactionsTypeIndex1 == "HAHA" {
                        cellPostsFriendTableView.iconReaction2ImageView.image = UIImage(named:"iconHaHa")
                    } else if cellDataReactionsTypeIndex1 == "SAD" {
                        cellPostsFriendTableView.iconReaction2ImageView.image = UIImage(named:"iconSad")
                    } else if cellDataReactionsTypeIndex1 == "WOW" {
                        cellPostsFriendTableView.iconReaction2ImageView.image = UIImage(named:"iconWow")
                    } else {
                        cellPostsFriendTableView.iconReaction2ImageView.image = UIImage(named:"iconAngry")
                    }
                }
            }
        }
        
        return cellPostsFriendTableView
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @IBAction func clickButtonToViewReactionFriendsTableViewController(_ sender: AnyObject) {
        
        let senderReactionFriendsButton = sender as! UIButton
        let getCellDataPosts = getDataPosts[senderReactionFriendsButton.tag] as! PostsDataDetail
        let getCellDataPostsReaction = getCellDataPosts.reactions?.data
        let getCellDataPostsReactionData = getCellDataPostsReaction!
        let getCellDataPostsCount = getCellDataPosts.reactions?.data?.count
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
        let getCellDataPosts = getDataPosts[senderCommentsFriendsButton.tag] as! PostsDataDetail
        let getCellDataPostsComments = getCellDataPosts.comments?.data
        let getCellDataPostsCommentsData = getCellDataPostsComments!
        let getCellDataPostsCount = getCellDataPosts.comments?.data?.count
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
