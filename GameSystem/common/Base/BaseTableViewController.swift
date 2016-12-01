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
    
    var bottomConstraintConstant:CGFloat?
    
    //设置导航条属性
    func setNavigationBarProperties(navigationBar:UINavigationBar?) {
        //MARKS: 设置导航行背景及字体颜色
        //navigationBar?.barTintColor = ComponentUtil.fontColorGold
        //navigationBar?.tintColor = ComponentUtil.fontColorGreen
        
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: ComponentUtil.fontColorGold,forKey: NSForegroundColorAttributeName as NSCopying)
        navigationBar?.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
    }
    
    //获取TabBar
    func getRoleManageTabBar() -> RoleManageTabBarController?{
        return self.parent?.navigationController?.topViewController as? RoleManageTabBarController
    }
    
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

    
    func createCustomAlert(titles:[String],colors:[UIColor]) -> GameBottomAlert{
        return GameBottomAlert(frame: CGRect(x:0,y:-1,width:UIScreen.main.bounds.width,height:0), titles: titles,colors: colors,fontSize: 0)
    }
    
    func createLeftBarItem(){
        let leftBarItem = UIBarButtonItem(image: ComponentUtil.backImage, style: .plain, target: self, action: #selector(BaseTableViewController.back))
        leftBarItem.image = ComponentUtil.backImage
        self.navigationItem.leftBarButtonItem = leftBarItem
    }
    
    func back(){
        self.navigationController?.popViewController(animated: true)
        //self.getRoleManageTabBar()?.navigationController?.popViewController(animated: true)
    }
    
    //请求定时器
    func startRequestTimer(info:Any?,selector:Selector){
        Timer.scheduledTimer(timeInterval: ConstantUtil.httpRequestTime, target: self, selector: selector, userInfo: info, repeats: false)
    }
    
    func alert(title:String){
        let alertController = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default)
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
    
    override func viewDidDisappear(_ animated: Bool) {
        removeKeyboardEvent()
    }
    
    //调整section距离,0.1时为最小
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func removeKeyboardEvent(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    //添加键盘通知
    func addKeyboardEvent(){
        NotificationCenter.default.addObserver(self, selector: #selector(BaseTableViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseTableViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseTableViewController.keyboardDidShow), name:NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseTableViewController.keyboardDidHide), name:NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    var keyBoardHeight:CGFloat = 120
    var isKeyBoardShow:Bool = false
    /**
     *键盘改变,防止键盘遮挡输入框
     */
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo
        let value = userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        let duration = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        let curve = userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UInt
        let frame = value?.cgRectValue
       
        let keyboardinfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue
        let keyboardheight:CGFloat = keyboardinfo!.cgRectValue.size.height
        
        let selfFrame = self.tableView.frame
        
        if self.isKeyBoardShow == true { return }
        
        //改变下约束
        self.tableView.frame = CGRect(x: selfFrame.origin.x, y: selfFrame.origin.y - keyboardheight, width: selfFrame.width, height: selfFrame.height + keyboardheight)
        UIView.animate(withDuration: duration!, delay: 0.0,
                                       options: UIViewAnimationOptions(rawValue: curve!), animations: {
                                        _ in
                                        self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let userInfo = notification.userInfo
        let value = userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        let duration = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        let curve = userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UInt
        let selfFrame = self.tableView.frame
        if self.isKeyBoardShow == false { return }
        
        //改变下约束
        self.tableView.frame = CGRect(x: selfFrame.origin.x, y: 0, width: selfFrame.width, height: selfFrame.height)
        UIView.animate(withDuration: duration!, delay: 0.0,
                       options: UIViewAnimationOptions(rawValue: curve!), animations: {
                        _ in
                        
                        self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func keyboardDidShow(notification: NSNotification){
        print("键盘已经弹出")
        self.isKeyBoardShow = true
    }
    
    
    func keyboardDidHide(notification: NSNotification){
        print("键盘已经收回")
        self.isKeyBoardShow = false
    }
    

    //设置Section字体大小
   /* override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = getBackgroundColor()
        return view
    }*/
}
