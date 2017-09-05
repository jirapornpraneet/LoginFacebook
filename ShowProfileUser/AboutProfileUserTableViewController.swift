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

class FriendTableViewCell: UITableViewCell {
    @IBOutlet weak var profileFriendImageView: UIImageView!
    @IBOutlet weak var nameFriendLabel: UILabel!
    @IBOutlet weak var friendButton: UIButton!
}

class AboutProfileUserTableViewController: UITableViewController {
    @IBOutlet var tableFriend: UITableView!
    @IBOutlet weak var employerNameLabel: UILabel!
    @IBOutlet weak var yearWorkedLabel: UILabel!
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var previousStudyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var fromLocationLabel: UILabel!
    @IBOutlet weak var ralationshipLabel: UILabel!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserResourceProfile()
        getDataUserResourceFriends()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var userResourceData: UserResourceData! = nil
    
    func fetchUserResourceProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), about, age_range, birthday, gender, cover, hometown, work, education,location,relationship_status"]
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
    
    var userResource: UserResource! = nil
    
    func getDataUserResourceFriends() {
        var url = String(format:"https://graph.facebook.com/me/friends?fields=name,picture.type(large)&access_token=EAACEdEose0cBAGX19F2O5H7jpjsHVg8iDOAFMXFerzC5z7x6XxcqWIVx3q4blVeeskNY8dQsZA8UsQ1FECz387HlvbGyrlY6WNmYbpy9h5rnEqCCJuyeSbzer7ZCH5ZBGwk5np5g7OOZCSzWsRQ9SfIgD7FGMFogPEW9QUS3t7Nhys5MwZBI0S32pzpZAfPLmtnzhQF6wDZBQZDZD")
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(url, method: .get).validate().responseString { response in
            print(response)
            switch response.result {
            case .success(let value):
                self.userResource  = UserResource(json: value)
                
                self.tableFriend.dataSource = self
                self.tableFriend.delegate = self
                
                self.tableFriend.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  userResource != nil {
            return 4
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellFriendTableView = tableView.dequeueReusableCell(withIdentifier: "cellFriendTableView", for: indexPath) as! FriendTableViewCell
        let cellUserResourceData = userResource.data?[indexPath.row]
        
        cellFriendTableView.nameFriendLabel.text = cellUserResourceData?.name
        
        let profileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (cellUserResourceData?.picture?.data?.url)!, width: 300, height: 300)
        cellFriendTableView.profileFriendImageView.sd_setImage(with: profileImageUrl, completed:nil)
        
        cellFriendTableView.friendButton.layer.masksToBounds = true
        cellFriendTableView.friendButton.layer.cornerRadius = 3
        cellFriendTableView.friendButton.layer.borderWidth = 0.5
        cellFriendTableView.friendButton.layer.borderColor = UIColor.gray.cgColor
        
        return cellFriendTableView
    }
}
