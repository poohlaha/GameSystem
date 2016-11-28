//
//  CommonUtil.swift
//  GameSystem
//
//  Created by Smile on 2016/11/9.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class CommonUtil: NSObject {

    
}

//扩展UITapGestureRecognizer,用于传递参数
class GameUITapGestureRecognizer:UITapGestureRecognizer{
    var data:[AnyObject]?
}

//扩展UILongPressGestureRecognizer(长按事件)
class GameUILongPressGestureRecognizer:UILongPressGestureRecognizer{
    var data:[AnyObject]?
}
