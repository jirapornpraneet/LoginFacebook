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
    var gender:String = ""
    var birthday:String = ""
    var cover: CoverData?
    var education:[EducationFriendsData]? = []
    var hometown:HomeTownFriendsData?
    var posts:PostsFriendsData?
}

class PostsFriendsData:EVObject{
    var data:[PostsFriendsDataDetail]? = []
}

class PostsFriendsDataDetail:EVObject{
    var message:String = ""
    var full_picture:String = ""
    var id:Int = 0
    var created_time:String = ""
    var place:PostsPlaceData?
}

class PostsPlaceData: EVObject {
    var id:Int = 0
    var name:String = ""
    var location:PostsPlaceDataLocation?
}

class PostsPlaceDataLocation: EVObject {
    var city:String = ""
    var country:String = ""
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var street:String = ""
    var zip:Int = 0
}

class HomeTownFriendsData:EVObject{
    var id:Int = 0
    var name:String = ""
}

class EducationFriendsData:EVObject {
    var school:SchoolFriendsData?
    var type:String = ""
    var year:YearFriendsData?
    var id:Int = 0
    var concentration:[ConcentrationFriendsData]? = []
}

class SchoolFriendsData:EVObject{
    var id:Int = 0
    var name:String = ""
    
}

class ConcentrationFriendsData:EVObject{
    var id:Int = 0
    var name:String = ""
    
}

class YearFriendsData:EVObject{
    var id:Int = 0
    var name:String = ""
}

class CoverData:EVObject {
    var id:Int = 0
    var offset_x: Int = 0
    var offset_y:Int = 0
    var source:String = ""
}

class PictureData: EVObject {
    var data: PictureDataUrl?
}

class PictureDataUrl: EVObject {
    var url: String = ""
}
