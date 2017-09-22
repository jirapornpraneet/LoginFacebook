//
//  MusicAllCollectionViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 9/21/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MusicAllCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var musicImageView: UIImageView!
    @IBOutlet weak var nameMusicLabel: UILabel!
}

class MusicAllCollectionViewController: UICollectionViewController {
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    var setDataMusicCount = Int()
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  setDataMusicCount != 0 {
            return setDataMusicCount
        } else {
            return 0
        }
    }
    
    var setDataMusic = [NSObject]()
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellMusicAllCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "cellMusicAllCollectionView", for: indexPath) as! MusicAllCollectionViewCell
        let cellDataMusic = setDataMusic[indexPath.row] as! AlbumsDataDetail
        
        cellMusicAllCollectionView.nameMusicLabel.text = cellDataMusic.name

        let thumborPictureMusicImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (cellDataMusic.picture?.data?.url)!, width: 200, height: 200)
        
        cellMusicAllCollectionView.musicImageView.sd_setImage(with: thumborPictureMusicImageUrl, completed: nil)
        
        return cellMusicAllCollectionView
    }
}
