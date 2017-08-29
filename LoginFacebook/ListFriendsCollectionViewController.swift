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

class ListFriendsCollectionViewController: UICollectionViewController {
   
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
        var url = String(format:"https://graph.facebook.com/me/friends?fields=name,picture.type(large),birthday,gender,cover,education,hometown,posts{message,full_picture,created_time,place}&access_token=EAACEdEose0cBAPC00xpv3gCjKU6ouTvdpeftq6ZBG56Rnpe2OQjeZAjKbYZBKj0vbj5XDUE3ZB851tOcXVPL9DdVCAuFK5TRpNIalvEDYjflNJ3lCS5waNAIeGfNUTUR1s9T7m4g4N08ZBrKe1o69qog77lBx5HYl5zOmVYu4gjz83SDvXoEiFHbBSsOAVGtWqSpq3rCjHAZDZD")
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
        
        let userResourceData = userResource.data?[indexPath.row]
        cellDetailFriendsView.getUserResourceDataProfileImageUrl = (userResourceData?.picture?.data?.url)!
        cellDetailFriendsView.getUserResourceDataName = String(format: "%@", (userResourceData?.name)!)
        cellDetailFriendsView.getUserResourceDataCoverImageUrl = (userResourceData?.cover?.source)!
        
        let userResourceDataBirthDay = userResourceData?.birthday
        if userResourceDataBirthDay == "" {
             cellDetailFriendsView.getUserResourceDataBirthDay = ""
        } else {
            cellDetailFriendsView.getUserResourceDataBirthDay = String(format: "%วันเกิด : %@", (userResourceData?.birthday)!)
        }
        
        let userResourceDataGender = userResourceData?.gender
        if userResourceDataGender == "" {
            cellDetailFriendsView.getUserResourceDataGender = ""
        } else {
            cellDetailFriendsView.getUserResourceDataGender = String(format: "%เพศ : %@", (userResourceData?.gender)!)
        }
        
        let userResourceDataEducation = userResourceData?.education
        if userResourceDataEducation! == [] {
            cellDetailFriendsView.getUserResourceDataEducation = ""
            cellDetailFriendsView.getUserResourceDataEducationImage = UIImage(named: "nil.png")!
        } else {
            cellDetailFriendsView.getUserResourceDataEducation = String(format: "เคยศึกษาที่  %@ ", (userResourceData?.education?[0].school?.name)!)
            cellDetailFriendsView.getUserResourceDataEducationImage = UIImage(named: "iconEducation.png")!
        }
        
        let userResourceDataHomeTown = userResourceData?.hometown?.name
        if userResourceDataHomeTown == nil {
            cellDetailFriendsView.getUserResourceDataHometown = ""
            cellDetailFriendsView.getUserResourceDataHometownImage = UIImage(named: "nil.png")!
        } else {
            cellDetailFriendsView.getUserResourceDataHometown = String(format: "%อาศัยอยู่ที่  %@ ", (userResourceData?.hometown?.name)!)
            cellDetailFriendsView.getUserResourceDataHometownImage = UIImage(named: "iconHometown.png")!
        }
        
        let userResourceDataPostsDataCount = userResourceData?.posts?.data?.count
        if userResourceDataPostsDataCount == nil {
            return
        }
        
        cellDetailFriendsView.getUserResourceDataPostsDataCount = ((userResourceDataPostsDataCount))!
        
        let userResourceDataPostsData = userResourceData?.posts?.data
        cellDetailFriendsView.getUserResourceDataPostsData = userResourceDataPostsData!
        
        self.navigationController?.pushViewController(cellDetailFriendsView, animated: true)
    }
}
