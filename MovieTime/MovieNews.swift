//
//  MovieNews.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/13/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class MovieNews{

    var movienews_title:String!
    var movienews_info:String!
    var movienews_new_link:String!
    var movienews_publish_day:String!
    var movienews_pic_link:String!
    var movienews_news_type:Int!
    var movienews_news_id:Int!

    init(movienews_title:String,movienews_info:String,movienews_new_link:String,movienews_publish_day:String,movienews_pic_link:String,movienews_news_type:Int,movienews_news_id:Int){

        self.movienews_title = movienews_title
        self.movienews_info = movienews_info
        self.movienews_new_link = movienews_new_link
        self.movienews_publish_day = movienews_publish_day
        self.movienews_pic_link = movienews_pic_link
        self.movienews_news_type = movienews_news_type
        self.movienews_news_id = movienews_news_id

}
}