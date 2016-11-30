//
//  BaseTableViewController.swift
//  GameSystem
//
//  Created by Smile on 2016/11/24.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

     var customAlert:GameBottomAlert?
    
    func createCustomAlert(titles:[String],colors:[UIColor],callback:@escaping (_ result:AnyObject,_ this:AnyObject)->()) -> GameBottomAlert{
        return GameBottomAlert(frame: CGRect(x:0,y:-1,width:UIScreen.main.bounds.width,height:0), titles: titles,colors: colors,fontSize: 0) { (result,this) in
            callback(result,this)
        }
    }
    
    func createLeftBarItem(){
        let leftBarItem = UIBarButtonItem(image: ComponentUtil.backImage, style: .plain, target: self, action: #selector(BaseTableViewController.back))
        leftBarItem.image = ComponentUtil.backImage
        self.navigationItem.leftBarButtonItem = leftBarItem
    }
    
    func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //添加长按手势
    func initLongPressGestureRecognizer(action:Selector) -> GameUILongPressGestureRecognizer{
        let longPressGesutre = GameUILongPressGestureRecognizer(target: self, action: action)
        //长按时间为1秒
        longPressGesutre.minimumPressDuration = 1
        //允许5秒运动
        longPressGesutre.allowableMovement = 5
        //所需触摸1次
        longPressGesutre.numberOfTouchesRequired = 1
        return longPressGesutre
    }
    
    //MARKS: 设置背景色
    func getBackgroundColor() -> UIColor {
        return ComponentUtil.backgroundColor
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }else{
            return 0.1
        }
        
    }
    
    //调整section距离,0.1时为最小
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    //设置Section字体大小
   /* override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = getBackgroundColor()
        return view
    }*/
}
