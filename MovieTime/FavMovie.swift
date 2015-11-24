//
//  FavMovie.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/23/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import Foundation
import CoreData


class FavMovie: NSManagedObject {

    static let entityName = "FavMovie"
    
    class func add(moc:NSManagedObjectContext, title:String,pic_link:String,point:Double,movie_id:Int) -> FavMovie? {
        
        let movie = NSEntityDescription.insertNewObjectForEntityForName("FavMovie", inManagedObjectContext: moc) as! FavMovie
        
        movie.title = title
        movie.pic_link = pic_link
        movie.point = point
        movie.movie_id = movie_id
        
        do {
            try moc.save()
            return movie
        }catch{
            fatalError("Failure to save context: \(error)")
        }
        return nil
    }
    
    class func getAll(moc:NSManagedObjectContext) -> [FavMovie] {
        let request = NSFetchRequest(entityName: entityName)
        
        do {
            return try moc.executeFetchRequest(request) as! [FavMovie]
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
    }
    
    class func queryByMovieID(moc:NSManagedObjectContext,movie_id:Int) -> FavMovie? {
        
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = NSPredicate(format: "movie_id == %@", String(movie_id))
        
        do{
            let results = try moc.executeFetchRequest(request) as! [FavMovie]
            if (results.count > 0){
                return results[0]
            }
        } catch {
            fatalError("Failed to update data: \(error)")
        }
        
        return nil
    }
    
    class func deleteTheFavTheater(moc:NSManagedObjectContext,theMovie:FavMovie){
        
        moc.deleteObject(theMovie)
        do{
            try moc.save()
        }catch{
            fatalError("Failure to save context: \(error)")
        }
        
    }
    
}
