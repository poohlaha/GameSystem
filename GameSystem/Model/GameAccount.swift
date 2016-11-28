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
