//
//  FavReply+CoreDataProperties.swift
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

extension FavReply {

    @NSManaged var message_id: NSNumber?
    @NSManaged var author: String?
    @NSManaged var reply_id: NSNumber?
    @NSManaged var content: String?
    @NSManaged var pub_date: String?
    @NSManaged var head_index: NSNumber?
    @NSManaged var like_count: NSNumber?

}
