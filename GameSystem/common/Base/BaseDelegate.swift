//
//  BaseDelegate.swift
//  GameSystem
//
//  Created by Smile on 2016/11/24.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import Foundation
@objc protocol RoleDelegate {
    @objc optional func callback(_ result:AnyObject) -> Dictionary<String,Any>
}
