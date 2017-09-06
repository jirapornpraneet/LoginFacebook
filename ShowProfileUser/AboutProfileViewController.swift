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

class MusicTableViewCell: UITableViewCell {
    @IBOutlet weak var musicImageView: UIImageView!
    @IBOutlet weak var nameMusicLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
}

class AboutProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var employerNameLabel: UILabel!
    @IBOutlet weak var yearWorkedLabel: UILabel!
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var previousStudyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var fromLocationLabel: UILabel!
    @IBOutlet weak var ralationshipLabel: UILabel!
    //MARK: TableView
    @IBOutlet weak var tableFriends: UITableView!
    @IBOutlet weak var tableMusic: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserResourceProfile()
        getDataUserResourceFriends()
    }
    
    var userResourceData: UserResourceData! = nil
    
    func fetchUserResourceProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), about, age_range, birthday, gender, cover, hometown, work, education,location,relationship_status, music{name,picture{url},category},movies{global_brand_page_name,picture{url}}"]
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
            
            self.tableMusic.dataSource = self
            self.tableMusic.delegate = self
            self.tableMusic.reloadData()
        }
    }
    
    var userResource: UserResource! = nil
    
    func getDataUserResourceFriends() {
        var url = String(format:"https://graph.facebook.com/me/friends?fields=name,picture.type(large)&access_token=EAACEdEose0cBAPXxIguLuHs0Gfcy1K5RZBWaYZCmIZBLEBZCJLN2YwlkruWce8Yx31nYUMZAwlgXVb59uG7OsyPgrg4tYmAt6T2EI0hZBy172FZB2F0wDUpCRaqp6sCoWkDARXXWZAgMeJbD0kPoPGRRGeMGMTjy0o6nwYNd64TeaDU8iZCa7SnCGjMJNZBYghgATBZAtmBZB75ZBNAZDZD")
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(url, method: .get).validate().responseString { response in
            print(response)
            switch response.result {
            case .success(let value):
                self.userResource  = UserResource(json: value)
                
                self.tableFriends.dataSource = self
                self.tableFriends.delegate = self
                self.tableFriends.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableFriends {
            return 4
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableFriends {
            let cellFriendTableView = tableView.dequeueReusableCell(withIdentifier: "cellFriendTableView", for: indexPath) as! FriendsTableViewCell
            let cellUserResourceData = userResource.data?[indexPath.row]
            
            cellFriendTableView.nameFriendsLabel.text = cellUserResourceData?.name
            
            let profileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (cellUserResourceData?.picture?.data?.url)!, width: 300, height: 300)
            cellFriendTableView.profileFriendsImageView.sd_setImage(with: profileImageUrl, completed:nil)
            
            cellFriendTableView.friendButton.layer.masksToBounds = true
            cellFriendTableView.friendButton.layer.cornerRadius = 3
            cellFriendTableView.friendButton.layer.borderWidth = 0.5
            cellFriendTableView.friendButton.layer.borderColor = UIColor.gray.cgColor
            
            return cellFriendTableView
        } else {
            let cellMusicTableView = tableView.dequeueReusableCell(withIdentifier: "cellMusicTableView", for: indexPath) as! MusicTableViewCell
            let cellUserResourceData = userResourceData.music?.data?[indexPath.row]
            
            cellMusicTableView.nameMusicLabel.text = cellUserResourceData?.name
            cellMusicTableView.categoryLabel.text = cellUserResourceData?.category
            
             let pictureMusicImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (cellUserResourceData?.picture?.data?.url)!, width: 300, height: 300)
            cellMusicTableView.musicImageView.sd_setImage(with: pictureMusicImageUrl, completed: nil)
            
            return cellMusicTableView
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
