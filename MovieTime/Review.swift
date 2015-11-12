//
//  Review.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/12/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class Review {
    
    var review_id:String!
    var author:String!
    var title:String!
    var content:String!
    var publish_date:String!
    var point:Double!
    var head_index:Int!
    
    init(review_id:String, author:String, title:String, content:String, publish_date:String, point:Double, head_index:Int){
        self.review_id = review_id
        self.author = author
        self.title = title
        self.content = content
        self.publish_date = publish_date
        self.point = point
        self.head_index = head_index
    }
    
}
