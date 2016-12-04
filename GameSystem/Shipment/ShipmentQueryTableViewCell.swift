//
//  ShipmentQueryTableViewCell.swift
//  GameSystem
//
//  Created by Smile on 2016/12/1.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class ShipmentQueryTableViewCell: UITableViewCell {
    
    var leftView:UIImageView?
    var cellHeight:CGFloat?
    
    var roleView:UIView?//角色名称
    var shipmentCurrencyView:UIView?//发货游戏币数
    var cargoView:UIView?//货物
    var shipMoneyView:UIView?//发货金额
    var dateView:UIView?
    var isPaymentView:UIView?//是否付款
    var isBuybackView:UIView?//是否买回
    
    let topOrBottomPadding:CGFloat = 5
    let moduleSize:CGFloat = 4//模块个数
    let bottomHeight:CGFloat = 20//底部模块高度
    
    let leftOrRightPadding:CGFloat = 20
    
    let leftViewImage:UIImage = UIImage(named: "game-icon")!
    
    let roleViewLabelFont = UIFont.boldSystemFont(ofSize: 16)
    let viewLabelFont = UIFont(name: ComponentUtil.fontName, size: 16)
    let viewLabelFontBold = UIFont.boldSystemFont(ofSize: 16)
    let cargoFontBold = UIFont.boldSystemFont(ofSize: 16)
    let dateLabelFont = UIFont(name: ComponentUtil.fontName, size: 16)
    
    let viewLabelColor:UIColor = UIColor.darkGray
    let shipmentCurrencyBoldColor:UIColor = ComponentUtil.fontColorGreen//#00c896,发货游戏币颜色
    let cargoBoldColor:UIColor = UIColor.blue//货物颜色
    let isNotPaymentBoldColor:UIColor = UIColor.red//未付款颜色
    let shipMoneyBoldColor = ComponentUtil.fontColorGold
    
    let constantStr = "我"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?,cellHeight:CGFloat){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if self.isEqual(nil){ return}
        
        self.cellHeight = cellHeight
        initView()
        
    }
    
    //初始化视图
    func initView(){
        let leftViewSize:CGFloat = cellHeight! - topOrBottomPadding * 2
        self.leftView = UIImageView(image: leftViewImage)
        self.leftView?.frame = CGRect(x: leftOrRightPadding, y: topOrBottomPadding, width: leftViewSize, height: leftViewSize)
        //设置圆角
        self.leftView?.layer.masksToBounds = true
        self.leftView?.layer.cornerRadius = 5
        
        //初始化角色视图,自动计算高度,字体加租
        let rightViewWidth:CGFloat = UIScreen.main.bounds.width - leftViewSize - leftOrRightPadding * 2
        let roleViewWidth:CGFloat = rightViewWidth * 2 / 5 + 20
        let roleViewHeight:CGFloat = ComponentUtil.getLabelRect(width: roleViewWidth, height: 0, str: constantStr, font: roleViewLabelFont).size.height
        roleView = UIView(frame: CGRect(x: leftOrRightPadding + leftViewSize + topOrBottomPadding, y: topOrBottomPadding * 2, width: roleViewWidth, height: roleViewHeight))
        
        //计算时间view,放于rowView右侧,右靠齐
        dateView = UIView(frame: CGRect(x: (self.roleView?.frame.origin.x)! + roleViewWidth, y: topOrBottomPadding * 2, width: rightViewWidth - roleViewWidth, height: roleViewHeight))
        
        let cargoViewHeight:CGFloat = ComponentUtil.getLabelRect(width: roleViewWidth, height: 0, str: constantStr, font: cargoFontBold).size.height
        
        cargoView = UIView(frame: CGRect(x: (self.roleView?.frame.origin.x)!, y: (self.roleView?.frame.origin.y)! + roleViewHeight + topOrBottomPadding, width: rightViewWidth, height: cargoViewHeight))
        
        let eachWidth:CGFloat = rightViewWidth / moduleSize
        let bottomBeginY:CGFloat = cellHeight! - topOrBottomPadding - bottomHeight
        
        shipmentCurrencyView = UIView(frame:CGRect(x: (self.roleView?.frame.origin.x)!, y: bottomBeginY, width: eachWidth, height: bottomHeight))
        
        shipMoneyView = UIView(frame: CGRect(x: (self.shipmentCurrencyView?.frame.origin.x)! + eachWidth, y: bottomBeginY, width: eachWidth, height: bottomHeight))
        
        isPaymentView = UIView(frame:CGRect(x: (self.shipMoneyView?.frame.origin.x)! + eachWidth, y: bottomBeginY, width: eachWidth, height: bottomHeight))
        
        isBuybackView = UIView(frame:CGRect(x: (self.isPaymentView?.frame.origin.x)! + eachWidth, y: bottomBeginY, width: eachWidth, height: bottomHeight))
        
        self.contentView.addSubview(roleView!)
        self.contentView.addSubview(shipmentCurrencyView!)
        self.contentView.addSubview(cargoView!)
        self.contentView.addSubview(shipMoneyView!)
        self.contentView.addSubview(isPaymentView!)
        self.contentView.addSubview(isBuybackView!)
        self.contentView.addSubview(dateView!)
        self.contentView.addSubview(leftView!)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
