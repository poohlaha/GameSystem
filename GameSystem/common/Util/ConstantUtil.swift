//
//  Constant.swift
//  GameSystem
//
//  Created by Smile on 2016/11/9.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class ConstantUtil: NSObject {

    //系统名称
    static let systemName:String = "游戏管理系统"
    static let queryRoleName:String = "角色列表"
    
    static let mainBgColors:[UIColor] = [UIColor(red: 255/255, green: 201/255, blue: 57/255, alpha: 0.8),UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)]
    
    //首页边框里名称
    static let gameAccountManageText:String = "游戏账号管理"
    static let gameAccountManageTextEn:String = "Account Manage"
    
    static let shipmentManageText:String = "出货管理"
    static let shipmentManageTextEn:String = "Shipment Manage"
    
    static let roleManageText:String = "角色管理"
    static let roleManageTextEn:String = "Role Manage"
    
    static let reportManageText:String = "报表管理"
    static let reportManageTextEn:String = "Report Manage"
    
    static let chargeAccountManageText:String = "充值管理"
    static let chargeAccountManageTextEn:String = "Charge Manage"
    
    static let personManageText:String = "私人管理"
    static let personManageTextEn:String = "Personal Manage"
    
    static let roleManageTexts:[String] =  ["查询","角色"]//角色tab上显示文字
    
    static let messageTabImages:[UIImage] = [UIImage(named: "message")!,UIImage(named: "message-touch")!]
    
    static let roleManageTabImages:[UIImage] = [UIImage(named:"role-contact")!,UIImage(named:"role-contact-touch")!]
    
    static let pageSize:Int = 10
    
    static let isRoleRechargeData:[String] = ["可首充","不可首充"]
    static let isRoleRechargeDataValue:[Int] = [0,1]
    
    static let isRoleShipData:[String] = ["可发货","不可发货"]
    static let isRoleShipDataValue:[Int] = [0,1]
    
    static let names:[String] = ["game","gameAccount","role"]
    
    static let httpRequestTime:TimeInterval = 0.5
}


