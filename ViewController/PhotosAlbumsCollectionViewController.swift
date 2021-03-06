//
//  PhotosAlbumsViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 8/18/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import SKPhotoBrowser

private let reuseIdentifier = "Cell"

class PhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photosAlbumsImageView: UIImageView!
}

class PhotosAlbumsCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let collectionViewListPhotosInAlbums = collectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: 120, height: 120)
        collectionViewListPhotosInAlbums?.collectionViewLayout = layout
        collectionViewListPhotosInAlbums?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionViewListPhotosInAlbums?.delegate = self
        collectionViewListPhotosInAlbums?.dataSource = self
        
        collectionViewListPhotosInAlbums?.reloadData()
    }
    
    func ZoomPhotos(_ sender: AnyObject) {
        let cellDataAlbumsPhotos = setDataAlbumsPhotos[sender.view.tag] as! Data
        var images = [SKPhoto]()
        let photos = SKPhoto.photoWithImageURL((cellDataAlbumsPhotos.picture))
        photos.shouldCachePhotoURLImage = true
        images.append(photos)
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    var setDataAlbumsPhotosCount = Int()
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  setDataAlbumsPhotosCount  != 0 {
            return setDataAlbumsPhotosCount
        } else {
            return 0
        }
    }
    
    var setDataAlbumsPhotos = [NSObject]()
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellPhotosCollectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPhotosCollection", for: indexPath) as! PhotosCollectionViewCell
        let cellDataAlbumsPhotos = setDataAlbumsPhotos[indexPath.row] as! Data
        
        let thumborPictureUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (cellDataAlbumsPhotos.picture), width:  200, height: 200)
        cellPhotosCollectionView.photosAlbumsImageView.sd_setImage(with: thumborPictureUrl, completed:nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PhotosAlbumsCollectionViewController.ZoomPhotos(_:)))
        cellPhotosCollectionView.photosAlbumsImageView.isUserInteractionEnabled = true
        cellPhotosCollectionView.photosAlbumsImageView.tag = indexPath.row
        cellPhotosCollectionView.photosAlbumsImageView.addGestureRecognizer(tapGestureRecognizer)
        
        return cellPhotosCollectionView
    }
    
    
}
