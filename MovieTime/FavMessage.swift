//
//  FavMessage.swift
//  MovieTime
//
//  Created by Ko LiChung on 12/1/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import Foundation
import CoreData


class FavMessage: NSManagedObject {

    static let entityName = "FavMessage"
    
    class func add(moc:NSManagedObjectContext,message_id:Int,author:String,title:String,tag:String,content:String, pub_date:String,view_count:Int, reply_size:Int, head_index:Int, like_count:Int, is_head:Bool, link_url:String) -> FavMessage? {
        
        let messages = getAll(moc)
        if messages.count >= 200{
            for num in 0...50{
                moc.deleteObject(messages[num])
            }
        }
        
        let message = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: moc) as! FavMessage
        
        message.message_id = message_id
        message.author = author
        message.title = title
        message.content = content
        message.tag = tag
        message.pub_date = pub_date
        message.view_count = view_count
        message.reply_size = reply_size
        message.head_index = like_count
        message.like_count = like_count
        message.is_head = is_head
        message.link_url = link_url
        
        do {
            try moc.save()
            return message
        }catch{
            fatalError("Failure to save context: \(error)")
        }
        return nil
    }
    
    class func getAll(moc:NSManagedObjectContext) -> [FavMessage] {
        let request = NSFetchRequest(entityName: entityName)
        
        do {
            return try moc.executeFetchRequest(request) as! [FavMessage]
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
    }
    
    
    class func queryByMessageID(moc:NSManagedObjectContext,mssage_id:Int) -> FavMessage? {
        
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = NSPredicate(format: "message_id == %@", String(mssage_id))
        
        do{
            let results = try moc.executeFetchRequest(request) as! [FavMessage]
            if (results.count > 0){
                return results[0]
            }
        } catch {
            fatalError("Failed to update data: \(error)")
        }
        
        return nil
    }
    
    class func deleteTheFavMessage(moc:NSManagedObjectContext,theMessage:FavMessage){
        
        moc.deleteObject(theMessage)
        do{
            try moc.save()
        }catch{
            fatalError("Failure to save context: \(error)")
        }
        
    }


}
