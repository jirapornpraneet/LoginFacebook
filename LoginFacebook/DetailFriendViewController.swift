//
//  DetailFriendViewController.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 8/2/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import SDWebImage

class DetailFriendViewController: UIViewController {
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    
    var getName = String()
    var getPictureDataURL = String()
    var getGender = String()
    var getBirthDay = String()
    var getCoverImage = String()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        imgImage.layer.masksToBounds = true
        imgImage.layer.cornerRadius = 4
        imgImage.layer.borderWidth = 2
        imgImage.layer.borderColor = UIColor.white.cgColor
        lblName.text! = getName
        imgImage.sd_setImage(with: URL(string: (getPictureDataURL)), completed: nil)
        birthdayLabel.text? = getBirthDay
        genderLabel.text? = getGender
        coverImage.sd_setImage(with: URL(string: (getCoverImage)), completed: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
