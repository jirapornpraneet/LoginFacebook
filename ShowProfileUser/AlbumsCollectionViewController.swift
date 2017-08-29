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

class AlbumsDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoAlbumsImageView: UIImageView!
    @IBOutlet weak var nameAlbumsLabel: UILabel!
}

class AlbumsCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let collectionViewListAlbums = collectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: 120, height: 120)
        collectionViewListAlbums?.collectionViewLayout = layout
        collectionViewListAlbums?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionViewListAlbums?.delegate = self
        collectionViewListAlbums?.dataSource = self
        
        fetchUserResourceProfile()
        
    }
    
    var userResourceData: UserResourceData! = nil
    
    func fetchUserResourceProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), about, age_range, birthday, gender, cover, hometown, work, education, posts{created_time, message, full_picture, place}, albums{created_time, count, description, name, photos.limit(10){picture,name}}"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (_, result, _) in
            let dic = result as? NSDictionary
            let jsonString = dic?.toJsonString()
            self.userResourceData = UserResourceData(json: jsonString)
            
            self.collectionView?.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  userResourceData != nil {
            return (userResourceData.albums?.data?.count)!
            
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellAlbumsDetailCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "cellAlbumsDetailCollection", for: indexPath) as! AlbumsDetailCollectionViewCell
        let cellUserResourceAlbumsData = userResourceData?.albums?.data?[indexPath.row]

        cellAlbumsDetailCollectionView.nameAlbumsLabel.text = cellUserResourceAlbumsData?.name

        let pictureUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (cellUserResourceAlbumsData?.photos?.data?[0].picture)!, width: 150, height: 150)
        cellAlbumsDetailCollectionView.photoAlbumsImageView.sd_setImage(with:  pictureUrl, completed:nil)

        return cellAlbumsDetailCollectionView
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let MainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let cellPhotosAlbumsCollectionView = MainStoryboard.instantiateViewController(withIdentifier: "PhotosAlbumsCollection") as! PhotosAlbumsCollectionViewController
        
        let userResourceAlbumsData = userResourceData?.albums?.data?[indexPath.row]
   
        let getUserResourceAlbumsPhotosDataCount = userResourceAlbumsData?.photos?.data?.count
        if getUserResourceAlbumsPhotosDataCount  == nil {
            return
        }
        cellPhotosAlbumsCollectionView.setUserResourceAlbumsPhotosDataCount  = ((getUserResourceAlbumsPhotosDataCount))!
        
        let getUserResourceAlbumsPhotosData = userResourceAlbumsData?.photos?.data
        cellPhotosAlbumsCollectionView.setUserResourceAlbumsPhotosData = getUserResourceAlbumsPhotosData!
        
        self.navigationController?.pushViewController(cellPhotosAlbumsCollectionView, animated: true)
    }

    
    
}
