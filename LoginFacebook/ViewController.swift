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

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
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
        if let token = FBSDKAccessToken.current(){
            fetchProfile()
        }
    }
    func fetchProfile(){
        print("fetchProfile")
        let parameters = ["fields" : "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            if error != nil {
                print(error)
            }
            if let email = (result as AnyObject)["email"]! as? String{
                print(email)
            }
            if let picture = (result as AnyObject)["picture"]! as? NSDictionary,let data = picture["data"] as? NSDictionary,
                let url = data["url"]as? String {
                print(url)
                
            }
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("completed login")
        fetchProfile()
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

