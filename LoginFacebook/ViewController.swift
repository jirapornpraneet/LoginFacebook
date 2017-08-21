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

class PostUserTableViewCell: UITableViewCell {
    @IBOutlet weak var picturePostImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profilePostImageView: UIImageView!
    @IBOutlet weak var namePostLabel: UILabel!
    @IBOutlet weak var createdTimePostLabel: UILabel!
    @IBOutlet weak var placePostLabel: UILabel!
    @IBOutlet weak var atPlaceLabel: UILabel!
    @IBOutlet weak var iconCheckInImageView: UIImageView!
}

class ViewController: UITableViewController {
      @IBOutlet var tablePost: UITableView!
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
        tablePost.dataSource = self
        tablePost.delegate = self

        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 4
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        showFriendButton.layer.masksToBounds = true
        showFriendButton.layer.cornerRadius = 10
        
        let tapProfilePicture = UITapGestureRecognizer(target: self, action: #selector(ViewController.ZoomProfilePicture))
        profileImageView.addGestureRecognizer(tapProfilePicture)
        profileImageView.isUserInteractionEnabled = true
        
        let tapCoverPicture = UITapGestureRecognizer(target: self, action: #selector(ViewController.ZoomCoverPicture))
        coverImageView.addGestureRecognizer(tapCoverPicture)
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
        let cellData = userResourceData.posts?.data?[sender.view.tag]
        var picturePostsImages = [SKPhoto]()
        let photoPicturePosts = SKPhoto.photoWithImageURL((cellData?.full_picture)!)
        photoPicturePosts.shouldCachePhotoURLImage = true
        picturePostsImages.append(photoPicturePosts)
        let browser = SKPhotoBrowser(photos: picturePostsImages)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
   
    func fetchProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), about, age_range, birthday, gender, cover, hometown, work, education, posts{created_time, message, full_picture, place}, albums{created_time, count, description,name, photos.limit(10){picture,name}}"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (_, result, _) in
            let dic = result as? NSDictionary
            let jsonString = dic?.toJsonString()
            self.userResourceData = UserResourceData(json: jsonString)
           
            self.nameLabel.text = self.userResourceData.first_name + "  " + self.userResourceData.last_name
            self.schoolNameLabel.text = self.userResourceData.education?[2].school?.name
            self.concentrationNameLabel.text = self.userResourceData.education?[2].concentration?[0].name
            self.collegeNameLabel.text = self.userResourceData.education?[1].school?.name
            
            let profileUpdateImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.picture?.data?.url)!, width: 200, height: 200)
            self.profileUpdateImageView.sd_setImage(with: profileUpdateImageUrl, completed:nil)
           
            let profileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.picture?.data?.url)!, width: 200, height: 200)
            self.profileImageView.sd_setImage(with: profileImageUrl, completed:nil)
            
            let coverImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.cover?.source)!, width: 480, height: 260)
            self.coverImageView.sd_setImage(with: coverImageUrl, completed:nil)
            
            self.tablePost.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostUserTableViewCell
        let cellData = userResourceData.posts?.data?[indexPath.row]
        
        cell.messageLabel.text = (cellData?.message)!
        cell.namePostLabel.text = self.userResourceData.first_name + "  " + self.userResourceData.last_name
        cell.placePostLabel.text = cellData?.place?.name
        
        let profileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.picture?.data?.url)!, width: 160, height: 160)
        cell.profilePostImageView.sd_setImage(with: profileImageUrl, completed:nil)
        
        let picturePost = cellData?.full_picture
        if  picturePost  == "" {
            tablePost.rowHeight = 135
            cell.picturePostImageView.image = nil
        } else {
            tablePost.rowHeight = 420
            let picturePostImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (cellData?.full_picture)!, width: 380, height: 400)
            cell.picturePostImageView.sd_setImage(with: picturePostImageUrl, completed:nil)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.ZoomPicture​Posts(_:)))
            cell.picturePostImageView.isUserInteractionEnabled = true
            cell.picturePostImageView.tag = indexPath.row
            cell.picturePostImageView.addGestureRecognizer(tapGestureRecognizer)
        }
        
        let myLocale = Locale(identifier: "th_TH")
        let dateStringFormResource = cellData?.created_time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateStringFormResource!)
        dateFormatter.locale = myLocale
        dateFormatter.dateFormat = "EEEE" + " เวลา " + "hh:mm"
        let dateString = dateFormatter.string(from: date!)
        cell.createdTimePostLabel.text = dateString
        
        let atPlace = cellData?.place
        let image = UIImage(named:"iconCheckin")
        if atPlace == nil {
            cell.atPlaceLabel.text = ""
            cell.iconCheckInImageView.image = nil
        } else {
            cell.atPlaceLabel.text = "ที่"
            cell.iconCheckInImageView.image = image
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
