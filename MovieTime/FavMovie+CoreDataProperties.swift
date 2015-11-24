//
//  FavMovie+CoreDataProperties.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/23/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension FavMovie {

    @NSManaged var movie_id: NSNumber?
    @NSManaged var title: String?
    @NSManaged var pic_link: String?
    @NSManaged var point: NSNumber?

}
