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
}

class ViewController: UIViewController, FBSDKLoginButtonDelegate,UITableViewDelegate, UITableViewDataSource {
    
      @IBOutlet var tablePost: UITableView!
      @IBOutlet weak var nameLabel: UILabel!
      @IBOutlet weak var profileImageView: UIImageView!
      @IBOutlet weak var showFriendButton : UIButton!
      @IBOutlet weak var coverImageView: UIImageView!
      @IBOutlet weak var schoolNameLabel: UILabel!
      @IBOutlet weak var collegeNameLabel: UILabel!
      @IBOutlet weak var concentrationNameLabel: UILabel!
      @IBOutlet weak var profileUpdateImageView: UIImageView!

    
    var userResource: UserResource! = nil
    var loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email", "user_friends", "user_about_me"]
        return button
    }()
    
    var getToken:FBSDKAccessToken!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginButton)
        tablePost.dataSource = self
        tablePost.delegate = self
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 4
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        showFriendButton.layer.masksToBounds = true
        showFriendButton.layer.cornerRadius = 10
        loginButton.center =   CGPoint(x: 165,y : 80)
        loginButton.delegate = self
        let tapProfilePicture = UITapGestureRecognizer(target: self, action: #selector(ViewController.ZoomProfilePicture))
        profileImageView.addGestureRecognizer(tapProfilePicture)
        profileImageView.isUserInteractionEnabled = true
        let tapCoverPicture = UITapGestureRecognizer(target: self, action: #selector(ViewController.ZoomCoverPicture))
        coverImageView.addGestureRecognizer(tapCoverPicture)
        coverImageView.isUserInteractionEnabled = true
    
        if  let token = FBSDKAccessToken.current() {
            fetchProfile()
//            getToken = token
//            print(getToken.tokenString)
            print("Show >>> ",token.tokenString)
        }
    }
    
    func ZoomProfilePicture(){
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL((userResource.picture?.data?.url)!)
        photo.shouldCachePhotoURLImage = true
        images.append(photo)
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
    func ZoomCoverPicture(){
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL((userResource.cover?.source)!)
        photo.shouldCachePhotoURLImage = true
        images.append(photo)
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})        
    }
    
    func fetchProfile(){
        let parameters = ["fields" : "email, first_name, last_name, picture.type(large), about, age_range, birthday, gender, cover, hometown, work,education,posts{created_time,message,full_picture,place}"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            let dic = result as? NSDictionary
            let jsonString = dic?.toJsonString()
            print("Result :",result)
            print("Dic : ",dic)
            print("json :",jsonString)
            self.userResource = UserResource(json: jsonString)
//            print("UserResource :", self.userResource)
            self.nameLabel.text = self.userResource.first_name + "  " + self.userResource.last_name
            self.profileImageView.sd_setImage(with: URL(string: (self.userResource.picture?.data?.url)!), completed: nil)
            self.coverImageView.sd_setImage(with: URL(string: (self.userResource.cover?.source)!), completed: nil)
            self.schoolNameLabel.text = self.userResource.education?[2].school?.name
            self.concentrationNameLabel.text = self.userResource.education?[2].concentration?[0].name
            self.collegeNameLabel.text = self.userResource.education?[1].school?.name
            self.profileUpdateImageView.sd_setImage(with: URL(string: (self.userResource.picture?.data?.url)!), completed: nil)
            self.tablePost.reloadData()
        }
    }
    
    @IBAction func listFriendTouchUpInside(_ sender: Any) {
        self.performSegue(withIdentifier: "CollectionViewID", sender: sender)
        
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("completed login")
        fetchProfile()
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        self.nameLabel.text = ""
        self.profileImageView.image = nil
        self.coverImageView.image = nil
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((userResource) != nil) {
            return (userResource.posts?.data?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostUserTableViewCell
        let cellData = userResource.posts?.data?[indexPath.row]
        print("Cell : ", (cellData?.message)!)
        cell.messageLabel.text = (cellData?.message)!
        cell.picturePostImageView.sd_setImage(with: URL(string: (cellData?.full_picture)!), completed: nil)
        cell.profilePostImageView.sd_setImage(with: URL(string: (self.userResource.picture?.data?.url)!), completed: nil)
        cell.namePostLabel.text = self.userResource.first_name + "  " + self.userResource.last_name
        cell.createdTimePostLabel.text = cellData?.created_time
        let dateStringFormResource = cellData?.created_time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateStringFormResource!)
        print("DateFormResource: ",dateStringFormResource!)
        dateFormatter.dateFormat = "EEEE dd MMMM yyyy hh:mm:ss a ZZZZ"
        let dateString = dateFormatter.string(from: date!)
        print("DateString :" ,dateString)
        cell.placePostLabel.text = cellData?.place?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

