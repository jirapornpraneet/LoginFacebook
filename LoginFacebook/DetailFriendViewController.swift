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
    //profile
    var getName = String()
    var getPictureDataURL = String()
    var getGender = String()
    var getBirthDay = String()
    var getCoverImage = String()
    var getEducation = String()
    var getHometown = String()
    var getEducationImage = UIImage()
    var getHometownImage = UIImage()
    //posts
    var getCreatedTime = String()
    var getMeaasge = String()
    var getFullPicture = String()
    var getPlace = String()
    var getCountPostFriends = Int()
    var getPostsIndexPath = [NSObject]()
    var getFriendsResource = [AnyObject]()
    
    var friendsResource: FriendsResource! = nil
    var userResource: UserResource! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgImage.layer.masksToBounds = true
        imgImage.layer.cornerRadius = 4
        imgImage.layer.borderWidth = 2
        imgImage.layer.borderColor = UIColor.white.cgColor
        imgImage.sd_setImage(with: URL(string: (getPictureDataURL)), completed: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(DetailFriendViewController.ZoomPictureDataURL))
        imgImage.addGestureRecognizer(tap)
        imgImage.isUserInteractionEnabled = true
        
        nameLabel.text! = getName
        birthdayLabel.text? = getBirthDay
        genderLabel.text? = getGender
        hometownLabel.text? = getHometown
        educationLabel.text = getEducation
        educationImage.image = getEducationImage
        hometownImage.image = getHometownImage
        messengerToFriendLabel.text = String(format: "%เขียนอะไรบางอย่างถึง  %@ %.........",getName)
        coverImage.sd_setImage(with: URL(string: (getCoverImage)), completed: nil)
    
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
        let cellData = getPostsIndexPath[indexPath.row] as? PostsFriendsDataDetail
    
        cell.messageLabel.text = cellData?.message
        cell.picturePostImageView.sd_setImage(with: URL(string: (cellData?.full_picture)!), completed: nil)
        cell.namePostLabel.text = getName
        
        let myLocale = Locale(identifier: "th_TH")
        let dateStringFormResource = cellData?.created_time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateStringFormResource!)
        dateFormatter.locale = myLocale
        dateFormatter.dateFormat = "EEEE" + " เวลา " + "hh:mm"
        let dateString = dateFormatter.string(from: date!)
        cell.createdTimePostLabel.text = dateString
        
        cell.placePostLabel.text = cellData?.place?.name
        cell.profilePostImageView.sd_setImage(with: URL(string: (getPictureDataURL)), completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

