//
//  Trailer.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/11/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class Trailer{
    
    var title: String!
    var youtube_id: String!
    var youtube_link: String!
    var movie_id: Int!
    var trailer_id: Int!
    
    init(title:String, youtube_id:String, youtube_link:String, movie_id:Int, trailer_id:Int){
        self.title = title
        self.youtube_id = youtube_id
        self.youtube_link = youtube_link
        self.movie_id = movie_id
        self.trailer_id = trailer_id
    }
    
    func getPicLink() -> String{
        return "https://i.ytimg.com/vi/"+youtube_id+"/mqdefault.jpg"
    }
    
}
