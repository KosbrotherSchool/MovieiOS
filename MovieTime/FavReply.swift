//
//  FavReply.swift
//  MovieTime
//
//  Created by Ko LiChung on 12/1/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import Foundation
import CoreData


class FavReply: NSManagedObject {

    static let entityName = "FavReply"
    
    class func add(moc:NSManagedObjectContext, reply_id:Int,message_id:Int,author:String,content:String, pub_date:String, head_index:Int, like_count:Int) -> FavReply? {
        
        let replies = getAll(moc)
        if replies.count >= 500{
            for num in 0...50{
                moc.deleteObject(replies[num])
            }
        }
        
        let reply = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: moc) as! FavReply
        
        reply.reply_id = reply_id
        reply.message_id = message_id
        reply.author = author
        reply.content = content
        reply.pub_date = pub_date
        reply.head_index = like_count
        reply.like_count = like_count
        
        do {
            try moc.save()
            return reply
        }catch{
            fatalError("Failure to save context: \(error)")
        }
        return nil
    }
    
    class func getAll(moc:NSManagedObjectContext) -> [FavReply] {
        let request = NSFetchRequest(entityName: entityName)
        
        do {
            return try moc.executeFetchRequest(request) as! [FavReply]
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
    }
    
    class func queryByReplyID(moc:NSManagedObjectContext,reply_id:Int) -> FavReply? {
        
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = NSPredicate(format: "reply_id == %@", String(reply_id))
        
        do{
            let results = try moc.executeFetchRequest(request) as! [FavReply]
            if (results.count > 0){
                return results[0]
            }
        } catch {
            fatalError("Failed to update data: \(error)")
        }
        
        return nil
    }
    
    class func deleteTheFavReply(moc:NSManagedObjectContext,theReply:FavReply){
        
        moc.deleteObject(theReply)
        do{
            try moc.save()
        }catch{
            fatalError("Failure to save context: \(error)")
        }
        
    }

}
