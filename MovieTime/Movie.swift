//
//  Movie.swift
//  MovieTime
//
//  Created by Ko LiChung on 10/30/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class Movie {
    
    var movie_id: Int
    var title: String
    var title_eng: String?
    var movie_class: String?
    var movie_type: String?
    var movie_length: String?
    var publish_date: String?
    var director: String?
    var editors: String?
    var actors: String?
    var official: String?
    var movie_info: String?
    var small_pic: String
    var large_pic: String
    var movie_round: Int?
    var photo_size: Int?
    var trailer_size: Int?
    var points: Double
    var review_size: Int
    var imdb_point: String?
    var imdb_link: String?
    var potato_point: String?
    var potato_link: String?
    //    var publish_date_date;
    
    init(movie_id: Int, title: String, small_pic: String, large_pic: String, points: Double, review_size: Int, publish_date: String){
        self.movie_id = movie_id
        self.title = title
        self.small_pic = small_pic
        self.large_pic = large_pic
        self.points = points
        self.review_size = review_size
        self.publish_date = publish_date
    }
    
    init(movie_id: Int, title: String, title_eng: String, movie_class: String, movie_type: String, movie_length: String, publish_date: String, director: String, editors: String, actors: String, official: String, movie_info: String, small_pic: String, large_pic: String, movie_round: Int, photo_size: Int, trailer_size: Int, points: Double, review_size: Int, imdb_point: String, imdb_link: String, potato_point: String, potato_link: String){
        
        self.movie_id = movie_id
        self.title = title
        self.title_eng = title_eng
        self.movie_class = movie_class
        self.movie_type = movie_type
        self.movie_length = movie_length
        self.publish_date = publish_date
        self.director = director
        self.editors = editors
        self.actors = actors
        self.official = official
        self.movie_info = movie_info
        self.small_pic = small_pic
        self.large_pic = large_pic
        self.movie_round = movie_round
        self.photo_size = photo_size
        self.trailer_size = trailer_size
        self.points = points
        self.review_size = review_size
        self.imdb_point = imdb_point
        self.imdb_link = imdb_link
        self.potato_point = potato_point
        self.potato_link = potato_link
    }
    
}

