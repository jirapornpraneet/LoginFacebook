//
//  AboutProfileUserViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 9/1/2560 BE.
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

class AboutProfileUserViewController: UIViewController {
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var yearWorkedLabel: UILabel!
    @IBOutlet weak var facultyLabel: UILabel!
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var previousStudyLabel: UILabel!
    @IBOutlet weak var localLabel: UILabel!
    @IBOutlet weak var fromLocalLabel: UILabel!
    @IBOutlet weak var ralationshipLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserResourceProfile()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var userResourceData: UserResourceData! = nil
    
    func fetchUserResourceProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), about, age_range, birthday, gender, cover, hometown, work, education,location,relationship_status, posts{created_time, message, full_picture, place,reactions.limit(500){name,pic_large,type,link},comments{comment_count,message,from,created_time,comments{message,created_time,from}}}, albums{created_time, count, description,name, photos.limit(10){picture,name}}"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (_, result, _) in
            let resultDictionary = result as? NSDictionary
            let jsonString = resultDictionary?.toJsonString()
            self.userResourceData = UserResourceData(json: jsonString)
            let userResourceDataWork = self.userResourceData.work?[0]
            let userResourceDataWorkPositionName = userResourceDataWork?.position?.name
            self.positionLabel.text = userResourceDataWorkPositionName
        
            //            self.nameLabel.text = self.userResourceData.first_name + "  " + self.userResourceData.last_name
            //            self.schoolNameLabel.text = self.userResourceData.education?[2].school?.name
            //            self.concentrationNameLabel.text = self.userResourceData.education?[2].concentration?[0].name
            //            self.collegeNameLabel.text = self.userResourceData.education?[1].school?.name
            //
            //            let profileUpdateImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.picture?.data?.url)!, width: 200, height: 200)
            //            self.profileUpdateImageView.sd_setImage(with: profileUpdateImageUrl, completed:nil)
            //
            //            let profileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.picture?.data?.url)!, width: 200, height: 230)
            //            self.profileImageView.sd_setImage(with: profileImageUrl, completed:nil)
            //            self.profileImageView.contentMode = UIViewContentMode.scaleAspectFit
            //
            //            let coverImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.cover?.source)!, width: 480, height: 260)
            //            self.coverImageView.sd_setImage(with: coverImageUrl, completed:nil)
            //            
            //            self.tablePosts.reloadData()
        }
    }
}
