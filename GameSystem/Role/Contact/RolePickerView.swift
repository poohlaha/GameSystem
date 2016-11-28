//
//  RolePickerView.swift
//  GameSystem
//
//  Created by Smile on 2016/11/27.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

@objc protocol RolePickerViewDelegate {
    @objc optional func rolePickerViewDidSelectRow(row:Int)
}


class RolePickerView:UIView,UIPickerViewDelegate,UIPickerViewDataSource  {

    var pickerData:[String]?

    var pickerView:UIPickerView?
    
    private var roleView:UIView!
    
    var rolePickerViewDelegate:RolePickerViewDelegate?
    
    private var pickerViewRowHeight:CGFloat = 30
    
    private let toolbarHeight:CGFloat = 40
    
    let width:CGFloat = UIScreen.main.bounds.width
    let height:CGFloat = UIScreen.main.bounds.height / 3
    
    init(beginHeight:CGFloat,pickerData:[String]) {
        let _height:CGFloat = UIScreen.main.bounds.height - height
        
        super.init(frame:UIScreen.main.bounds)
        self.pickerData = pickerData
        
        self.roleView = UIView(frame: CGRect(x: 0, y: _height, width: width, height: height))
        var _viewHeight:CGFloat = 120
        if _viewHeight > (_height - toolbarHeight) {
            _viewHeight = (_height - toolbarHeight)
        }
        
        //toolbar
        let toolbarView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: toolbarHeight))
        toolbarView.backgroundColor = ComponentUtil.fontColorBlue
        //添加Button
        let buttonWidth:CGFloat = 50
        let buttonTopOrBottomPadding:CGFloat = 5
        let buttonHeight:CGFloat = toolbarHeight - buttonTopOrBottomPadding * 2
        let buttonRightPadding:CGFloat = 10
        
        let button:UIButton = BaseDrawView().drawButton(frame: CGRect(x: width - buttonRightPadding - buttonWidth, y: buttonTopOrBottomPadding, width: buttonWidth, height: buttonHeight), text: "确 定", isBorder: true, backgroundColor: ComponentUtil.fontColorGreen)
        button.setTitleColor(ComponentUtil.fontColorGreen, for: .highlighted)
        toolbarView.addSubview(button)
        
        //添加Button点击事件
        button.addTarget(self, action: #selector(RolePickerView.buttonClick), for: .touchUpInside)
        
        
        self.roleView.addSubview(toolbarView)
        
        let _viewBeginY:CGFloat = (height - _viewHeight) / 2
        let _view = UIView(frame:CGRect(x: 0, y: _viewBeginY, width: width, height: _viewHeight))
        
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: width, height: _view.frame.height))
        pickerView?.delegate = self
        pickerView?.dataSource = self
        //self.backgroundColor = ComponentUtil.backgroundColor
        _view.addSubview(pickerView!)
        
        self.roleView.backgroundColor = UIColor.white
        self.roleView.addSubview(_view)
        
        self.backgroundColor = ComponentUtil.backgroundBg
        self.addSubview(self.roleView)
    }
    
    func buttonClick(){
        let row = pickerView?.selectedRow(inComponent: 0)
        rolePickerViewDelegate?.rolePickerViewDidSelectRow!(row:row!)
        self.removeFromSuperview()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 设置行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerViewRowHeight
    }
    
    //选择事件
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //rolePickerViewDelegate?.rolePickerViewDidSelectRow!(row:row)
        //self.removeFromSuperview()
    }

}
