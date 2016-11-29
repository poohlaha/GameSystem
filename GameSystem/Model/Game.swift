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
        game.gameName = data["gameName"] as? String
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
        
        let gameAccountArr = data["gameAccountList"] as? NSArray ?? NSArray()
        if gameAccountArr.isEqual(nil) || gameAccountArr.count == 0 { return game}
        
        var gameAccountList:[GameAccount] = []
        for gameAccount in gameAccountArr {
            let _gameAccount:GameAccount = GameAccountUtil.anaylsGameAccount(data: gameAccount as! NSDictionary)
            if !_gameAccount.isEqual(nil) {
                gameAccountList.append(_gameAccount)
            }
        }
        
        game.gameAccountList = gameAccountList
        
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
    
    static func anaylsGameAccountByGameId(gameId:Int,gameAccountList:[GameAccount]) -> Array<GameAccount>{
        var gameAccountArr:[GameAccount] = []
        if gameId == 0 || gameAccountList.isEmpty || gameAccountList.count == 0  { return gameAccountArr}
        
        gameAccountArr = GameAccountUtil.queryGameAccountByGameId(gameId: gameId)
        
        return gameAccountArr
    }
    
    
    static func loadAllList() ->Dictionary<String,Array<AnyObject>>{
        var gameList:[Game] = []
        var gameAccountList:[GameAccount] = []
        var roleList:[Role] = []
        
        BaseUtil.loadAllList(url: DBConstantUtil.queryAll) { (gameArr, gameAccountArr, roleArr) in
            if !gameArr.isEqual(nil) && gameArr.count > 0 {
                for data in gameArr {
                    if (data as AnyObject).isEqual(nil) { continue }
                    let _data = data as! NSDictionary
                    let game = anaylsGame(data: _data)
                    gameList.append(game)
                }
            }
            
            if !gameAccountArr.isEqual(nil) && gameAccountArr.count > 0 {
                for data in gameAccountArr {
                    if (data as AnyObject).isEqual(nil) { continue }
                    let _data = data as! NSDictionary
                    let gameAccount = GameAccountUtil.anaylsGameAccount(data: _data)
                    gameAccountList.append(gameAccount)
                }
            }
            
            if !roleArr.isEqual(nil) && roleArr.count > 0 {
                for data in roleArr {
                    if (data as AnyObject).isEqual(nil) { continue }
                    let _data = data as! NSDictionary
                    let role = RoleUtil.anaylsRole(data: _data)
                    roleList.append(role)
                }
            }
            
        }
        
        
        return ["game": gameList,"gameAccount":gameAccountList,"role":roleList]
    }
 
}
