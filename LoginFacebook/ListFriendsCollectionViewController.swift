//
//  CollectionViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 8/1/2560 BE.
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

private let reuseIdentifier = "Cell"

class FriendsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileimageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}

class ListFriendsCollectionViewController: UICollectionViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 30, bottom: 10, right: 30)
        layout.itemSize = CGSize(width: 110, height: 110)
        self.collectionView?.collectionViewLayout = layout
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
       
        getDataFriends()
    }
    
    var getJson = JSON([String: Any]())
    var friendsResource: FriendsResource! = nil
    
    func getDataFriends() {
        var url = String(format:"https://graph.facebook.com/me/friends?fields=name,picture.type(large),birthday,gender,cover,education,hometown,posts{message,full_picture,created_time,place}&access_token=EAACEdEose0cBAO4kUxO30cAuVQebq0vb98dB6oVRdSegA7UCdOgZC4NVyolepsW82FgKG9n8RZCF2RXmT8z1F92TQc8kvCIRd0Y5hZA5K1WNiojNhgQIMOtHBhWhkfdPByDERpI1k3ZC69d3tBsZB544ANyuE75et79ZCtQIXbpxhISZCu4XozYn2QIJ6LxeCIa15oejHRnywZDZD")
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(url, method: .get).validate().responseString { response in
            print(response)
            switch response.result {
            case .success(let value):
                self.friendsResource  = FriendsResource(json: value)
                self.collectionView?.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  friendsResource != nil {
            return friendsResource.data!.count
        } else {
            return 0
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let friendsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! FriendsCollectionViewCell
        let cellData = friendsResource.data?[indexPath.row]
        friendsCollectionViewCell.nameLabel.text = String(format: "%@", (cellData?.name)!)
        friendsCollectionViewCell.profileimageView.sd_setImage(with: URL(string: (cellData?.picture?.data?.url)!), completed: nil)
        return friendsCollectionViewCell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let MainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailFrienCell = MainStoryboard.instantiateViewController(withIdentifier: "DetailFriendViewController") as! DetailFriendViewController
        
        let cellData = friendsResource.data?[indexPath.row]
        detailFrienCell.getPictureDataURL = (cellData?.picture?.data?.url)!
        detailFrienCell.getName = String(format: "%@", (cellData?.name)!)
        detailFrienCell.getCoverImage = (cellData?.cover?.source)!
        
        let cellBirthDay = cellData?.birthday
        if cellBirthDay == "" {
             detailFrienCell.getBirthDay = ""
        } else {
             detailFrienCell.getBirthDay = String(format: "%วันเกิด : %@", (cellData?.birthday)!)
        }
        
        let cellGender = cellData?.gender
        if cellGender == "" {
            detailFrienCell.getGender = ""
        } else {
            detailFrienCell.getGender = String(format: "%เพศ : %@", (cellData?.gender)!)
        }
        
        let cellEducation = cellData?.education
        if cellEducation! == [] {
            detailFrienCell.getEducation = ""
            detailFrienCell.getEducationImage = UIImage(named: "nil.png")!
        } else {
            detailFrienCell.getEducation = String(format: "เคยศึกษาที่  %@ ", (cellData?.education?[0].school?.name)!)
            detailFrienCell.getEducationImage = UIImage(named: "iconEducation.png")!
        }
        
        let cellHomeTown = cellData?.hometown?.name
        if cellHomeTown == nil {
            detailFrienCell.getHometown = ""
            detailFrienCell.getHometownImage = UIImage(named: "nil.png")!
        } else {
            detailFrienCell.getHometown = String(format: "%อาศัยอยู่ที่  %@ ", (cellData?.hometown?.name)!)
            detailFrienCell.getHometownImage = UIImage(named: "iconHometown.png")!
        }
        
        let cellCount = cellData?.posts?.data?.count
        if cellCount == nil {
            return
        }
        detailFrienCell.getCountPostFriends = ((cellCount))!
        let cellDataPost = cellData?.posts?.data
        detailFrienCell.getPostsIndexPath = cellDataPost!
        self.navigationController?.pushViewController(detailFrienCell, animated: true)
    }
}
