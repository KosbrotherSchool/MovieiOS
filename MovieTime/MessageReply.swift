//
//  MessageReply.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/29/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class MessageReply{
    
    var reply_id:Int!
    var message_id:Int!
    var author:String!
    var content:String!
    var pub_date:String!
    var head_index:Int!
    var like_count:Int!
    
    init(reply_id:Int,message_id:Int, author:String, content:String, pub_date:String, head_index:Int, like_count:Int){
        self.reply_id = reply_id
        self.message_id = message_id
        self.author = author
        self.content = content
        self.pub_date = pub_date
        self.head_index = head_index
        self.like_count = like_count
    }
    
}