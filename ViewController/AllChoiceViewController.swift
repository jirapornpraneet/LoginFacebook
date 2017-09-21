//
//  AllChoiceViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 9/21/2560 BE.
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

class AllChoiceViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserResourceProfile()
    }

    var userResourceData: UserResourceData! = nil
    
    func fetchUserResourceProfile() {
        let parameters = ["fields": "first_name, last_name, picture{url}, groups{name,picture{url}}"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (_, result, _) in
            let resultDictionary = result as? NSDictionary
            let jsonString = resultDictionary?.toJsonString()
            self.userResourceData = UserResourceData(json: jsonString)
            print("userResourceData", self.userResourceData)
            
            let userResourceDataName = self.userResourceData.first_name + "  " + self.userResourceData.last_name
            self.nameLabel.text = userResourceDataName
            
            let thumborProfileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.picture?.data?.url)!, width: 200, height: 200)
            self.profileImageButton.sd_setBackgroundImage(with: thumborProfileImageUrl, for: .normal, completed: nil)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
