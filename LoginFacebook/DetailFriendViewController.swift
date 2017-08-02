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
    
    var getName = String()
    var getPictureDataURL = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text! = getName
        imgImage.sd_setImage(with: URL(string: (getPictureDataURL)), completed: nil)
        print(getPictureDataURL)
////        imgImage.sd_setImage(with: URL(string: (cellData?.picture?.data?.url)!), completed: nil)  = getImageURL
//        
//        self.imageShow.sd_setImage(with: URL(string: (self.userResource.picture?.data?.url)!), completed: nil)
////        cell.imageViewAvatar.sd_setImage(with: URL(string: (cellData?.picture?.data?.url)!), completed: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
