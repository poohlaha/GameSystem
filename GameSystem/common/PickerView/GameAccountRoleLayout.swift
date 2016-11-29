//
//  GameAccountRoleLayout.swift
//  GameSystem
//
//  Created by Smile on 2016/11/28.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class GameAccountRoleLayout: UICollectionViewLayout {

    var itemW: CGFloat = 100
    var itemH: CGFloat = 100
    
    override init() {
        super.init()
        
        //设置每一个元素的大小
        self.itemSize = CGSizeMake(itemW, itemH)
        //设置滚动方向
        self.scrollDirection = .Horizontal
        //设置间距
        self.minimumLineSpacing = 0.7 * itemW
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //苹果推荐，对一些布局的准备操作放在这里
    override func prepare() {
        super.prepare()
    }
}
