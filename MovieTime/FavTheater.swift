//
//  FavTheater.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/19/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import Foundation
import CoreData


class FavTheater: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    static let entityName = "FavTheater"
    
    class func add(moc:NSManagedObjectContext, name:String,phone:String,address:String,theater_id:Int) -> FavTheater? {
        let theater = NSEntityDescription.insertNewObjectForEntityForName("FavTheater", inManagedObjectContext: moc) as! FavTheater
        
        theater.name = name
        theater.phone = phone
        theater.address = address
        theater.theater_id = theater_id
        
        do {
            try moc.save()
            return theater
        }catch{
            fatalError("Failure to save context: \(error)")
        }
        return nil
    }
    
    class func getAll(moc:NSManagedObjectContext) -> [FavTheater] {
        let request = NSFetchRequest(entityName: entityName)
        
        do {
            return try moc.executeFetchRequest(request) as! [FavTheater]
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
    }
    
    class func queryByTheaterID(moc:NSManagedObjectContext,theater_id:Int) -> FavTheater? {
    
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = NSPredicate(format: "theater_id == %@", String(theater_id))
        
        do{
            let results = try moc.executeFetchRequest(request) as! [FavTheater]
            if (results.count > 0){
                return results[0]
            }
        } catch {
            fatalError("Failed to update data: \(error)")
        }
        
        return nil
        
    }
    
    class func deleteTheFavTheater(moc:NSManagedObjectContext,theTheater:FavTheater){
        
        moc.deleteObject(theTheater)
        do{
            try moc.save()
        }catch{
            fatalError("Failure to save context: \(error)")
        }
    
    }
    
    
}
