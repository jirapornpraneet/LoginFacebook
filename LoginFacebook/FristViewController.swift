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

class FristViewController: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    var userResource: UserResource! = nil
    var loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email", "user_friends", "user_about_me"]
        return button
    }()
    var getToken: FBSDKAccessToken!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginButton)
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 4
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        loginButton.center = view.center
        loginButton.delegate = self
        if  let token = FBSDKAccessToken.current() {
            fetchProfile()
            getToken = token
            print(getToken.tokenString)
            print("Show >>> ", token.tokenString)
        }
    }
    func fetchProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), about, age_range, birthday, gender, cover, hometown, work,education,posts{created_time,message,full_picture,place}"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (_, result, _) in
            let dic = result as? NSDictionary
            let jsonString = dic?.toJsonString()
            self.userResource = UserResource(json: jsonString)
            self.nameLabel.text = self.userResource.first_name + "  " + self.userResource.last_name
            self.profileImageView.sd_setImage(with: URL(string: (self.userResource.picture?.data?.url)!), completed: nil)
                }
    }
    @IBAction func listFriendTouchUpInside(_ sender: Any) {
        self.performSegue(withIdentifier: "CollectionViewID", sender: sender)
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        fetchProfile()
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        self.nameLabel.text = ""
        self.profileImageView.image = nil
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
