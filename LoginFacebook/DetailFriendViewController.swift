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
    @IBOutlet weak var atPlacePostsLabel: UILabel!
    @IBOutlet weak var iconCheckInPostsImageView: UIImageView!
}

class DetailFriendViewController: UITableViewController {
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
    var getName = String()
    var getProfileImageUrl = String()
    var getGender = String()
    var getBirthDay = String()
    var getCoverImageUrl = String()
    var getEducation = String()
    var getHometown = String()
    var getEducationImage = UIImage()
    var getHometownImage = UIImage()
    //posts
    var getCreatedTime = String()
    var getMeaasge = String()
    var getFullPicture = String()
    var getPlace = String()
    var getPostsDataCount = Int()
    var getPostsData = [NSObject]()
    var getFriendsResource = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileFriendImageView.layer.masksToBounds = true
        profileFriendImageView.layer.cornerRadius = 4
        profileFriendImageView.layer.borderWidth = 2
        profileFriendImageView.layer.borderColor = UIColor.white.cgColor
        
        let profileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: getProfileImageUrl, width: 150, height: 150)
        profileFriendImageView.sd_setImage(with: profileImageUrl, completed:nil)

        let tapZoomPictureProfile = UITapGestureRecognizer(target: self, action: #selector(DetailFriendViewController.ZoomPictureProfile))
        profileFriendImageView.addGestureRecognizer(tapZoomPictureProfile)
        profileFriendImageView.isUserInteractionEnabled = true
        
        nameLabel.text! = getName
        birthdayLabel.text? = getBirthDay
        genderLabel.text? = getGender
        hometownLabel.text? = getHometown
        educationLabel.text = getEducation
        educationImage.image = getEducationImage
        hometownImage.image = getHometownImage
        messengerToFriendLabel.text = String(format: "%เขียนอะไรบางอย่างถึง  %@ %.........", getName)
        
        let coverImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (getCoverImageUrl), width: 480, height: 260)
        coverImage.sd_setImage(with: coverImageUrl, completed:nil)
        
        let tapZoomCoverPicture = UITapGestureRecognizer(target: self, action: #selector(DetailFriendViewController.ZoomCoverPicture))
        coverImage.addGestureRecognizer(tapZoomCoverPicture)
        coverImage.isUserInteractionEnabled = true
        
        tablePostsFriend.dataSource = self
        tablePostsFriend.delegate = self
        self.tablePostsFriend.reloadData()
        
        getProfileUser()
    }
    
    var userResourceData: UserResourceData! = nil
    
    func getProfileUser() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), about, age_range, birthday, gender, cover, hometown, work,education,posts{created_time,message,full_picture,place}"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (_, result, _) in
            let resultDictionary = result as? NSDictionary
            let jsonString = resultDictionary?.toJsonString()
            self.userResourceData = UserResourceData(json: jsonString)
            
            let profileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.picture?.data?.url)!, width: 160, height: 160)
            self.profileUserImage.sd_setImage(with: profileImageUrl, completed:nil)
        }
    }

    func ZoomPictureProfile() {
        var pictureDataURLimages = [SKPhoto]()
        let photoDataURL = SKPhoto.photoWithImageURL(getProfileImageUrl)
        photoDataURL.shouldCachePhotoURLImage = true
        pictureDataURLimages.append(photoDataURL)
        let browser = SKPhotoBrowser(photos: pictureDataURLimages)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
    
    func ZoomCoverPicture() {
        var CoverImages = [SKPhoto]()
        let photoCover = SKPhoto.photoWithImageURL(getCoverImageUrl)
        photoCover.shouldCachePhotoURLImage = true
        CoverImages.append(photoCover)
        let browser = SKPhotoBrowser(photos: CoverImages)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
    
    func ZoomPicture​Posts(_ sender: AnyObject) {
        let cellPostsData = getPostsData[sender.view.tag] as? PostsDataDetail
        var picture​PostsImages = [SKPhoto]()
        let photosPosts = SKPhoto.photoWithImageURL((cellPostsData?.full_picture)!)
        photosPosts.shouldCachePhotoURLImage = true
        picture​PostsImages.append(photosPosts)
        let browser = SKPhotoBrowser(photos: picture​PostsImages)
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
        if getPostsDataCount != 0 {
            return getPostsDataCount
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellPostsFriendTableView = tableView.dequeueReusableCell(withIdentifier: "cellPostsFriendTableView", for: indexPath) as! PostsFriendTableViewCell
        let cellPostsData = getPostsData[indexPath.row] as! PostsDataDetail
        
        cellPostsFriendTableView.messagePostsLabel.text = cellPostsData.message
        cellPostsFriendTableView.namePostsLabel.text = getName
        cellPostsFriendTableView.placePostsLabel.text = cellPostsData.place?.name
        
        let profileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (getProfileImageUrl), width: 150, height: 150)
        cellPostsFriendTableView.profilePostsImageView.sd_setImage(with: profileImageUrl, completed:nil)
        
        let myLocale = Locale(identifier: "th_TH")
        let dateStringFormResource = cellPostsData.created_time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateStringFormResource)
        dateFormatter.locale = myLocale
        dateFormatter.dateFormat = "EEEE" + " เวลา " + "hh:mm"
        let dateString = dateFormatter.string(from: date!)
        cellPostsFriendTableView.createdTimePostsLabel.text = dateString
        
        let picturePost = cellPostsData.full_picture
        if  picturePost  == "" {
            tablePostsFriend.rowHeight = 135
            cellPostsFriendTableView.picturePostsImageView.image = nil
        } else {
            tablePostsFriend.rowHeight = 420
            let picturePostImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (cellPostsData.full_picture), width: 380, height: 400)
            cellPostsFriendTableView.picturePostsImageView.sd_setImage(with: picturePostImageUrl, completed:nil)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.ZoomPicture​Posts(_:)))
            cellPostsFriendTableView.picturePostsImageView.isUserInteractionEnabled = true
            cellPostsFriendTableView.picturePostsImageView.tag = indexPath.row
            cellPostsFriendTableView.picturePostsImageView.addGestureRecognizer(tapGestureRecognizer)
        }
        
        let atPlace = cellPostsData.place
        if atPlace == nil {
            cellPostsFriendTableView.atPlacePostsLabel.text = ""
            cellPostsFriendTableView.iconCheckInPostsImageView.image = nil
        } else {
            cellPostsFriendTableView.atPlacePostsLabel.text = "ที่"
            cellPostsFriendTableView.iconCheckInPostsImageView.image = UIImage(named:"iconCheckin")
        }
        
        return cellPostsFriendTableView
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
