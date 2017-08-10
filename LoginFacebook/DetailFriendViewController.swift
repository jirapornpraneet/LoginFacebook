//
//  DetailFriendViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 8/2/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import SDWebImage
import SKPhotoBrowser

class DetailFriendViewController: UIViewController {
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var hometownLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var educationImage: UIImageView!
    @IBOutlet weak var hometownImage: UIImageView!
    
    var getName = String()
    var getPictureDataURL = String()
    var getGender = String()
    var getBirthDay = String()
    var getCoverImage = String()
    var getEducation = String()
    var getHometown = String()
    var getEducationImage = UIImage()
    var getHometownImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgImage.layer.masksToBounds = true
        imgImage.layer.cornerRadius = 4
        imgImage.layer.borderWidth = 2
        imgImage.layer.borderColor = UIColor.white.cgColor
        
        nameLabel.text! = getName
        imgImage.sd_setImage(with: URL(string: (getPictureDataURL)), completed: nil)
        birthdayLabel.text? = getBirthDay
        genderLabel.text? = getGender
        hometownLabel.text? = getHometown
        educationLabel.text = getEducation
        educationImage.image = getEducationImage
        hometownImage.image = getHometownImage
        coverImage.sd_setImage(with: URL(string: (getCoverImage)), completed: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DetailFriendViewController.ZoomPictureDataURL))
        imgImage.addGestureRecognizer(tap)
        imgImage.isUserInteractionEnabled = true
    }
    
    func ZoomPictureDataURL(){
        // 1. create URL Array
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL(getPictureDataURL)
        photo.shouldCachePhotoURLImage = true // you can use image cache by true(NSCache)
        images.append(photo)
        // 2. create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
