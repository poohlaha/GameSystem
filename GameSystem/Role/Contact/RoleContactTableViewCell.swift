//
//  RoleContactTableViewCell.swift
//  GameSystem
//
//  Created by Smile on 2016/11/25.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class RoleContactTableViewCell: UITableViewCell {
    
    var leftView:UIImageView?
    var cellHeight:CGFloat?
    
    var roleNameView:UIView?
    
    let topOrBottomPadding:CGFloat = 5
    let leftOrRightPadding:CGFloat = 20
    var leftViewImage:UIImage?
    
    let roleNameLabelFont = UIFont(name: ComponentUtil.fontName, size: 16)
    let roleNameLabelColor:UIColor = UIColor.black
    
    let constantStr = "我"
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?,leftViewImage:UIImage,cellHeight:CGFloat){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if self.isEqual(nil){ return}
        
        self.cellHeight = cellHeight
        self.leftViewImage = leftViewImage
        initView()
        
    }
    
    //初始化视图
    func initView(){
        let leftViewSize:CGFloat = cellHeight! - topOrBottomPadding * 2
        self.leftView = UIImageView(image: leftViewImage)
        self.leftView?.frame = CGRect(x: leftOrRightPadding, y: topOrBottomPadding, width: leftViewSize, height: leftViewSize)
        //设置圆角
        self.leftView?.layer.masksToBounds = true
        self.leftView?.layer.cornerRadius = leftViewSize / 2
        
        //初始化角色名字视图
        let roleNameViewWidth:CGFloat = UIScreen.main.bounds.width - leftViewSize - leftOrRightPadding * 2
        let roleNameViewHeight:CGFloat = ComponentUtil.getLabelRect(width: roleNameViewWidth, height: 0, str: self.constantStr, font: self.roleNameLabelFont!).size.height
        let roleNameViewBeginY:CGFloat = (cellHeight! - roleNameViewHeight) / 2
        self.roleNameView = UIView(frame: CGRect(x: leftOrRightPadding + leftViewSize + topOrBottomPadding, y: roleNameViewBeginY, width: roleNameViewWidth, height: roleNameViewHeight))
        
        self.contentView.addSubview(leftView!)
        self.contentView.addSubview(roleNameView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
