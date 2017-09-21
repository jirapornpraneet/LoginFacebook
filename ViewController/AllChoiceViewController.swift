//
//  AllChoiceViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 9/21/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit
import SDWebImage
import Alamofire
import SwiftyJSON
import SKPhotoBrowser

class GamesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gamesImageView: UIImageView!
    @IBOutlet weak var nameGamesLabel: UILabel!
}

class AllChoiceViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var collectionviewMusic: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserResourceProfile()
        
        profileImageButton.layer.masksToBounds = true
        profileImageButton.layer.cornerRadius = 25
        profileImageButton.layer.borderWidth = 2
        profileImageButton.layer.borderColor = UIColor.white.cgColor
        
        collectionviewMusic.delegate = self
        collectionviewMusic.dataSource = self
    }
    
    var userResourceData: UserResourceData! = nil
    
    func fetchUserResourceProfile() {
        let parameters = ["fields": "first_name, last_name, picture.type(large),music{name,picture{url}}"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (_, result, _) in
            let resultDictionary = result as? NSDictionary
            let jsonString = resultDictionary?.toJsonString()
            self.userResourceData = UserResourceData(json: jsonString)
            let userResourceDataName = self.userResourceData.first_name + "  " + self.userResourceData.last_name
            self.nameLabel.text = userResourceDataName
            
            let thumborProfileUpdateImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (self.userResourceData.picture?.data?.url)!, width: 200, height: 200)
            self.profileImageButton.sd_setBackgroundImage(with: thumborProfileUpdateImageUrl, for: .normal, completed: nil)
            
            self.collectionviewMusic.reloadData()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  userResourceData != nil {
            return 4
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellGamesCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "cellGamesCollectionView", for: indexPath) as! GamesCollectionViewCell
        
        let cellDataGames = userResourceData.games?.data?[indexPath.row]
        
        cellGamesCollectionView.nameGamesLabel.text = cellDataGames?.name

//        let thumborPictureGamesImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (cellDataGames?.picture?.data?.url)!, width: 200, height: 200)
//        cellGamesCollectionView.gamesImageView.sd_setImage(with: thumborPictureGamesImageUrl, completed: nil)
        return cellGamesCollectionView
        
    }

    
}
