//
//  MainBgView.swift
//  GameSystem
//
//  Created by Smile on 2016/11/22.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//主试图点击改变背景颜色
class MainBgView: UIView {

   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        changeBgColor()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        changeBgColor()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        changeBgColor()
    }
    
    //改变背景颜色
    func changeBgColor(){
        if self.backgroundColor == ConstantUtil.mainBgColors[0] {
            self.backgroundColor = ConstantUtil.mainBgColors[1]
        } else {
            self.backgroundColor = ConstantUtil.mainBgColors[0]
        }
    }
    
}
