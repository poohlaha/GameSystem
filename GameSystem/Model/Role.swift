//
//  Role.swift
//  GameSystem
//
//  Created by Smile on 2016/11/23.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import Foundation

class Role:BaseModel {
    
    var id:Int?
    var currency:Int? = 0
    var isRoleRecharge:Int?//0---可首充,1---不可首充
    var isRoleShip:Int?//0---可发货,1---不可发货
    var roleLevel:Int? = 0;//角色等级
    var roleName:String?//角色名称
    var messages:NSMutableArray?
    //GameAccount gameAccount;
    var shipments:NSMutableArray?
    var gameAccount:GameAccount?
}

class RoleUtil {
    
    static let ROLEEDIT_SUCCESS = "修改角色信息成功!"
    static let ROLEEDIT_FAILED = "修改角色信息失败!"
    static let ROLEEDIT_TIP = "当前操作未保存,是否需要保存?"
    
    //解析Role数据
    static func anaylsRole(data:NSDictionary) -> Role{
        let role = Role()
        role.id = data["id"] as? Int ?? 0
        role.roleName = data["roleName"] as? String ?? ""
        role.currency = data["currency"] as? Int ?? 0
        role.isRoleRecharge = data["isRoleRecharge"] as? Int ?? 0
        role.isRoleShip = data["isRoleShip"] as? Int ?? 0
        role.roleLevel = data["roleLevel"] as? Int ?? 0
        role.createDateString = data["createDateString"] as? String ?? ""
        role.isDeleted = data["isDeleted"] as? Int ?? 0
        role.lastUpdateDateString = data["lastUpdateDateString"] as? String ?? ""
        
        //格式化日期去掉秒数
        let createDate = role.createDateString ?? ""
        if !createDate.isEmpty {
            role.createDateString = BaseUtil.formatDate(date: createDate)
        }
        
        let lastUpdateDate = role.lastUpdateDateString ?? ""
        if !lastUpdateDate.isEmpty {
            role.lastUpdateDateString = BaseUtil.formatDate(date: lastUpdateDate)
        } else {
             role.lastUpdateDateString = role.createDateString ?? ""
        }
        
        
        //gameAccount
        let gameAccountArr = data["gameAccount"] as! NSDictionary
        if gameAccountArr.isEqual(nil) || gameAccountArr.count == 0 { return role}
        
        let gameAccount = GameAccount()
        gameAccount.id = gameAccountArr["id"] as? Int ?? 0
        gameAccount.accountName = gameAccountArr["accountName"] as? String ?? ""
        gameAccount.nickName = gameAccountArr["nickName"] as? String ?? ""
        
        //game
        let gameArr = gameAccountArr["game"] as! NSDictionary
        if gameArr.isEqual(nil) || gameArr.count == 0 {
            role.gameAccount = gameAccount
            return role
        }
        
        let game = Game()
        game.id = gameArr["id"] as? Int ?? 0
        game.gameName = gameArr["gameName"] as? String ?? ""
        game.gameCompanyCode = gameArr["gameCompanyCode"] as? String ?? ""
        game.gameCompanyName = gameArr["gameCompanyName"] as? String ?? ""
        
        gameAccount.game = game
        role.gameAccount = gameAccount
        
        return role
    }
    
    //加载角色列表
    static func loadRoleList(params:Dictionary<String,Any>?,callback:@escaping ()->()) -> Array<Role>{
        /*let param:Dictionary<String,Any> = params ?? Dictionary<String,Any>()
        var totalList:[Role] = Array<Role>()
        
        HttpGameClient.syncRequest(url: DBConstantUtil.queryRolePageList,params: param, success: { (result:AnyObject) in
            let json = result as! Dictionary<String,Any>
            let dataList = json["list"] as! NSArray
            
            if dataList.isEqual(nil) || dataList.count == 0 {return}
            for data in dataList {
                if (data as AnyObject).isEqual(nil) { continue }
                
                let _data = data as! NSDictionary
                let role = anaylsRole(data: _data)
                totalList.append(role)
            }
            
        })
         
         return totalList*/
        
        var totalList:[Role] = Array<Role>()
        BaseUtil.loadList(url: DBConstantUtil.queryRolePageList, params: params) { (dataList) in
            for data in dataList {
                if (data as AnyObject).isEqual(nil) { continue }
                let _data = data as! NSDictionary
                let role = anaylsRole(data: _data)
                totalList.append(role)
            }
            
            callback()
        }
        
        return totalList
    }
    
    static func anaylsRoleContact(roles:[Role]) -> [ContactSession]{
        return ContactModel().convert(contacts: roles, fieldName: "roleName", isNeedPhoto: true)
    }
    
    static func queryRoleById(params:Dictionary<String,Any>,callback:()) -> Role{
        var role:Role = Role()
        
        /*
        HttpGameClient.syncRequest(url: DBConstantUtil.queryRoleById,params: param, success: { (result:AnyObject) in
            let json = result as! NSDictionary
            role = anaylsRole(data: json)
            
        })*/
        
        BaseUtil.load(url: DBConstantUtil.queryRoleById,params: params) { (result:NSDictionary) in
            role = anaylsRole(data: result)
            callback
        }
        
        return role
    }
    
    static func saveRole(role:Role,callback:@escaping (_ resultCode:String,_ resultMessage:String)->()) {
        //let jsonData = try! JSONSerialization.data(withJSONObject: convertToStr(role: role), options: JSONSerialization.WritingOptions.prettyPrinted)
       // let param = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        BaseUtil.load(url: DBConstantUtil.saveRole,params: convertToStr(role: role)) { (result:NSDictionary) in
            let json = result as! Dictionary<String,Any>
            let resultCode = json["resultCode"] as? String
            let resultMessage = json["resultMessage"]  as? String
            callback(resultCode!,resultMessage!)
        }
    }
    
    static func updateRole(role:Role,callback:@escaping (_ resultCode:String,_ resultMessage:String)->()) {
        BaseUtil.load(url: DBConstantUtil.updateRole,params: convertToStr(role: role)) { (result:NSDictionary) in
            let json = result as! Dictionary<String,Any>
            let resultCode = json["resultCode"] as? String
            let resultMessage = json["resultMessage"]  as? String
            callback(resultCode!,resultMessage!)
        }
    }
    
    //转换成字典
    static func convertToStr(role:Role) -> Dictionary<String,Any> {
        var str:Dictionary<String,Any> = [:]
        str["id"] = role.id
        str["currency"] = role.currency
        str["isRoleRecharge"] = role.isRoleRecharge
        str["isRoleShip"] = role.isRoleShip
        str["roleLevel"] = role.roleLevel
        str["roleName"] = role.roleName ?? ""
        
        if role.gameAccount != nil {
            str["gameAccount.id"] = role.gameAccount?.id
            
            if role.gameAccount?.game != nil {
                str["gameAccount.game.id"] = role.gameAccount?.game?.id
            }
        }
        
        return str
    }
    
    //通过gameAccountId查询角色列表
    static func anaylsRoleByGameAccountId(gameAccountId:Int,roleList:[Role]?) -> Array<Role>{
        var roleArr:[Role] = []
        if gameAccountId == 0  { return roleArr}
        
        if roleList == nil || roleList?.count == 0 {
            let params:Dictionary<String,Int> = ["gameAccount.id": gameAccountId]
            
            BaseUtil.loadList(url: DBConstantUtil.queryRolePageList,params: params) { (dataList:NSArray) in
                for data in dataList {
                    if (data as AnyObject).isEqual(nil) { continue }
                    let _data = data as! NSDictionary
                    let gameAccount = anaylsRole(data: _data)
                    roleArr.append(gameAccount)
                }
            }
        } else {
            for role in roleList! {
                if role.gameAccount?.id == nil {
                    continue
                }
                
                if role.gameAccount?.id == gameAccountId {
                    roleArr.append(role)
                }
            }
        }
        
        return roleArr
    }
}
