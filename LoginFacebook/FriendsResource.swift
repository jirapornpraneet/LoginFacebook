//
//  FriendsResource.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 8/1/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import Foundation
import EVReflection

class FriendsResource: EVObject {
    var data: [FriendData]? = []
}

class FriendData: EVObject {
    var id: Int = 0
    var name: String = ""
    var picture: PictureData?
}

class PictureData: EVObject {
    var data: PictureDataUrl?
}

class PictureDataUrl: EVObject {
    var url: String = ""
}
