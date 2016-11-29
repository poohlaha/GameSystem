//
//  GameAccountRoleViewCellCollectionViewCell.swift
//  GameSystem
//
//  Created by Smile on 2016/11/28.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class GameAccountRoleViewCellCollectionViewCell: UICollectionViewCell {
    
    var label:UILabel?
    
    private var leftOrRightPadding:CGFloat = 10
    private var topOrBottomPadding:CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFrame()
    }
    
    
    func initFrame(){
        label = ComponentUtil.createLabel(rect: CGRect(x:leftOrRightPadding,y:topOrBottomPadding,width:self.frame.width - leftOrRightPadding * 2,height:self.frame.height - topOrBottomPadding * 2), content: "", color: UIColor.black, textAlignment: .left, background: UIColor.clear, fontName: ComponentUtil.fontName, fontSize: 16)
        self.addSubview(label!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
