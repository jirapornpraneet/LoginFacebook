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


class PostFriendTableViewCell: UITableViewCell {
    @IBOutlet weak var picturePostImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profilePostImageView: UIImageView!
    @IBOutlet weak var namePostLabel: UILabel!
    @IBOutlet weak var createdTimePostLabel: UILabel!
    @IBOutlet weak var placePostLabel: UILabel!
    @IBOutlet weak var atPlaceLabel: UILabel!
    @IBOutlet weak var iconCheckInImageView: UIImageView!
}

class DetailFriendViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var tablePostFriend: UITableView!
    @IBOutlet weak var imgImage: UIImageView!
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
    
    var getName = String()
    var getPictureDataURL = String()
    var getGender = String()
    var getBirthDay = String()
    var getCoverImage = String()
    var getEducation = String()
    var getHometown = String()
    var getEducationImage = UIImage()
    var getHometownImage = UIImage()
    
    var userResource: UserResource! = nil
    
    var getCreatedTime = String()
    var getMeaasge = String()
    var getFullPicture = String()
    var getPlace = String()
    var getCountPostFriends = Int()
    var friendsResource = FriendsResource()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        imgImage.layer.masksToBounds = true
        imgImage.layer.cornerRadius = 4
        imgImage.layer.borderWidth = 2
        imgImage.layer.borderColor = UIColor.white.cgColor
        
        nameLabel.text! = getName
        imgImage.sd_setImage(with: URL(string: (getPictureDataURL)), completed: nil)
        birthdayLabel.text? = getBirthDay
        genderLabel.text? = getGender
        hometownLabel.text? = getHometown
        educationLabel.text = getEducation
        educationImage.image = getEducationImage
        hometownImage.image = getHometownImage
        messengerToFriendLabel.text = String(format: "%เขียนอะไรบางอย่างถึง  %@ %.........",getName)
        coverImage.sd_setImage(with: URL(string: (getCoverImage)), completed: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DetailFriendViewController.ZoomPictureDataURL))
        imgImage.addGestureRecognizer(tap)
        imgImage.isUserInteractionEnabled = true
        
        tablePostFriend.dataSource = self
        tablePostFriend.delegate = self
        self.tablePostFriend.reloadData()
        
        getProfileUser()
    }
    
    func getProfileUser(){
        let parameters = ["fields" : "email, first_name, last_name, picture.type(large), about, age_range, birthday, gender, cover, hometown, work,education,posts{created_time,message,full_picture,place}"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            let dic = result as? NSDictionary
            let jsonString = dic?.toJsonString()
            self.userResource = UserResource(json: jsonString)
            self.profileUserImage.sd_setImage(with: URL(string: (self.userResource.picture?.data?.url)!), completed: nil)
        }
    }

    
    func ZoomPictureDataURL(){
        // 1. create URL Array
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL(getPictureDataURL)
        photo.shouldCachePhotoURLImage = true // you can use image cache by true(NSCache)
        images.append(photo)
        // 2. create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((getCountPostFriends) != nil) {
            return getCountPostFriends
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostFriendTableViewCell
//        let cellData = friendsResource.data?[indexPath.row]
//        let cellPostData = cellData?.posts?.data?[indexPath.row]
//        print("Post :",cellPostData)
  
        cell.messageLabel.text = "Message"
        cell.picturePostImageView = nil
        cell.namePostLabel.text = getName
        cell.createdTimePostLabel.text = getName
        cell.placePostLabel.text = ""
        cell.profilePostImageView.image = nil
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

