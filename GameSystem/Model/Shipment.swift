//
//  Shipment.swift
//  GameSystem
//
//  Created by Smile on 2016/11/30.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import Foundation
class Shipment: BaseModel {
    
    var id:Int? = 0
    var buyBackCurrency:Int? = 0 //买回游戏币
    var consignee:String? = ""//收货人
    var shipBeforeCurrency:Int? = 0//发货前游戏币
    var shipAfterCurrency:Int? = 0//发货后游戏币
    var shipCurrency:Int? = 0//发货游戏币
    var shipName:String? = ""//发货人
    var cargo:String? = ""//货物
    var shipMoney:Float64? = 0.0//出货金额:出货元宝数/DEFAULT_CONFIG中的默认值
    var isPayment:Int? = 1//是否付款,0---已付款,1--未付款
    var isBuyback:Int? = 1//是否已买回来 0---已买回 1---未买回
    var role:Role?
}

class ShipmentUtil {
    
    static let SHIPMENTADD_SUCCESS = "添加发货记录成功!"
    static let SHIPMENTADD_FAILED = "添加发货记录失败!"
    static let SHIPMENTADD_TIP = "当前操作未保存,是否需要保存?"
    
    //解析Role数据
    static func anaylsShipment(data:NSDictionary) -> Shipment{
        let shipment = Shipment()
        shipment.id = data["id"] as? Int ?? 0
        shipment.buyBackCurrency = data["buyBackCurrency"] as? Int ?? 0
        shipment.consignee = data["consignee"] as? String ?? ""
        shipment.shipBeforeCurrency = data["shipBeforeCurrency"] as? Int ?? 0
        shipment.shipAfterCurrency = data["shipAfterCurrency"] as? Int ?? 0
        shipment.shipCurrency = data["shipCurrency"] as? Int ?? 0
        shipment.shipName = data["shipName"] as? String ?? ""
        shipment.isPayment = data["isPayment"] as? Int ?? 1
        shipment.isBuyback = data["isBuyback"] as? Int ?? 1
        shipment.createDateString = data["createDateString"] as? String ?? ""
        shipment.isDeleted = data["isDeleted"] as? Int ?? 0
        shipment.lastUpdateDateString = data["lastUpdateDateString"] as? String ?? ""
        
        //格式化日期去掉秒数
        let createDate = shipment.createDateString ?? ""
        if !createDate.isEmpty {
            shipment.createDateString = BaseUtil.formatDate(date: createDate)
        }
        
        let lastUpdateDate = shipment.lastUpdateDateString ?? ""
        if !lastUpdateDate.isEmpty {
            shipment.lastUpdateDateString = BaseUtil.formatDate(date: lastUpdateDate)
        } else {
            shipment.lastUpdateDateString = shipment.createDateString ?? ""
        }
        
        //role
        let roleArr = data["role"] as! NSDictionary
        if roleArr.isEqual(nil) || roleArr.count == 0 { return shipment}
        shipment.role = RoleUtil.anaylsRole(data: roleArr)
        return shipment
    }
    
    static func saveShipment(shipment:Shipment,callback:@escaping (_ resultCode:String,_ resultMessage:String)->()) {
        BaseUtil.load(url: DBConstantUtil.saveShipment,params: convertToStr(shipment: shipment)) { (result:NSDictionary) in
            let json = result as! Dictionary<String,Any>
            let resultCode = json["resultCode"] as? String
            let resultMessage = json["resultMessage"]  as? String
            callback(resultCode!,resultMessage!)
        }
    }
    
    static func convertToStr(shipment:Shipment) -> Dictionary<String,Any> {
        var str:Dictionary<String,Any> = [:]
        str["id"] = shipment.id
        str["buyBackCurrency"] = shipment.buyBackCurrency
        str["consignee"] = shipment.consignee
        str["shipCurrency"] = shipment.shipCurrency
        str["isPayment"] = shipment.isPayment ?? 1
        str["isBuyback"] = shipment.isBuyback ?? 1
        str["cargo"] = shipment.cargo
        if shipment.role != nil {
            str["role.id"] = shipment.role?.id ?? 0
        }
        
        return str
    }


}

