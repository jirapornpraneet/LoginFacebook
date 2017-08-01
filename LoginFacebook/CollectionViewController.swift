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
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 110, height: 110)
        self.collectionView?.collectionViewLayout = layout
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        if  let token = FBSDKAccessToken.current() {
            getToken = token
            print(getToken.tokenString)
            print("Show >>> ",token.tokenString)
        }
        getDataCurrenciesAPI(showToken: getToken)
    }
    
    
    var getJson = JSON([String: Any]())
    func getDataCurrenciesAPI(showToken: FBSDKAccessToken) {
        let url = String(format:"https://graph.facebook.com/me/taggable_friends?fields=name,picture&access_token=%@",showToken.tokenString)
        Alamofire.request(url, method: .get).validate().responseString { response in
            print(response)
            switch response.result {
            case .success(let value):
                self.friendsResource  = FriendsResource(json: value)
                print(value)
                print(self.friendsResource)
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
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }

}
