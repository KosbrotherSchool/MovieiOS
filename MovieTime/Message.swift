//
//  Message.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/13/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class Message{
    
    var board_id:Int!
    var message_id:Int!
    var author:String!
    var title:String!
    var tag:String!
    var content:String!
    var pub_date:String!
    var view_count:Int!
    var like_count:Int!
    var reply_size:Int!
    var head_index:Int!
    var is_head:Bool!
    var link_url:String!
    var pic_url:String!
    
    init(board_id:Int, message_id:Int,author:String,title:String,tag:String,content:String,pub_date:String,view_count:Int, like_count:Int, reply_size:Int, head_index:Int, is_head:Bool, link_url:String, pic_url:String){
        
        self.board_id = board_id
        self.message_id = message_id
        self.author = author
        self.title = title
        self.tag = tag
        self.content = content
        self.pub_date = pub_date
        self.view_count = view_count
        self.like_count = like_count
        self.reply_size = reply_size
        self.head_index = head_index
        self.is_head = is_head
        self.link_url = link_url
        self.pic_url = pic_url
        
    }
    





}
