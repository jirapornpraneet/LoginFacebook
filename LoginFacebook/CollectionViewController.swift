//
//  CollectionViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 8/1/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 90)
        self.collectionView?.collectionViewLayout = layout
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        configureCell(cell, forItemAtIndexPath: indexPath)
        
        cell.layer.borderWidth=1.0;
        cell.layer.borderColor=UIColor.blue.cgColor;
        
        return cell
    }
    
    func configureCell(_ cell: UICollectionViewCell, forItemAtIndexPath: IndexPath) {
        cell.backgroundColor = UIColor.black
        //3
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: layout.itemSize.width, height: layout.itemSize.height))
        imgView.contentMode = .scaleAspectFit
        if forItemAtIndexPath.row%3 == 0 {
            imgView.image = UIImage(named: "img3.jpg")
        } else if forItemAtIndexPath.row%2 == 0 {
            imgView.image = UIImage(named: "img2.jpg")
        } else {
            imgView.image = UIImage(named: "img1.jpg")
        }
        cell.addSubview(imgView)
        
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "collectionCell", for: indexPath) as UICollectionReusableView
        return view
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }

}
