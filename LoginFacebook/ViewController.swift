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
import SDWebImage

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
      @IBOutlet weak var lbShow: UILabel!
      @IBOutlet weak var imageShow: UIImageView!
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self
        if let token = FBSDKAccessToken.current() {
            fetchProfile()
        }
    }
    func fetchProfile(){
        let parameters = ["fields" : "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            if let username = (result as AnyObject)["first_name"]! as? String {
                self.lbShow.text = "Hi " + username
            }else {
                self.lbShow.text = ""
            }
            
            if error != nil {
                print(error)
            }
            if let email = (result as AnyObject)["email"]! as? String{
                print(email)
            }
            
            if let picture = (result as AnyObject)["picture"]! as? NSDictionary,let data = picture["data"] as? NSDictionary,
                let url = data["url"]as? String {
                print(url)
                self.imageShow.sd_setImage(with: URL(string: url))
            }
        }
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

