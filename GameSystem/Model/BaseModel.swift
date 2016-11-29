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
            let dataList = json["list"] as? NSArray ?? NSArray()
            if dataList.isEqual(nil) || dataList.count == 0 {return}
            callback(dataList)
        })
    }
    
    
    static func loadAllList(url:String,callback:@escaping (_ gameArr:NSArray,_ gameAccountArr:NSArray,_ roleArr:NSArray)->()){
        let param:Dictionary<String,Any> = Dictionary<String,Any>()
        
        HttpGameClient.syncRequest(url: url,params: param, success: { (result:AnyObject) in
            let json = result as! Dictionary<String,Any>
            let gameArr = json["game"] as? NSArray ?? NSArray()
            let gameAccountArr = json["gameAccount"] as? NSArray ?? NSArray()
            let roleArr = json["role"] as? NSArray ?? NSArray()
            
            callback(gameArr,gameAccountArr,roleArr)
        })

    }
    
    static func load(url:String,params:Dictionary<String,Any>,callback:@escaping (_ arr:NSDictionary)->()){
        let param:Dictionary<String,Any> = params 
        HttpGameClient.syncRequest(url: url,params: param, success: { (result:AnyObject) in
            let json = result as! NSDictionary
            callback(json)
        })
    }
    
    static func load(url:String,param:String,callback:@escaping (_ arr:NSDictionary)->()){
        HttpGameClient.syncRequest(url: url,param: param, success: { (result:AnyObject) in
             callback(result as! NSDictionary)
        })
    }
}
