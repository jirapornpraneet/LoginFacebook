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
    var cover: CoverUserData?
    var about: String = ""
    var birthday: String = ""
    var gender: String = ""
    var age_range: Data?
    var hometown: Data?
    var location: Data?
    var work: [WorkData]? = []
    var education: [EducationData]? = []
    var posts: PostsData?
    var relationship_status: String = ""
    var albums: AlbumsData?
    var music: AlbumsData?
    var movies: AlbumsData?
    var television: AlbumsData?
    var groups: AlbumsData?
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
    var data: [Data]? = []
}

class PostsData: EVNetworkingObject {
    var data: [PostsDataDetail]? = []
}

class PostsDataDetail: EVNetworkingObject {
    var message: String = ""
    var full_picture: String = ""
    var id: Int = 0
    var created_time: String = ""
    var place: Data?
    var reactions: ReactionsData?
    var comments: CommentsData?
}

class CommentsData: EVNetworkingObject {
    var data: [CommentsDataDetail]? = []
}

class CommentsDataDetail: EVNetworkingObject {
    var comment_count: Int = 0
    var message: String = ""
    var from: Data?
    var created_time: String = ""
    var comments: CommentsData?
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
    var employer: Data?
    var location: Data?
    var position: Data?
    var start_date: String = ""
    var id: Int = 0
}

class EducationData: EVNetworkingObject {
    var school: Data?
    var year: Data?
    var type: String = ""
    var id: Int = 0
    var concentration: [Data]? = []
}

class Data: EVNetworkingObject {
    var id: Int = 0
    var name: String = ""
    var location: PlaceDataLocation?
    var min: String = ""
    var picture: String = ""
}

class CoverUserData: EVNetworkingObject {
    var id: Int = 0
    var offset_x: String = ""
    var offset_y: String = ""
    var source: String = ""
}

class PictureUserData: EVNetworkingObject {
    var data: PictureUserDataUrl?
}

class PictureUserDataUrl: EVNetworkingObject {
    var is_silhouette: String = ""
    var url: String = ""
}
