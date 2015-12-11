//
//  Settings.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/24/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class Settings {
    
    enum settingKeys {
        static let keyHeadImage = "keyHeadImage"
        static let keyNickName = "keyNickName"
    }
    
    class func saveHeadImage(head_index:Int){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(head_index, forKey: settingKeys.keyHeadImage)
        defaults.synchronize()
    }
    
    class func getHeadIndex() -> Int{
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(settingKeys.keyHeadImage)
    }
    
    class func getHeadImage() -> UIImage{
        let defaults = NSUserDefaults.standardUserDefaults()
        let head_index = defaults.integerForKey(settingKeys.keyHeadImage)
        var headImage:UIImage!
        switch head_index{
        case 1:
            headImage = UIImage(named: "head_captain")
        case 2:
            headImage = UIImage(named: "head_iron_man")
        case 3:
            headImage = UIImage(named: "head_black_widow")
        case 4:
            headImage = UIImage(named: "head_thor")
        case 5:
            headImage = UIImage(named: "head_hulk")
        case 6:
            headImage = UIImage(named: "head_hawkeye")
        default:
            headImage = UIImage(named: "head_captain")
        }
        return headImage
    }
    
    class func getHeadImage(head_index:Int) -> UIImage{
        var headImage:UIImage!
        switch head_index{
        case 1:
            headImage = UIImage(named: "head_captain")
        case 2:
            headImage = UIImage(named: "head_iron_man")
        case 3:
            headImage = UIImage(named: "head_black_widow")
        case 4:
            headImage = UIImage(named: "head_thor")
        case 5:
            headImage = UIImage(named: "head_hulk")
        case 6:
            headImage = UIImage(named: "head_hawkeye")
        default:
            headImage = UIImage(named: "head_captain")
        }
        return headImage
    }
    
    class func saveNickName(nickName:String){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(nickName, forKey: settingKeys.keyNickName)
        defaults.synchronize()
    }
    
    class func getNickName() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let nickName = defaults.stringForKey(settingKeys.keyNickName)
        return nickName
    }
    
    enum tagKeys {
        static let keyAnnouncement = ["公告","詢問","建議","其他"]
        static let keyMovie = ["讚","噓","請益","找片","討論","新聞","趣味","好康","其他"]
        static let keyDrama = ["台灣","歐美","韓劇","日劇","大陸劇","港劇","印新馬泰","其他"]
        static let keyLife = ["星座","男女","美食","新聞","八卦","運動","環保","協尋","文藝","政治","其他"]
    }
    
    
    // movie
    class func isMovieNeedRefreshByThisDate() -> Bool {
        let saveDateString = getMovieSavedDate()
        
        if saveDateString != ""{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            let saveDate = dateFormatter.dateFromString(saveDateString)
        
            let currentDate = NSDate()
        
            if currentDate.timeIntervalSinceDate(saveDate!)/3600/24 > 1{
                return true
            }else{
                return false
            }
        }else{
            return true
        }
    }
    
    class func saveMovieUpdateDate() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var convertedDate = dateFormatter.stringFromDate(currentDate)
        convertedDate = convertedDate + " 08:30"
        
        defaults.setValue(convertedDate, forKey: "SaveMovieDate")
    }
    
    class func getMovieSavedDate() -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let saveDate = defaults.stringForKey("SaveMovieDate"){
            return saveDate
        }
        return ""
    }
    
    // high light message
    class func isHighlightMessageNeedRefreshByThisDate() -> Bool {
        let saveDateString = getHighlightMessageSavedDate()
        
        if saveDateString != ""{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            let saveDate = dateFormatter.dateFromString(saveDateString)
            
            let currentDate = NSDate()
            
            if currentDate.timeIntervalSinceDate(saveDate!)/3600/24 > 1{
                return true
            }else{
                return false
            }
        }else{
            return true
        }
    }
    
    class func saveHighlightMessageUpdateDate() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var convertedDate = dateFormatter.stringFromDate(currentDate)
        convertedDate = convertedDate + " 08:30"
        
        defaults.setValue(convertedDate, forKey: "SaveMessageDate")
    }
    
    class func getHighlightMessageSavedDate() -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let saveDate = defaults.stringForKey("SaveMessageDate"){
            return saveDate
        }
        return ""
    }
    
    // blog post save date
    class func isBlogPostNeedRefreshByThisDate() -> Bool {
        let saveDateString = getBlogPostSavedDate()
        
        if saveDateString != ""{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            let saveDate = dateFormatter.dateFromString(saveDateString)
            
            let currentDate = NSDate()
            
            if currentDate.timeIntervalSinceDate(saveDate!)/3600/24 > 1{
                return true
            }else{
                return false
            }
        }else{
            return true
        }
    }
    
    class func saveBlogPostUpdateDate() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var convertedDate = dateFormatter.stringFromDate(currentDate)
        convertedDate = convertedDate + " 08:30"
        
        defaults.setValue(convertedDate, forKey: "SaveBlogPostDate")
    }
    
    class func getBlogPostSavedDate() -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let saveDate = defaults.stringForKey("SaveBlogPostDate"){
            return saveDate
        }
        return ""
    }
    
}
