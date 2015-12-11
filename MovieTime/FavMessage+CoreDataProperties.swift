//
//  FavMessage+CoreDataProperties.swift
//  MovieTime
//
//  Created by Ko LiChung on 12/1/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension FavMessage {

    @NSManaged var message_id: NSNumber?
    @NSManaged var author: String?
    @NSManaged var title: String?
    @NSManaged var tag: String?
    @NSManaged var content: String?
    @NSManaged var pub_date: String?
    @NSManaged var view_count: NSNumber?
    @NSManaged var like_count: NSNumber?
    @NSManaged var reply_size: NSNumber?
    @NSManaged var head_index: NSNumber?
    @NSManaged var is_head: NSNumber?
    @NSManaged var link_url: String?

}
