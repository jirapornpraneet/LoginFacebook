//
//  UserResource.swift
//  LoginFacebook
//
//  Created by Jiraporn Praneet on 8/1/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import Foundation
import EVReflection

class UserResource: EVNetworkingObject {
    var data: [UserResourceData]? = []
}

class UserResourceData: EVNetworkingObject {
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
    var movies: AlbumsData?
    var television: AlbumsData?
}

class AlbumsData: EVNetworkingObject {
    var data: [AlbumsDataDetail]? = []
}

class AlbumsDataDetail: EVNetworkingObject {
    var created_time: String = ""
    var count: Int = 0
    var name: String = ""
    var photos: AlbumsPhotosData?
    var picture: PictureUserData?
    var category: String = ""
    var global_brand_page_name: String = ""
}

class AlbumsPhotosData: EVNetworkingObject {
    var data: [AlbumsPhotosDataDetail]? = []
}

class AlbumsPhotosDataDetail: EVNetworkingObject {
    var picture: String = ""
    var name: String =  ""
    var id: Int = 0
}

class PostsData: EVNetworkingObject {
    var data: [PostsDataDetail]? = []
}

class PostsDataDetail: EVNetworkingObject {
    var message: String = ""
    var full_picture: String = ""
    var id: Int = 0
    var created_time: String = ""
    var place: PlaceData?
    var reactions: ReactionsData?
    var comments: CommentsData?
}

class CommentsData: EVNetworkingObject {
    var data: [CommentsDataDetail]? = []
}

class CommentsDataDetail: EVNetworkingObject {
    var comment_count: Int = 0
    var message: String = ""
    var from: FromData?
    var created_time: String = ""
    var comments: CommentsData?
}

class FromData: EVNetworkingObject {
    var name: String = ""
}

class ReactionsData: EVNetworkingObject {
    var data: [ReactionsDataDetail]? = []
}

class ReactionsDataDetail: EVNetworkingObject {
    var name: String = ""
    var link: String = ""
    var pic_large: String = ""
    var type: String = "" 
}

class PlaceData: EVNetworkingObject {
    var id: Int = 0
    var name: String = ""
    var location: PlaceDataLocation?
}

class PlaceDataLocation: EVNetworkingObject {
    var city: String = ""
    var country: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var street: String = ""
    var zip: Int = 0
}

class WorkData: EVNetworkingObject {
    var end_date: String = ""
    var employer: EmployerData?
    var location: LocationData?
    var position: PositionData?
    var start_date: String = ""
    var id: Int = 0
}

class PositionData: EVNetworkingObject {
    var id: Int = 0
    var name: String = ""
}

class LocationData: EVNetworkingObject {
    var id: Int = 0
    var name: String = ""
}

class EmployerData: EVNetworkingObject {
    var id: Int = 0
    var name: String = ""
}

class EducationData: EVNetworkingObject {
    var school: SchoolData?
    var type: String = ""
    var year: YearData?
    var id: Int = 0
    var concentration: [ConcentrationData]? = []
}

class ConcentrationData: EVNetworkingObject {
    var id: Int = 0
    var name: String = ""
}

class YearData: EVNetworkingObject {
    var id: Int = 0
    var name: String = ""
}

class SchoolData: EVNetworkingObject {
    var id: Int = 0
    var name: String = ""
}

class HomeTownData: EVNetworkingObject {
    var id: Int = 0
    var name: String = ""
}
class CoverUserData: EVNetworkingObject {
    var id: Int = 0
    var offset_x: String = ""
    var offset_y: String = ""
    var source: String = ""
}

class AgeRangeData: EVNetworkingObject {
    var min: String = ""
}

class PictureUserData: EVNetworkingObject {
    var data: PictureUserDataUrl?
}

class PictureUserDataUrl: EVNetworkingObject {
    var is_silhouette: String = ""
    var url: String = ""
}
