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
        var url = String(format:"https://graph.facebook.com/v2.10/me/friends?fields=name,picture.type(large),birthday,gender,cover,education,hometown,posts{message,full_picture,created_time,place,reactions.limit(100){name,pic_large,type,link},comments{comment_count,message,from,created_time,comments{message,created_time,from}}}&access_token=EAACEdEose0cBANhQHR5dSPKMYZBx0uVQb2PrvRrD5KmpeKXT3aeY0FpTARZCyeDXdsMFTFLLIwTsnkp5YSZCooxuDgSrfZCNRe61kL5ipODCPGc5uMudrW3ApSlE3CD6slRfyINcZB1r4qXNcOsZCb0W7A5SjHAe7J4n9G0hzZCqWedG39mTZBmQfkoctU4jWxdXBQ2wpE7QlQZDZD")
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
        let cellData = userResource.data?[indexPath.row]
        
        cellFriendsCollectionView.nameLabel.text = String(format: "%@", (cellData?.name)!)
        let thumborProfileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (cellData?.picture?.data?.url)!, width: 300, height: 300)
        cellFriendsCollectionView.profileImageView.sd_setImage(with: thumborProfileImageUrl, completed:nil)
        
        return cellFriendsCollectionView
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let MainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let cellDetailFriendsView = MainStoryboard.instantiateViewController(withIdentifier: "DetailFriendViewController") as! DetailFriendViewController
        
        let cellData = userResource.data?[indexPath.row]
        cellDetailFriendsView.getDataProfileImageUrl = (cellData?.picture?.data?.url)!
        cellDetailFriendsView.getDataName = String(format: "%@", (cellData?.name)!)
        cellDetailFriendsView.getDataCoverImageUrl = (cellData?.cover?.source)!
        
        let cellDataBirthDay = cellData?.birthday
        if cellDataBirthDay == "" {
            cellDetailFriendsView.getDataBirthDay = ""
        } else {
            cellDetailFriendsView.getDataBirthDay = String(format: "%วันเกิด : %@", (cellData?.birthday)!)
        }
        
        let cellDataGender = cellData?.gender
        if cellDataGender == "" {
            cellDetailFriendsView.getDataGender = ""
        } else {
            cellDetailFriendsView.getDataGender = String(format: "%เพศ : %@", (cellData?.gender)!)
        }
        
        let cellDataEducation = cellData?.education
        if cellDataEducation! == [] {
            cellDetailFriendsView.getDataEducation = ""
            cellDetailFriendsView.getDataEducationImage = UIImage(named: "nil.png")!
        } else {
            cellDetailFriendsView.getDataEducation = String(format: "เคยศึกษาที่  %@ ", (cellData?.education?[0].school?.name)!)
            cellDetailFriendsView.getDataEducationImage = UIImage(named: "iconEducation.png")!
        }
        
        let cellDataHomeTown = cellData?.hometown?.name
        if cellDataHomeTown == nil {
            cellDetailFriendsView.getDataHometown = ""
            cellDetailFriendsView.getDataHometownImage = UIImage(named: "nil.png")!
        } else {
            cellDetailFriendsView.getDataHometown = String(format: "%อาศัยอยู่ที่  %@ ", (cellData?.hometown?.name)!)
            cellDetailFriendsView.getDataHometownImage = UIImage(named: "iconHometown.png")!
        }
        
        let cellDataPostsCount = cellData?.posts?.data?.count
        if cellDataPostsCount == nil {
            return
        }
        
        cellDetailFriendsView.getDataPostsCount = ((cellDataPostsCount))!
        
        let cellDataPosts = cellData?.posts?.data
        cellDetailFriendsView.getDataPosts = cellDataPosts!
        
        self.navigationController?.pushViewController(cellDetailFriendsView, animated: true)
    }
}
