//
//  FavTheater+CoreDataProperties.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/19/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension FavTheater {

    @NSManaged var name: String?
    @NSManaged var address: String?
    @NSManaged var phone: String?
    @NSManaged var theater_id: NSNumber?

}
