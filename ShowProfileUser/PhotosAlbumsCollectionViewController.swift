//
//  PhotosAlbumsViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 8/18/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photosAlbumsImageView: UIImageView!
}

class PhotosAlbumsCollectionViewController: UICollectionViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("getCount",getCount)
        if  getCount != nil {
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
        
        let imageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (cellData.picture), width: 600, height: 600)
        cell.photosAlbumsImageView.sd_setImage(with: imageUrl, completed:nil)
        
        
        
       
        
        return cell
    }


}
