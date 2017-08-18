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
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: 120, height: 120)
        self.collectionView?.collectionViewLayout = layout
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        fetchProfile()
    }
    
    var userResourceData: UserResourceData! = nil
    
    func fetchProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), about, age_range, birthday, gender, cover, hometown, work, education, posts{created_time, message, full_picture, place}, albums{created_time, count, description, name, photos.limit(1){picture,name}}"]
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! AlbumsDetailCollectionViewCell
        let cellData = userResourceData?.albums?.data?[indexPath.row]

        cell.nameAlbumsLabel.text = cellData?.name
        
        let cellPhotos = cellData?.photos?.data?[0].picture
        let imageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (cellPhotos)!, width: 150, height: 150)
        cell.photoAlbumsImageView.sd_setImage(with: imageUrl, completed:nil)

        return cell
    }
}
