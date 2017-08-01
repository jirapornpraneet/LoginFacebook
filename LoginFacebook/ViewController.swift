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
            getToken = token
            print(getToken.tokenString)
            getDataCurrenciesAPI(showToken: token)
            print("Show >>> ",token.tokenString)
        }
    }
    
    var getJson = JSON([String: Any]())
    func getDataCurrenciesAPI(showToken: FBSDKAccessToken) {
        let url = String(format:"https://graph.facebook.com/me/taggable_friends?fields=name,picture&access_token=%@",showToken.tokenString)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            print(response)
            switch response.result {
            case .success(let value):
                self.getJson = JSON(value)
                print("ShowJson : %@", self.getJson)
                print("ShowJson : ",self.getJson)
            case .failure(let error):
                print(error)
            }
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
    
    @IBAction func listFriendTouchUpInside(_ sender: Any) {
        getDataCurrenciesAPI(showToken: getToken!)
        print(getToken.tokenString)
        self.performSegue(withIdentifier: "ShowKidney", sender: sender)
        
    }
//    func friendsList() {
//        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: nil)
//        graphRequest.start( completionHandler: { (connection, result, error) -> Void in
//            
//            if ((error) != nil)
//            {
//                // Process error
//                print("Error: \(error)")
//                return
//            }
//            
//            let summary = (result as AnyObject)["summary"] as! NSDictionary
//            let counts = (summary as AnyObject)["total_count"] as! NSNumber
//            
//            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: ["fields": "id,name,picture,url", "limit": "1"])
//            graphRequest.start( completionHandler: { (connection, result, error) -> Void in
//                
//                if ((error) != nil)
//                {
//                    print("Error: \(error)")
//                    return
//                }
//                else
//                {
//                    print(result)
////                    let friends = (result as AnyObject)["data"] as! NSArray
////                    var count = 1
////                    if let array = friends as? [NSDictionary] {
////                        for friend : NSDictionary in array {
////                            let name = (friend as AnyObject)["name"] as! NSString
////                            let picture = (friend as AnyObject)["picture"]! as! NSDictionary
////                            let data = picture["data"]! as! NSDictionary
////                            let url = data["url"]! as! String
////                            print("\(count) \(name) \(picture) \(url)")
////                            count += 1
////                        }
////                    }
//                }
//                
//            })
//        })
//    }
    
    
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

