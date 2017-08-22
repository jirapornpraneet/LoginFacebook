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
       
        getDataFriends()
    }
    
    var userResource: UserResource! = nil
    
    func getDataFriends() {
        var url = String(format:"https://graph.facebook.com/me/friends?fields=name,picture.type(large),birthday,gender,cover,education,hometown,posts{message,full_picture,created_time,place}&access_token=EAACEdEose0cBAE6udEJynSC60SdGAhQWw6Orr0Yyw4m3l2L94WyasBiUmkW5rZCMX7zVykxTqntjX7fe4AlhEp6RNF6NgJF5pb7gLBBmoclvMDZCFjMFryndf2njhTrK5RSNBxB74g5hB1ZB1M0pZAiSBmhZCHnv1CnHuJVZBVeFccEeAnemvN0UAS6kyy37ZC1QJeHTMLTPgZDZD")
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
        let cellData = userResource.data?[indexPath.row]
        
        cellFriendsCollectionView.nameLabel.text = String(format: "%@", (cellData?.name)!)
        let profileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (cellData?.picture?.data?.url)!, width: 300, height: 300)
        cellFriendsCollectionView.profileImageView.sd_setImage(with: profileImageUrl, completed:nil)
        
        return cellFriendsCollectionView
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let MainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let cellDetailFriendsView = MainStoryboard.instantiateViewController(withIdentifier: "DetailFriendViewController") as! DetailFriendViewController
        
        let cellData = userResource.data?[indexPath.row]
        cellDetailFriendsView.getProfileImageUrl = (cellData?.picture?.data?.url)!
        cellDetailFriendsView.getName = String(format: "%@", (cellData?.name)!)
        cellDetailFriendsView.getCoverImageUrl = (cellData?.cover?.source)!
        
        let cellBirthDay = cellData?.birthday
        if cellBirthDay == "" {
             cellDetailFriendsView.getBirthDay = ""
        } else {
            cellDetailFriendsView.getBirthDay = String(format: "%วันเกิด : %@", (cellData?.birthday)!)
        }
        
        let cellGender = cellData?.gender
        if cellGender == "" {
            cellDetailFriendsView.getGender = ""
        } else {
            cellDetailFriendsView.getGender = String(format: "%เพศ : %@", (cellData?.gender)!)
        }
        
        let cellEducation = cellData?.education
        if cellEducation! == [] {
            cellDetailFriendsView.getEducation = ""
            cellDetailFriendsView.getEducationImage = UIImage(named: "nil.png")!
        } else {
            cellDetailFriendsView.getEducation = String(format: "เคยศึกษาที่  %@ ", (cellData?.education?[0].school?.name)!)
            cellDetailFriendsView.getEducationImage = UIImage(named: "iconEducation.png")!
        }
        
        let cellHomeTown = cellData?.hometown?.name
        if cellHomeTown == nil {
            cellDetailFriendsView.getHometown = ""
            cellDetailFriendsView.getHometownImage = UIImage(named: "nil.png")!
        } else {
            cellDetailFriendsView.getHometown = String(format: "%อาศัยอยู่ที่  %@ ", (cellData?.hometown?.name)!)
            cellDetailFriendsView.getHometownImage = UIImage(named: "iconHometown.png")!
        }
        
        let cellPostsDataCount = cellData?.posts?.data?.count
        if cellPostsDataCount == nil {
            return
        }
        
        cellDetailFriendsView.getPostsDataCount = ((cellPostsDataCount))!
        
        let cellPostsData = cellData?.posts?.data
        cellDetailFriendsView.getPostsData = cellPostsData!
        
        self.navigationController?.pushViewController(cellDetailFriendsView, animated: true)
    }
}
