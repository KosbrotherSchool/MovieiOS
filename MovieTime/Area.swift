//
//  Area.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/4/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import SwiftyJSON

class Area{
    
    var name: String?
    var area_id: Int?
    
    init(name: String, area_id: Int){
    
        self.name = name
        self.area_id = area_id
    
    }
    
    static let area_message:String = "[{\"id\":1,\"name\":\"台北東區\"},{\"id\":2,\"name\":\"台北西區\"},{\"id\":3,\"name\":\"台北南區\"},{\"id\":4,\"name\":\"台北北區\"},{\"id\":5,\"name\":\"新北市\"},{\"id\":6,\"name\":\"台北二輪\"},{\"id\":7,\"name\":\"基隆\"},{\"id\":8,\"name\":\"桃園\"},{\"id\":9,\"name\":\"中壢\"},{\"id\":10,\"name\":\"新竹\"},{\"id\":11,\"name\":\"苗栗\"},{\"id\":12,\"name\":\"台中\"},{\"id\":13,\"name\":\"彰化\"},{\"id\":14,\"name\":\"雲林\"},{\"id\":15,\"name\":\"南投\"},{\"id\":16,\"name\":\"嘉義\"},{\"id\":17,\"name\":\"台南\"},{\"id\":18,\"name\":\"高雄\"},{\"id\":19,\"name\":\"宜蘭\"},{\"id\":20,\"name\":\"花蓮\"},{\"id\":21,\"name\":\"台東\"},{\"id\":22,\"name\":\"金門\"},{\"id\":23,\"name\":\"屏東\"},{\"id\":24,\"name\":\"澎湖\"},{\"id\":25,\"name\":\"所有二輪\"}]";
    
    static func getAreas()->[Area]{
        var areas = [Area]()
        if let dataFromString = area_message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let jsonData = JSON(data: dataFromString)
            for area in jsonData.arrayValue{
                var name: String = ""
                var area_id: Int = 0
                
                name = area["name"].stringValue
                area_id = area["id"].int!
                let newArea = Area.init(name: name, area_id: area_id)
                areas.append(newArea)
            }
            return areas
        }
        return areas
    }
    
}
