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
    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}

class CollectionViewController: UICollectionViewController {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var getToken:FBSDKAccessToken!
    var friendsResource: FriendsResource! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 30, bottom: 10, right: 30)
        layout.itemSize = CGSize(width: 110, height: 110)
        self.collectionView?.collectionViewLayout = layout
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        if  let token = FBSDKAccessToken.current() {
            getToken = token
            print(getToken.tokenString)
            print("Show >>> ",token.tokenString)
            getDataCurrenciesAPI()
        }
        getDataCurrenciesAPI()
    }
    
    var getJson = JSON([String: Any]())
    func getDataCurrenciesAPI() {
        var url = String(format:"https://graph.facebook.com/me/friends?fields=name,picture.type(large),birthday,gender,cover,education,hometown,posts{message,full_picture,created_time,place}&access_token=EAACEdEose0cBAC1CSwP1qjc8HYW8krIMYTcBtjEEnlIVDcx2nn4Em9xnywPSVoOnDLjK5YdHX9p3xAfrr3YB4AbHS1qk1ptZBPnWa4OwZAAujdDU5GdMJsa96SZAICbx81GwPE9DtGSUxSbyRrqPYZBZBqmfZBJtVUPcYHnmLM5ZAiHri1aBGHZBbDPBTHOvudcriBvmyo06XQZDZD")
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print("URL",url)
//        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        Alamofire.request(url, method: .get).validate().responseString { response in
            print(response)
            switch response.result {
            case .success(let value):
                self.friendsResource  = FriendsResource(json: value)
                print("FriendsResource :",self.friendsResource)
//                print(value)
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
        if ((friendsResource) != nil) {
            return friendsResource.data!.count
        } else {
            return 0
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! FriendsCollectionViewCell
        let cellData = friendsResource.data?[indexPath.row]
        cell.nameLabel.text = String(format: "%@", (cellData?.name)!)
        cell.imageViewAvatar.sd_setImage(with: URL(string: (cellData?.picture?.data?.url)!), completed: nil)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let cellCollectionView = MainStoryboard.instantiateViewController(withIdentifier: "DetailFriendViewController") as! DetailFriendViewController
        
        let cellData = friendsResource.data?[indexPath.row]
        
        
        cellCollectionView.getPictureDataURL = (cellData?.picture?.data?.url)!
        cellCollectionView.getName = String(format: "%@", (cellData?.name)!)
        cellCollectionView.getCoverImage = (cellData?.cover?.source)!
   
        let cellBirthDay = cellData?.birthday
        if cellBirthDay == "" {
             cellCollectionView.getBirthDay = ""
        } else {
             cellCollectionView.getBirthDay = String(format: "%วันเกิด : %@", (cellData?.birthday)!)
        }
       
        let cellGender = cellData?.gender
        if cellGender == "" {
            cellCollectionView.getGender = ""
        } else {
            cellCollectionView.getGender = String(format: "%เพศ : %@", (cellData?.gender)!)
        }
        
        let cellEducation = cellData?.education
        if cellEducation! == [] {
            cellCollectionView.getEducation = ""
            cellCollectionView.getEducationImage = UIImage(named: "nil.png")!
        }else{
            cellCollectionView.getEducation = String(format: "เคยศึกษาที่  %@ ",(cellData?.education?[0].school?.name)!)
            cellCollectionView.getEducationImage = UIImage(named: "iconEducation.png")!
        }
        
        let cellHomeTown = cellData?.hometown?.name
        if cellHomeTown == nil {
            cellCollectionView.getHometown = ""
            cellCollectionView.getHometownImage = UIImage(named: "nil.png")!
        }else {
            cellCollectionView.getHometown = String(format: "%อาศัยอยู่ที่  %@ ",(cellData?.hometown?.name)!)
            cellCollectionView.getHometownImage = UIImage(named: "iconHometown.png")!
        }
       
//        let cellResource = friendsResource.data
//        cellCollectionView.getFriendsResource = (cellResource)!
        
        let cellCount = cellData?.posts?.data?.count
        cellCollectionView.getCountPostFriends = (cellCount)!
       
        let cellDataPost = cellData?.posts?.data
        print("cellDataPost :",cellDataPost?[0])
        cellCollectionView.getPostsIndexPath = cellDataPost!
                
//        cellCollectionView.getCreatedTime = (cellDataPost?.created_time)!
//        cellCollectionView.getMeaasge = (cellDataPost?.message)!
//        let myLocale = Locale(identifier: "th_TH")
//        let dateStringFormResource = cellDataPost?.created_time
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        let date = dateFormatter.date(from: dateStringFormResource!)
//        dateFormatter.locale = myLocale
//        dateFormatter.dateFormat = "EEEE" + " เวลา " + "hh:mm"
//        let dateString = dateFormatter.string(from: date!)
        
//        cellCollectionView.getCreatedTime = dateString
//        cellCollectionView.getFullPicture = (cellDataPost?.full_picture)!
//        cellCollectionView.getPlace = (cellDataPost?.place?.name)!
        
        self.navigationController?.pushViewController(cellCollectionView, animated: true)
    }
}
