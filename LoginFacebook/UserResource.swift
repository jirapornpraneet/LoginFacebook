//
//  UserResource.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 8/1/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import Foundation
import EVReflection


class UserResource: EVObject {
    var id: Int = 0
    var email:String = ""
    var first_name: String = ""
    var last_name: String = ""
    var picture: PictureUserData?
}

class PictureUserData: EVObject {
    var data: PictureUserDataUrl?
}

class PictureUserDataUrl: EVObject {
    var is_silhouette = ""
    var url: String = ""
}
