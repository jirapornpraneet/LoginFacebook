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
    @IBOutlet weak var iconCheckInPostsImageView: UIImageView!
    @IBOutlet weak var iconReaction1ImageView: UIImageView!
    @IBOutlet weak var iconReaction2ImageView: UIImageView!
    @IBOutlet weak var reactionFriendsButton: UIButton!
    @IBOutlet weak var commentsFriendsButton: UIButton!
}

class ProfileViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var tablePosts: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var showFriendButton: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var collegeNameLabel: UILabel!
    @IBOutlet weak var profileUpdateImageView: UIImageView!
    @IBOutlet weak var selectImagePickerButton: UIButton!
    @IBOutlet weak var selectImagePickerImageView: UIImageView!
    
    var picker: UIImagePickerController? = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker!.delegate = self
        
        tablePosts.dataSource = self
        tablePosts.delegate = self
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 4
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        
        let tapZoomProfilePicture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.ZoomProfilePicture))
        profileImageView.addGestureRecognizer(tapZoomProfilePicture)
        profileImageView.isUserInteractionEnabled = true
        
        let tapZoomCoverPicture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.ZoomCoverPicture))
        coverImageView.addGestureRecognizer(tapZoomCoverPicture)
        coverImageView.isUserInteractionEnabled = true
        
        if (FBSDKAccessToken.current()) != nil {
            fetchUserResourceProfile()
        }
        
    }
    
    @IBAction func selectImagePickerClicked(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "เลือกรูปภาพ", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { _ in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default) { _ in
            self.openGallary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { _ in
        }
        
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.present(alert, animated: true, completion: nil)
        } else {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "CameraImagePickerViewController")
            viewController.modalPresentationStyle = .popover
            let popover = viewController.popoverPresentationController!
            popover.delegate = self
            popover.permittedArrowDirections = .up
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            self.present(picker!, animated: true, completion: nil)
        } else {
            openGallary()
        }
    }
    
    func openGallary() {
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.present(picker!, animated:  true, completion: nil)
        } else {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CameraImagePickerViewController")
            vc.modalPresentationStyle = .popover
            let popover = vc.popoverPresentationController!
            popover.delegate = self
            popover.permittedArrowDirections = .up
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        selectImagePickerImageView.image = info [UIImagePickerControllerOriginalImage] as? UIImage
    }
      
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
    
    var userResourceDataName: String = ""
    
    func fetchUserResourceProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), about, age_range, birthday, gender, cover, hometown, work, education,location,relationship_status, posts{created_time, message, full_picture, place,reactions.limit(100){name,pic_large,type,link},comments{comment_count,message,from,created_time,comments{message,created_time,from}}}, albums{created_time, count, description,name, photos.limit(10){picture,name}}"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (_, result, _) in
            let resultDictionary = result as? NSDictionary
            let jsonString = resultDictionary?.toJsonString()
            self.userResourceData = UserResourceData(json: jsonString)
            
            self.userResourceDataName = self.userResourceData.first_name + "  " + self.userResourceData.last_name
            self.nameLabel.text = self.userResourceDataName
            
            let userResourceDataEducationConCentrationName = self.userResourceData.education?[2].concentration?[0].name
            let userResourceDataEducationSchoolName = self.userResourceData.education?[2].school?.name
            
            self.schoolNameLabel.text = String(format:"%เรียน  %@  %ที่  %@", userResourceDataEducationConCentrationName!, userResourceDataEducationSchoolName!)
            
            let userResourceDataEducationSchoolName1 = self.userResourceData.education?[0].school?.name
            self.collegeNameLabel.text = String(format: "%เคยศึกษาที่  %@", userResourceDataEducationSchoolName1!)
            
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
        
        cellPostsUserTableView.placePostsLabel.text = userResourcePostsData?.place?.name
        
        let profileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.picture?.data?.url)!, width: 160, height: 160)
        cellPostsUserTableView.profilePostsImageView.sd_setImage(with: profileImageUrl, completed:nil)
        
        let userResourcePostsDataFullPicture = userResourcePostsData?.full_picture
        if  userResourcePostsDataFullPicture  == "" {
            tablePosts.rowHeight = 135
            cellPostsUserTableView.picturePostsImageView.image = nil
        } else {
            tablePosts.rowHeight = 400
            cellPostsUserTableView.picturePostsImageView.sd_setImage(with: URL(string: (userResourcePostsData?.full_picture)!), completed: nil)
            cellPostsUserTableView.picturePostsImageView.contentMode = UIViewContentMode.scaleAspectFit
            
            let tapZoomPicturePosts = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.ZoomPicture​Posts(_:)))
            cellPostsUserTableView.picturePostsImageView.isUserInteractionEnabled = true
            cellPostsUserTableView.picturePostsImageView.tag = indexPath.row
            cellPostsUserTableView.picturePostsImageView.addGestureRecognizer(tapZoomPicturePosts)
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
        
        if userResourcePostsDataPlacePosts == nil {
            cellPostsUserTableView.iconCheckInPostsImageView.image = nil
            cellPostsUserTableView.namePostsLabel.text = String(format:"%@", self.userResourceDataName)
        } else {
            cellPostsUserTableView.namePostsLabel.text = String(format:"%@   %ที่", self.userResourceDataName)
            cellPostsUserTableView.iconCheckInPostsImageView.image = UIImage(named:"iconCheckin")
        }
        
        let userResourcePostsDataCommentsDataCount = userResourcePostsData?.comments?.data?.count
        if userResourcePostsDataCommentsDataCount == nil {
            cellPostsUserTableView.commentsFriendsButton.setTitle("", for: .normal)
        } else {
            cellPostsUserTableView.commentsFriendsButton.setTitle(String(format:"%ความคิดเห็น %i %รายการ", userResourcePostsDataCommentsDataCount!), for: .normal)
            cellPostsUserTableView.commentsFriendsButton.tag = indexPath.row
            cellPostsUserTableView.commentsFriendsButton.contentHorizontalAlignment = .right
        }
        
        let userResourcePostsDataReactionsData = userResourcePostsData?.reactions?.data?[0]
        var userResourcePostsDataReactionsDataCount = userResourcePostsData?.reactions?.data?.count
        if userResourcePostsDataReactionsData == nil && userResourcePostsDataReactionsDataCount == nil {
            cellPostsUserTableView.reactionFriendsButton.setTitle("", for: .normal)
            userResourcePostsDataReactionsDataCount = 0
            cellPostsUserTableView.iconReaction1ImageView.image = nil
        } else {
            
            let cellNameFriendReactions = userResourcePostsDataReactionsData?.name
            let length = cellNameFriendReactions?.characters.count
            
            if length! >= 10 {
                cellPostsUserTableView.reactionFriendsButton.setTitle(String(format:"%i", userResourcePostsDataReactionsDataCount!), for: .normal)
                cellPostsUserTableView.reactionFriendsButton.tag = indexPath.row
                cellPostsUserTableView.reactionFriendsButton.contentHorizontalAlignment = .left
            } else {
                let reactionsCount = userResourcePostsDataReactionsDataCount! - 1
                cellPostsUserTableView.reactionFriendsButton.setTitle(String(format:"%@ %และคนอื่นๆอีก %i %คน", (userResourcePostsDataReactionsData?.name)!, reactionsCount), for: .normal)
                cellPostsUserTableView.reactionFriendsButton.tag = indexPath.row
                cellPostsUserTableView.reactionFriendsButton.contentHorizontalAlignment = .left
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
    
    @IBAction func clickButtonToViewReactionFriendsTableViewController(_ sender: AnyObject) {
        
        let senderReactionFriendsButton = sender as! UIButton
        let getUserResourcePostsData = userResourceData.posts?.data?[senderReactionFriendsButton.tag]
        let getUserResourcePostsDataReaction = getUserResourcePostsData?.reactions?.data
        let getUserResourcePostsDataReactionData = getUserResourcePostsDataReaction!
        let getUserResourcePostsDataCount = getUserResourcePostsData?.reactions?.data?.count
        let getUserResourcePostsDataReactionCount = getUserResourcePostsDataCount!
        
        let popReactionFriendsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReactionFriendsTableView") as! ReactionFriendsTableViewController
        popReactionFriendsTableViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        popReactionFriendsTableViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popReactionFriendsTableViewController.popoverPresentationController?.delegate = self
        popReactionFriendsTableViewController.popoverPresentationController?.sourceView = sender as? UIView
        popReactionFriendsTableViewController.popoverPresentationController?.sourceRect = sender.bounds
        
        popReactionFriendsTableViewController.setUserResourcePostsDataReactionData = getUserResourcePostsDataReactionData
        popReactionFriendsTableViewController.setUserResourcePostsDataReactionCount = getUserResourcePostsDataReactionCount
        
        self.present(popReactionFriendsTableViewController, animated: true, completion: nil)
    }
    
    @IBAction func clickButtonToViewCommentsFriendsTableViewController(_ sender: AnyObject) {
        
        let senderCommentsFriendsButton = sender as! UIButton
        let getUserResourcePostsData = userResourceData.posts?.data?[senderCommentsFriendsButton.tag]
        let getUserResourcePostsDataComments = getUserResourcePostsData?.comments?.data
        let getUserResourcePostsDataCommentsData = getUserResourcePostsDataComments!
        let getUserResourcePostsDataCount = getUserResourcePostsData?.comments?.data?.count
        let getUserResourcePostsDataCommentsCount = getUserResourcePostsDataCount!
        
        let popCommentsFriendsTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentsFriendsTableView") as! CommentsFriendsTableViewController
        popCommentsFriendsTableViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        popCommentsFriendsTableViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popCommentsFriendsTableViewController.popoverPresentationController?.delegate = self
        popCommentsFriendsTableViewController.popoverPresentationController?.sourceView = sender as? UIView
        popCommentsFriendsTableViewController.popoverPresentationController?.sourceRect = sender.bounds
        
        popCommentsFriendsTableViewController.setUserResourcePostsDataCommentsData = getUserResourcePostsDataCommentsData
        popCommentsFriendsTableViewController.setUserResourcePostsDataCommentsCount = getUserResourcePostsDataCommentsCount
        
        self.present(popCommentsFriendsTableViewController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
