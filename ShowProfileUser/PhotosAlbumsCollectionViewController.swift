//
//  PhotosAlbumsViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 8/18/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photosAlbumsImageView: UIImageView!
}

class PhotosAlbumsCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: 120, height: 120)
        self.collectionView?.collectionViewLayout = layout
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        self.collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("getCount",getCount)
        if  getCount != 0 {
            return getCount
        } else {
            return 0
        }
    }
    
    var getCount = Int()
    var getIndexPath = [NSObject]()
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosAlbumsCell", for: indexPath) as! PhotosCollectionViewCell
        let cellData = getIndexPath[indexPath.row] as! AlbumsPhotosDataDetail
        print("cellData",cellData)
        print("show",cellData.picture)
        
        let imageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (cellData.picture), width: 120, height: 120)
        cell.photosAlbumsImageView.sd_setImage(with: imageUrl, completed:nil)
        
        return cell
    }


}
