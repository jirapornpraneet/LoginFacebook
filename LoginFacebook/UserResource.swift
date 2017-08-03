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
    var about:String = ""
    var age_range:AgeRangeData?
    var birthday:String = ""
    var gender:String = ""
    var cover:CoverUserData?
    var hometown:HomeTownData?
    var work:[WorkData]? = []
    var education:[EducationData]? = []
    var posts:PostsData?
}

class PostsData:EVObject{
    var data:[PostsUserData]? = []
}

class PostsUserData:EVObject{
    var message:String = ""
    var picture:String = ""
    var id:Int = 0
}

class WorkData: EVObject {
    var end_date:String = ""
    var employer:EmployerData?
    var location:LocationData?
    var position:PositionData?
    var start_date:String = ""
    var id:Int = 0
}

class PositionData: EVObject {
    var id:Int = 0
    var name:String = ""
}

class LocationData:EVObject{
    var id:Int = 0
    var name:String = ""
}

class EmployerData: EVObject {
    var id:Int = 0
    var name:String = ""
}

class EducationData: EVObject {
    var school:SchoolData?
    var type:String = ""
    var year:YearData?
    var id:Int = 0
    var concentration:[ConcentrationData]? = []
}

class ConcentrationData: EVObject {
    var id:Int = 0
    var name:String = ""
}

class YearData:EVObject{
    var id:Int = 0
    var name:String = ""
}

class SchoolData: EVObject {
    var id:Int = 0
    var name:String = ""
}

class HomeTownData:EVObject{
    var id: Int = 0
    var name:String = ""
}
class CoverUserData:EVObject{
    var id:Int = 0
    var offset_x:String = ""
    var offset_y:String = ""
    var source:String = ""
}

class AgeRangeData: EVObject {
    var min:String = ""
}

class PictureUserData: EVObject {
    var data: PictureUserDataUrl?
}

class PictureUserDataUrl: EVObject {
    var is_silhouette = ""
    var url: String = ""
}
