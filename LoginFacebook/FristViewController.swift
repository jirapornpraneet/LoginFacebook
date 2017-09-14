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

class FristViewController: UIViewController, FBSDKLoginButtonDelegate, UISearchBarDelegate, UITabBarControllerDelegate {
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    var accessToken: FBSDKAccessToken!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNavigationBarItem()
        
        self.loginButton.delegate = self
        
        profileImageButton.layer.masksToBounds = true
        profileImageButton.layer.cornerRadius = 20
        profileImageButton.layer.borderWidth = 2
        profileImageButton.layer.borderColor = UIColor.white.cgColor
        
        if  let token = FBSDKAccessToken.current() {
            fetchUserResource()
            fetchUserResourceFriends()
            accessToken = token
            print(accessToken.tokenString)
            print("Show >>> ", token.tokenString)
        }
    }
    // MARK: ViewController
    var userResourceData: UserResourceData! = nil
    
    func fetchUserResource() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), about, age_range, birthday, gender, cover, hometown, work,education,posts{created_time,message,full_picture,place}"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (_, result, _) in
            let dic = result as? NSDictionary
            let jsonString = dic?.toJsonString()
            self.userResourceData = UserResourceData(json: jsonString)
            let profileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.picture?.data?.url)!, width: 200, height: 200)
            self.profileImageButton.sd_setBackgroundImage(with: profileImageUrl, for: .normal, completed: nil)
        }
    }
    
    func customNavigationBarItem() {
        
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "ค้นหา"
        searchBar.delegate = self
        self.tabBarController?.navigationItem.titleView = searchBar
        
        let rightBarButton = UIButton(type: .custom)
        rightBarButton.setImage(UIImage(named: "iconMessengerFrist"), for: .normal)
        rightBarButton.frame = CGRect(x: 0, y:0, width: 30, height: 30)
        rightBarButton.tintColor = UIColor.white
        rightBarButton.addTarget(self, action: #selector(FristViewController.addTapped), for: .touchUpInside)
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        self.tabBarController?.navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
        
        let leftBarButton = UIButton(type: .custom)
        leftBarButton.setImage(UIImage(named: "iconCamera"), for: .normal)
        leftBarButton.frame = CGRect(x: 0, y:0, width: 30, height: 30)
        leftBarButton.tintColor = UIColor.white
        leftBarButton.addTarget(self, action: #selector(FristViewController.addTapped), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        self.tabBarController?.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
    }
    
    func addTapped() {
        print("addTapped")
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tabBarController?.navigationItem.titleView?.endEditing(true)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        fetchUserResource()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        self.profileImageButton.setImage(UIImage(named: "nill"), for: .normal)
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: TableView
    
    var userResource: UserResource! = nil
    
    func fetchUserResourceFriends() {
        var url = String(format:"https://graph.facebook.com/me/friends?fields=name,picture{url},posts.limit(1){message,full_picture,created_time,place}&limit=10&access_token=EAACEdEose0cBADV0kMLKpsKFxKwvE71c7cXQXa1G2Bu4WjdVQXEfI6YfuTPQl9VJWtYNqIlaDg1LoZBUpjaJhZA0ICa4zRxZBFUHvDRlQtXdFkVhb9BXYZAdIVUzRHzlUwoJ4graU0ycmD7BgY0mOistHuLLkCmJ9ScumtkZC9uKSAZAwRiwOmxoXDJlVXS8moaXoWA4ei5gZDZD")
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(url, method: .get).validate().responseString { response in
            print(response)
            switch response.result {
            case .success(let value):
                self.userResource  = UserResource(json: value)
            case .failure(let error):
                print(error)
            }
        }
    }
}
