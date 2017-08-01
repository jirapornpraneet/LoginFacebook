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

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
      @IBOutlet weak var lbShow: UILabel!
      @IBOutlet weak var imageShow: UIImageView!
      @IBOutlet weak var showFriendButton : UIButton!
      var userResource: UserResource! = nil
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email", "user_friends", "user_about_me"]
        return button
    }()
    var getToken:FBSDKAccessToken!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self
    
        if  let token = FBSDKAccessToken.current() {
            fetchProfile()
//            getToken = token
//            print(getToken.tokenString)
            print("Show >>> ",token.tokenString)
        }
    }
    
    
    func fetchProfile(){
        let parameters = ["fields" : "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            let dic = result as? NSDictionary
            let jsonString = dic?.toJsonString()
            print("Result :",result)
            print("Dic : ",dic)
            print("json :",jsonString)
            self.userResource = UserResource(json: jsonString)
            print("UserResource :", self.userResource)
            self.lbShow.text = self.userResource.first_name
             self.imageShow.sd_setImage(with: URL(string: (self.userResource.picture?.data?.url)!), completed: nil)
            }
    }
    
    @IBAction func listFriendTouchUpInside(_ sender: Any) {
        self.performSegue(withIdentifier: "ViewControllerID", sender: sender)
        
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("completed login")
        fetchProfile()
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        self.lbShow.text = ""
        self.imageShow.image = nil
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

