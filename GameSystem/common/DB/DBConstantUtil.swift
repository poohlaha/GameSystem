//
//  DBConstantUtil.swift
//  GameSystem
//
//  Created by Smile on 2016/11/22.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import Foundation

//存储url
class DBConstantUtil {
    static var baseUrl:String {
        return "http://localhost:8080/GameSystem"
    }
   
    //Login
    static let loginPageUrl:String = baseUrl + "/login"//
    static let loginUrl:String = baseUrl + "/validateLogin"
    static let loginSuccessUrl:String = baseUrl + "/index"
    
    //Game
    static let gameBaseUrl = baseUrl + "/game"
    static let queryGameList = gameBaseUrl + "/queryGameList"
    static let saveGame = gameBaseUrl + "/saveGame"
    static let updateGame = gameBaseUrl + "/updateGame"
    
    //Game Account
    static let gameAccountBaseUrl = baseUrl + "/gameAccount"
    static let queryGameAccountPageList = gameAccountBaseUrl + "/queryGameAccountPageList"
    static let saveGameAccount = gameAccountBaseUrl + "/saveGameAccount"
    static let updateGameAccount = gameAccountBaseUrl + "/updateGameAccount"
    static let deleteGameAccount = gameAccountBaseUrl + "/deleteGameAccount"
    
    //Role
    static let roleBaseUrl = baseUrl + "/role"
    static let queryRolePageList = roleBaseUrl + "/queryRolePageList"
    static let queryRoleById = roleBaseUrl + "/queryRoleById"
    static let saveRole = roleBaseUrl + "/saveRole"
    static let updateRole = roleBaseUrl + "/updateRole"
    static let deleteRole = roleBaseUrl + "/deleteRole"

    //Shipment
    static let shipmentBaseUrl = baseUrl + "/shipment"
    static let queryShipmentPageList = shipmentBaseUrl + "/queryShipmentPageList"
    static let saveShipment = shipmentBaseUrl + "/saveShipment"
    static let updateShipment = shipmentBaseUrl + "/updateShipment"
    static let deleteShipment = shipmentBaseUrl + "/deleteShipment"
    
    //ChargeAccount
    static let chargeAmountBaseUrl = baseUrl + "/chargeAmount"
    static let queryChargeAmountPageList = shipmentBaseUrl + "/queryChargeAmountPageList"
    static let saveChargeAmount = shipmentBaseUrl + "/saveChargeAmount"
    static let updateChargeAmount = shipmentBaseUrl + "/updateChargeAmount"
    static let deleteChargeAmount = shipmentBaseUrl + "/deleteChargeAmount"

}

struct GameUrls {
    
    
    
}
