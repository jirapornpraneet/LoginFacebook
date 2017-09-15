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
        var url = String(format:"https://graph.facebook.com/v2.10/me/friends?fields=name,picture.type(large),birthday,gender,cover,education,hometown,posts{message,full_picture,created_time,place,reactions.limit(100){name,pic_large,type,link},comments{comment_count,message,from,created_time,comments{message,created_time,from}}}&access_token=EAACEdEose0cBAOvRyc7kiQmoGFhchcit5JEsqUaryXVIElnfnGyzNVy2QE7FLZCueZA5oDWnsT1ImHgPFfv1NXEip2Fe6wCd6iAjfv8OmJKxRKMVHeudjPhLGnwCYs6bt9vCQLb4JmxQuCxIbLwsw97pMd7rY5YyGJMjI1emxKXe9UjDftkZBd8vFSDFsbB6yvqrMsW6AZDZD")
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(url, method: .get).validate().responseString { response in
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
        let userResourceData = userResource.data?[indexPath.row]
        
        cellFriendsCollectionView.nameLabel.text = String(format: "%@", (userResourceData?.name)!)
        let profileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (userResourceData?.picture?.data?.url)!, width: 300, height: 300)
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
