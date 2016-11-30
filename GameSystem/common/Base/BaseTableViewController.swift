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
    
    //加载条
    var loadingView:Loading?
    
    //取消点击事件
    func setCellStyleNone(){
        for i in 0...tableView.numberOfSections - 1 {
            for j in 0...tableView.numberOfRows(inSection: i) - 1 {
                let indexPath = NSIndexPath(row: j, section: i)
                let cell = tableView.cellForRow(at: indexPath as IndexPath)
                cell?.selectionStyle = .none
            }
        }
        
    }

    //MARKS: 创建加载View
    func createLoadingView(){
        if loadingView == nil {
            let navigationHeight:CGFloat = 44 + ComponentUtil.statusBarFrame.height
            //let beginY:CGFloat = (self.view.frame.height - navigationHeight) / 2 - self.loadingViewHeight / 2
            //let beginX:CGFloat = self.view.frame.width / 2 - self.loadingViewWidth / 2
            
            loadingView = Loading(frame: CGRect(x: 0, y: navigationHeight, width: ComponentUtil.mainFrame.width, height: ComponentUtil.mainFrame.height))
            loadingView?.backgroundColor = ComponentUtil.backgroundBg
        }
        
        self.parent?.view.addSubview(loadingView!)
        //self.view.addSubview(loadingView!)
    }
    
    func removeLoadingView(){
        self.loadingView?.removeFromSuperview()
    }

    
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
    
    //请求定时器
    func startRequestTimer(info:Any?,selector:Selector){
        Timer.scheduledTimer(timeInterval: ConstantUtil.httpRequestTime, target: self, selector: selector, userInfo: info, repeats: false)
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
