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
    @IBOutlet weak var employerNameLabel: UILabel!
    @IBOutlet weak var yearWorkedLabel: UILabel!
    @IBOutlet weak var concentrationNameLabel: UILabel!
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var previousStudyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var fromLocationLabel: UILabel!
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
            let userResourceDataWorkEmployerName = userResourceDataWork?.employer?.name
            self.employerNameLabel.text = userResourceDataWorkEmployerName
            let userResourceDataLocal = self.userResourceData.location?.name
            self.locationLabel.text = userResourceDataLocal
            self.fromLocationLabel.text = userResourceDataLocal
            let userResourceDataEducationConcentrationName  = self.userResourceData.education?[2].concentration?[0].name
            self.concentrationNameLabel.text = userResourceDataEducationConcentrationName
            let userResourceDataEducationName = self.userResourceData.education?[2].school?.name
            self.schoolNameLabel.text = userResourceDataEducationName
        }
    }
}
