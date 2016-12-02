//
//  GameAccount.swift
//  GameSystem
//
//  Created by Smile on 2016/11/28.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import Foundation
class GameAccount:BaseModel {
    
    var id:Int?
    var accountName:String?
    var nickName:String?
    var game:Game?
    var roleList:[Role] = Array<Role>()
}


class GameAccountUtil {
    
    //解析Game数据
    static func anaylsGameAccount(data:NSDictionary) -> GameAccount{
        let gameAccount = GameAccount()
        gameAccount.id = data["id"] as? Int
        gameAccount.accountName = data["accountName"] as? String
        gameAccount.nickName = data["nickName"] as? String
        gameAccount.createDateString = data["createDateString"] as? String ?? ""
        gameAccount.isDeleted = data["isDeleted"] as? Int
        gameAccount.lastUpdateDateString = data["lastUpdateDateString"] as? String ?? ""
        
        //格式化日期去掉秒数
        let createDate = gameAccount.createDateString ?? ""
        if !createDate.isEmpty {
            gameAccount.createDateString = BaseUtil.formatDate(date: createDate)
        }
        
        let lastUpdateDate = gameAccount.lastUpdateDateString ?? ""
        if !lastUpdateDate.isEmpty {
            gameAccount.lastUpdateDateString = BaseUtil.formatDate(date: lastUpdateDate)
        }
        
        //game
        let gameArr = data["game"] as! NSDictionary
        if gameArr.isEqual(nil) || gameArr.count == 0 {
            return gameAccount
        }
        
        gameAccount.game = GameUtil.anaylsGame(data: gameArr)
        return gameAccount
    }
    
    static func queryGameAccountByGameId(gameId:Int) -> [GameAccount]{
        var gameAccountArr:[GameAccount] = []
        if gameId == 0 { return gameAccountArr}
        
        let params:Dictionary<String,Int> = ["game.id": gameId]
        /*BaseUtil.loadList(url: DBConstantUtil.queryGameAccountPageList, params: params) { (dataList) in
            for data in dataList {
                if (data as AnyObject).isEqual(nil) { continue }
                let _data = data as! NSDictionary
                let gameAccount = anaylsGameAccount(data: _data)
                gameAccountArr.append(gameAccount)
            }
        }*/
        
        BaseUtil.loadList(url: DBConstantUtil.queryGameAccountPageList,params: params) { (dataList:NSArray) in
            for data in dataList {
                if (data as AnyObject).isEqual(nil) { continue }
                let _data = data as! NSDictionary
                let gameAccount = anaylsGameAccount(data: _data)
                gameAccountArr.append(gameAccount)
            }
        }
        
        return gameAccountArr
    }

}
