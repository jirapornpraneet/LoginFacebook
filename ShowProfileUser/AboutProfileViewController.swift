//
//  AboutProfileViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 9/6/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FacebookLogin
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit
import SDWebImage

class FriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var profileFriendsImageView: UIImageView!
    @IBOutlet weak var nameFriendsLabel: UILabel!
    @IBOutlet weak var friendButton: UIButton!
}

class AboutProfileViewController: UIViewController {
    @IBOutlet weak var employerNameLabel: UILabel!
    @IBOutlet weak var yearWorkedLabel: UILabel!
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var previousStudyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var fromLocationLabel: UILabel!
    @IBOutlet weak var ralationshipLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var userResourceData: UserResourceData! = nil
    
    func fetchUserResourceProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), about, age_range, birthday, gender, cover, hometown, work, education,location,relationship_status, music.limit(4){name,picture{url},category},movies.limit(4){global_brand_page_name,picture{url}}"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (_, result, _) in
            let resultDictionary = result as? NSDictionary
            let jsonString = resultDictionary?.toJsonString()
            self.userResourceData = UserResourceData(json: jsonString)
            
            let userResourceDataWork = self.userResourceData.work?[0]
            let userResourceDataWorkPositionName = userResourceDataWork?.position?.name
            let userResourceDataWorkEmployerName = userResourceDataWork?.employer?.name
            self.employerNameLabel.text = String(format:"%@ %ที่ %@", userResourceDataWorkPositionName!, userResourceDataWorkEmployerName!)
            
            let dateStringFormUserResourceDataWorkStartDate = userResourceDataWork?.start_date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateStringFormUserResourceDataWorkStartDate!)
            dateFormatter.dateFormat = "yyyy"
            let dateString = dateFormatter.string(from: date!)
            self.yearWorkedLabel.text = String(format:"%@ %ถึงปัจจุบัน", dateString)
            
            let userResourceDataLocal = self.userResourceData.location?.name
            self.locationLabel.text = String(format:"%อาศัยอยู่ที่ %@", userResourceDataLocal!)
            
            self.fromLocationLabel.text = String(format:"%จาก %@", userResourceDataLocal!)
            
            let userResourceDataEducationConcentrationName  = self.userResourceData.education?[2].concentration?[0].name
            let userResourceDataEducationSchoolName = self.userResourceData.education?[2].school?.name
            self.schoolNameLabel.text = String(format:"%เรียน %@ %ที่ %@",userResourceDataEducationConcentrationName!, userResourceDataEducationSchoolName!)
            
            let userResourceDataEducationSchoolName0 = self.userResourceData.education?[0].school?.name
            let userResourceDataEducationSchoolName1 = self.userResourceData.education?[1].school?.name
            self.previousStudyLabel.text = String(format:"%ก่อนหน้า: %@ %และ %@", userResourceDataEducationSchoolName0!, userResourceDataEducationSchoolName1!)
            
            let userResourceDataRelationShip = self.userResourceData.relationship_status
            self.ralationshipLabel.text = userResourceDataRelationShip
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
