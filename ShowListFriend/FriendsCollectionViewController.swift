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
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}

class FriendsCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let collectionViewListFriends = collectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 30, bottom: 10, right: 30)
        layout.itemSize = CGSize(width: 110, height: 110)
        collectionViewListFriends?.collectionViewLayout = layout
        collectionViewListFriends?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionViewListFriends?.delegate = self
        collectionViewListFriends?.dataSource = self
        
        getDataUserResourceFriends()
    }
    
    var userResource: UserResource! = nil
    
    func getDataUserResourceFriends() {
        var url = String(format:"https://graph.facebook.com/me/friends?fields=name,picture.type(large),birthday,gender,cover,education,hometown,posts{message,full_picture,created_time,place}&access_token=EAACEdEose0cBAD67M1GZCgUH3hEqeTthpaxseEmKATb8XBEQ3sO70qUEZAqZBGo8sBSHdFZBoOYEDmk1jYLdAzNbUBAUTAvcQuWIjZB8zXA8vryIrKfJ9sO9nVzsExPh22q1VCFFwlJ1ZAmNoMCwTRZAYkWzeJpkfFb9M3OylcNu0qWMHArek0JTesa4cAyZC9FuZBaKl6M1UCQZDZD")
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(url, method: .get).validate().responseString { response in
            print(response)
            switch response.result {
            case .success(let value):
                self.userResource  = UserResource(json: value)
                
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
        if  userResource != nil {
            return userResource.data!.count
        } else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellFriendsCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "cellFriendsCollection", for: indexPath) as! FriendsCollectionViewCell
        let cellUserResourceData = userResource.data?[indexPath.row]
        
        cellFriendsCollectionView.nameLabel.text = String(format: "%@", (cellUserResourceData?.name)!)
        let profileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (cellUserResourceData?.picture?.data?.url)!, width: 300, height: 300)
        cellFriendsCollectionView.profileImageView.sd_setImage(with: profileImageUrl, completed:nil)
        
        return cellFriendsCollectionView
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let MainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let cellDetailFriendsView = MainStoryboard.instantiateViewController(withIdentifier: "DetailFriendViewController") as! DetailFriendViewController
        
        let cellUserResourceData = userResource.data?[indexPath.row]
        cellDetailFriendsView.getUserResourceDataProfileImageUrl = (cellUserResourceData?.picture?.data?.url)!
        cellDetailFriendsView.getUserResourceDataName = String(format: "%@", (cellUserResourceData?.name)!)
        cellDetailFriendsView.getUserResourceDataCoverImageUrl = (cellUserResourceData?.cover?.source)!
        
        let cellUserResourceDataBirthDay = cellUserResourceData?.birthday
        if cellUserResourceDataBirthDay == "" {
            cellDetailFriendsView.getUserResourceDataBirthDay = ""
        } else {
            cellDetailFriendsView.getUserResourceDataBirthDay = String(format: "%วันเกิด : %@", (cellUserResourceData?.birthday)!)
        }
        
        let cellUserResourceDataGender = cellUserResourceData?.gender
        if cellUserResourceDataGender == "" {
            cellDetailFriendsView.getUserResourceDataGender = ""
        } else {
            cellDetailFriendsView.getUserResourceDataGender = String(format: "%เพศ : %@", (cellUserResourceData?.gender)!)
        }
        
        let cellUserResourceDataEducation = cellUserResourceData?.education
        if cellUserResourceDataEducation! == [] {
            cellDetailFriendsView.getUserResourceDataEducation = ""
            cellDetailFriendsView.getUserResourceDataEducationImage = UIImage(named: "nil.png")!
        } else {
            cellDetailFriendsView.getUserResourceDataEducation = String(format: "เคยศึกษาที่  %@ ", (cellUserResourceData?.education?[0].school?.name)!)
            cellDetailFriendsView.getUserResourceDataEducationImage = UIImage(named: "iconEducation.png")!
        }
        
        let cellUserResourceDataHomeTown = cellUserResourceData?.hometown?.name
        if cellUserResourceDataHomeTown == nil {
            cellDetailFriendsView.getUserResourceDataHometown = ""
            cellDetailFriendsView.getUserResourceDataHometownImage = UIImage(named: "nil.png")!
        } else {
            cellDetailFriendsView.getUserResourceDataHometown = String(format: "%อาศัยอยู่ที่  %@ ", (cellUserResourceData?.hometown?.name)!)
            cellDetailFriendsView.getUserResourceDataHometownImage = UIImage(named: "iconHometown.png")!
        }
        
        let cellUserResourceDataPostsDataCount = cellUserResourceData?.posts?.data?.count
        if cellUserResourceDataPostsDataCount == nil {
            return
        }
        
        cellDetailFriendsView.getUserResourceDataPostsDataCount = ((cellUserResourceDataPostsDataCount))!
        
        let cellUserResourceDataPostsData = cellUserResourceData?.posts?.data
        cellDetailFriendsView.getUserResourceDataPostsData = cellUserResourceDataPostsData!
        
        self.navigationController?.pushViewController(cellDetailFriendsView, animated: true)
    }
}
