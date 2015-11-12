//
//  MovieTime.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/4/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class MovieTime {
    
    var remark: String?
    var movie_title: String?
    var movie_time: String?
    var movie_id: Int?
    var theater_id: Int?
    var movie_photo: String?
    
    init(remark: String, movie_title: String, movie_time: String, movie_id: Int, theater_id: Int, movie_photo: String){
        self.remark = remark
        self.movie_title = movie_title
        self.movie_time = movie_time
        self.movie_id = movie_id
        self.theater_id = theater_id
        self.movie_photo = movie_photo
    }
    
}
