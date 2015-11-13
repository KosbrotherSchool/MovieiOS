//
//  MovieRank.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/13/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class MovieRank{

    var movierank_rank_type:Int!
    var movierank_movie_id:Int!
    var movierank_current_rank:Int!
    var movierank_last_week_rank:Int!
    var movierank_publish_weeks:Int!
    var movierank_the_week:Int!
    var movierank_static_duration:String!
    var movierank_expect_people:Int!
    var movierank_total_people:Int!
    var movierank_satisfied_num:String!

    init(movierank_rank_type:Int,movierank_movie_id:Int,movierank_current_rank:Int,movierank_last_week_rank:Int,movierank_publish_weeks:Int,movierank_the_week:Int,movierank_static_duration:String,movierank_expect_people:Int,movierank_total_people:Int, movierank_satisfied_num:String){
    
    
    self.movierank_rank_type = movierank_rank_type
    self.movierank_movie_id = movierank_movie_id
    self.movierank_current_rank = movierank_current_rank
    self.movierank_last_week_rank = movierank_last_week_rank
    self.movierank_publish_weeks = movierank_publish_weeks
    self.movierank_the_week = movierank_the_week
    self.movierank_static_duration = movierank_static_duration
    self.movierank_expect_people = movierank_expect_people
    self.movierank_total_people = movierank_total_people
    self.movierank_satisfied_num  = movierank_satisfied_num
    
    
    
    
    
    
    }



}


