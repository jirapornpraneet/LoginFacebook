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
    var data: [UserResourceData]? = []
}

class UserResourceData: EVObject {
    var id: Int = 0
    var email: String = ""
    var first_name: String = ""
    var last_name: String = ""
    var name: String = "" 
    var picture: PictureUserData?
    var about: String = ""
    var age_range: AgeRangeData?
    var birthday: String = ""
    var gender: String = ""
    var cover: CoverUserData?
    var hometown: HomeTownData?
    var work: [WorkData]? = []
    var education: [EducationData]? = []
    var posts: PostsData?
    var albums: AlbumsData?
    var location: LocationData?
    var relationship_status: String = ""
    var music: AlbumsData?
}

class AlbumsData: EVObject {
    var data: [AlbumsDataDetail]? = []
}

class AlbumsDataDetail: EVObject {
    var created_time: String = ""
    var count: Int = 0
    var name: String = ""
    var photos: AlbumsPhotosData?
    var picture: PictureUserData?
    var category: String = ""
}

class AlbumsPhotosData: EVObject {
    var data: [AlbumsPhotosDataDetail]? = []
}

class AlbumsPhotosDataDetail: EVObject {
    var picture: String = ""
    var name: String =  ""
    var id: Int = 0
}

class PostsData: EVObject {
    var data: [PostsDataDetail]? = []
}

class PostsDataDetail: EVObject {
    var message: String = ""
    var full_picture: String = ""
    var id: Int = 0
    var created_time: String = ""
    var place: PlaceData?
    var reactions: ReactionsData?
    var comments: CommentsData?
}

class CommentsData: EVObject {
    var data: [CommentsDataDetail]? = []
}

class CommentsDataDetail: EVObject {
    var comment_count: Int = 0
    var message: String = ""
    var from: FromData?
    var created_time: String = ""
    var comments: CommentsData?
}

class FromData: EVObject {
    var name: String = ""
}

class ReactionsData: EVObject {
    var data: [ReactionsDataDetail]? = []
}

class ReactionsDataDetail: EVObject {
    var name: String = ""
    var link: String = ""
    var pic_large: String = ""
    var type: String = "" 
}

class PlaceData: EVObject {
    var id: Int = 0
    var name: String = ""
    var location: PlaceDataLocation?
}

class PlaceDataLocation: EVObject {
    var city: String = ""
    var country: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var street: String = ""
    var zip: Int = 0
}

class WorkData: EVObject {
    var end_date: String = ""
    var employer: EmployerData?
    var location: LocationData?
    var position: PositionData?
    var start_date: String = ""
    var id: Int = 0
}

class PositionData: EVObject {
    var id: Int = 0
    var name: String = ""
}

class LocationData: EVObject {
    var id: Int = 0
    var name: String = ""
}

class EmployerData: EVObject {
    var id: Int = 0
    var name: String = ""
}

class EducationData: EVObject {
    var school: SchoolData?
    var type: String = ""
    var year: YearData?
    var id: Int = 0
    var concentration: [ConcentrationData]? = []
}

class ConcentrationData: EVObject {
    var id: Int = 0
    var name: String = ""
}

class YearData: EVObject {
    var id: Int = 0
    var name: String = ""
}

class SchoolData: EVObject {
    var id: Int = 0
    var name: String = ""
}

class HomeTownData: EVObject {
    var id: Int = 0
    var name: String = ""
}
class CoverUserData: EVObject {
    var id: Int = 0
    var offset_x: String = ""
    var offset_y: String = ""
    var source: String = ""
}

class AgeRangeData: EVObject {
    var min: String = ""
}

class PictureUserData: EVObject {
    var data: PictureUserDataUrl?
}

class PictureUserDataUrl: EVObject {
    var is_silhouette: String = ""
    var url: String = ""
}
