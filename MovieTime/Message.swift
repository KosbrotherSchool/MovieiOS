//
//  Message.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/13/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class Message{

    var message_id:Int!
    var message_author:String!
    var message_title:String!
    var message_tag:String!
    var message_content:String!
    var message_pub_date:String!
    var message_view_count:Int!
    
    init(message_id:Int,message_author:String,message_title:String,message_tag:String,message_content:String,message_pub_date:String,message_view_count:Int){
        
        self.message_id = message_id
        self.message_author = message_author
        self.message_title = message_title
        self.message_tag = message_tag
        self.message_content = message_content
        self.message_pub_date = message_pub_date
        self.message_view_count = message_view_count
    
    
    
    
    }
    





}
