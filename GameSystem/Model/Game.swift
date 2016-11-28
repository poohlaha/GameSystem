//
//  Game.swift
//  GameSystem
//
//  Created by Smile on 2016/11/28.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class Game: BaseModel {

    var id:Int?
    var gameCompanyCode:String?
    var gameCompanyName:String?
    var gameName:String?
    var gameAccountList:[GameAccount] = Array<GameAccount>()
}


class GameUtil {
    
    //解析Game数据
    static func anaylsGame(data:NSDictionary) -> Game{
        let game = Game()
        game.id = data["id"] as? Int
        game.gameName = data["roleName"] as? String
        game.gameCompanyCode = data["gameCompanyCode"] as? String
        game.gameCompanyName = data["gameCompanyName"] as? String
        game.createDateString = data["createDateString"] as? String ?? ""
        game.isDeleted = data["isDeleted"] as? Int
        game.lastUpdateDateString = data["lastUpdateDateString"] as? String ?? ""
        
        //格式化日期去掉秒数
        let createDate = game.createDateString ?? ""
        if !createDate.isEmpty {
            game.createDateString = BaseUtil.formatDate(date: createDate)
        }
        
        let lastUpdateDate = game.lastUpdateDateString ?? ""
        if !lastUpdateDate.isEmpty {
            game.lastUpdateDateString = BaseUtil.formatDate(date: lastUpdateDate)
        }
        
        return game
    }
    
    //加载角色列表
    static func loadGameList(params:Dictionary<String,Any>?) -> Array<Game>{
        var totalList:[Game] = Array<Game>()
        BaseUtil.loadList(url: DBConstantUtil.queryGameList, params: params) { (dataList) in
            for data in dataList {
                if (data as AnyObject).isEqual(nil) { continue }
                let _data = data as! NSDictionary
                let game = anaylsGame(data: _data)
                totalList.append(game)
            }
        }
        
        return totalList
    }
    
 
}
