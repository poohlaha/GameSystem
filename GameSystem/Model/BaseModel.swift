//
//  BaseModel.swift
//  GameSystem
//
//  Created by Smile on 2016/11/25.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import Foundation

class BaseModel:NSObject {
    var createDateString:String?
    var lastUpdateDateString:String?
    var deleteDateString:String?
    var isDeleted:Int?
}

class BaseUtil {
    
    static func formatDate(date:String) -> String{
        return date.substring(to: date.index(date.startIndex, offsetBy: date.characters.count - 3))
    }
   
    //加载列表
    static func loadList(url:String,params:Dictionary<String,Any>?,callback:@escaping (_ result:NSArray)->()){
        let param:Dictionary<String,Any> = params ?? Dictionary<String,Any>()
        
        HttpGameClient.syncRequest(url: url,params: param, success: { (result:AnyObject) in
            let json = result as! Dictionary<String,Any>
            let dataList = json["list"] as! NSArray
            if dataList.isEqual(nil) || dataList.count == 0 {return}
            callback(dataList)
        })
    }
}
