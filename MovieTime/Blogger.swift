//
//  Blogger.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/13/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class Blogger {
    
    var blogger_name:String!
    var blogger_url:String!
    var blogger_icon_id:Int!
    var pic_link:String!
    
    init(blogger_name:String,blogger_url:String, blogger_icon_id:Int, pic_link:String){
        
        self.blogger_name = blogger_name
        self.blogger_url = blogger_url
        self.blogger_icon_id = blogger_icon_id
        self.pic_link = pic_link
        
    }
    
}
