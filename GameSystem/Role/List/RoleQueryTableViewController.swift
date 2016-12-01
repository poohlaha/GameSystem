//
//  RoleQueryTableViewController.swift
//  GameSystem
//
//  Created by Smile on 2016/11/23.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class RoleQueryTableViewController: BaseTableViewController {

    var totalList:[Role] = Array<Role>()
    
    let titles:[String] =  ["","出货","编辑","取消"]
    let colors:[UIColor] = [UIColor.black,UIColor(red: 0/255, green: 200/255, blue: 150/255, alpha: 0.8),UIColor.blue,UIColor.black]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.style = .grouped
        //BaseView.setNavigationBarProperties(navigationBar: (navigationBar!))
       
    }
    
    func initFrame(){
        self.createLoadingView()
        startRequestTimer(info:nil,selector: #selector(RoleQueryTableViewController.loadData))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initFrame()
    }

    //加载数据,查询所有可发货的列表
    func loadData(timer:Timer){
        let params:Dictionary<String,Any> = ["pageNumber": 1,"pageSize":ConstantUtil.pageSize,"isRoleShip":ConstantUtil.isRoleShipDataValue[0]]
        
        self.totalList = RoleUtil.loadRoleList(params: params,callback: {
            self.removeLoadingView()
        })
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 0.1
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return totalList.count
    }
    
    
    let cellHeight:CGFloat = 80
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = RoleQueryTableViewCell(style: .default, reuseIdentifier: "Cell\(indexPath.section)\(indexPath.row)",cellHeight:self.cellHeight)
        
        //角色
        let role:Role = totalList[indexPath.row]
        let roleNameLabel:UILabel = ComponentUtil.createLabel(rect: CGRect(x:0,y:0,width:cell.roleView!.frame.width,height:cell.roleView!.frame.height), content: role.roleName!, color: UIColor.black, textAlignment: .left, background: UIColor.clear, font:cell.roleViewLabelFont)
        cell.roleView?.addSubview(roleNameLabel)
        
        //游戏币
        let currencyLabel:UILabel = ComponentUtil.createLabel(rect: CGRect(x:0,y:0,width:cell.currencyView!.frame.width,height:cell.currencyView!.frame.height), content: "\(role.currency!)", color: cell.currencyLabelColor, textAlignment: .left, background: UIColor.clear, font:cell.viewLabelFontBold)
        cell.currencyView?.addSubview(currencyLabel)
        
        //是否可发货
        let shipLabelText:String = (role.isRoleShip == 0) ? ConstantUtil.isRoleShipData[0] : ConstantUtil.isRoleShipData[1]
        var shipLabel:UILabel?
        var shipColor:UIColor?
        var shipFont:UIFont?
        if role.isRoleShip == 0 {//可发货
            shipColor =  cell.roleShipBoldColor
            shipFont = cell.viewLabelFontBold
        }else{
           shipColor = cell.viewLabelColor
           shipFont = cell.viewLabelFontBold
        }
        
        shipLabel = ComponentUtil.createLabel(rect: CGRect(x:0,y:0,width:cell.shipView!.frame.width,height:cell.shipView!.frame.height), content: shipLabelText, color: shipColor!, textAlignment: .left, background: UIColor.clear, font:shipFont!)

        cell.shipView?.addSubview(shipLabel!)
        
        //是否可首充
        let chargeLabelText:String = role.isRoleRecharge == 0 ? ConstantUtil.isRoleRechargeData[0] : ConstantUtil.isRoleRechargeData[1]
        var chargeLabel:UILabel?
        var chargeColor:UIColor?
        var chargeFont:UIFont?
        if role.isRoleRecharge == 0 {//可首充
            chargeColor = cell.rechargeBoldColor
            chargeFont = cell.rechargeLabelFontBold
            
            chargeLabel = ComponentUtil.createLabel(rect: CGRect(x:0,y:0,width:cell.reChargeView!.frame.width,height:cell.reChargeView!.frame.height), content: chargeLabelText, color: chargeColor!, textAlignment: .right, background: UIColor.clear, font:chargeFont!)
            
            cell.reChargeView?.addSubview(chargeLabel!)
        }

        //日期,先取最后更新时间,如果没有则取创建时间
        let dateLabelText:String = ((role.lastUpdateDateString?.isEmpty)! ? role.createDateString : role.lastUpdateDateString)!
        let dateLabel:UILabel = ComponentUtil.createLabel(rect: CGRect(x:0,y:0,width:cell.dateView!.frame.width,height:cell.dateView!.frame.height), content: dateLabelText, color: cell.viewLabelColor, textAlignment: .right, background: UIColor.clear, font:cell.dateLabelFont!)
        cell.dateView?.addSubview(dateLabel)
        
        //添加长按手势事件
        let longPressGesutre = self.initLongPressGestureRecognizer(action: #selector(RoleQueryTableViewController.handleLongpressGesture(gestrue:)))
        longPressGesutre.data = [role]
        cell.contentView.addGestureRecognizer(longPressGesutre)
        return cell
    }
    
    func handleLongpressGesture(gestrue: GameUILongPressGestureRecognizer) {
        if gestrue.state == UIGestureRecognizerState.began{
            if gestrue.data != nil && (gestrue.data?.count)! > 0 {
                let role:Role = gestrue.data![0] as! Role
                //self.parent?.view.bringSubview(toFront: customAlert!)
                
                let alert = self.createCustomAlert(titles: self.titles,colors:self.colors)
                let controller = self.parent
                controller?.view.addSubview(alert)
                self.alertEvents(views: alert.views,role:role,alert: alert)
            }
        }
    }
    
    func alertEvents(views:Dictionary<String, Any>,role:Role,alert:GameBottomAlert) {
        var i:Int = 0
        for title in self.titles {
            if title.isEmpty {
                i += 1
                continue
            }
            
            for view in views {
                let name = view.0
                let _view = view.1
                if name == title {
                    if (_view as AnyObject).isEqual(nil){
                        i += 1
                        continue
                    }
                    
                    if i == 1 {//发货
                        addShipment(view: _view as! UIView,role: role,alert:alert)
                    } else if i == 2 {//修改
                        updateRole(view: _view as! UIView,role: role,alert:alert)
                    } else if i == 3 {//取消
                        cancel(view: _view as! UIView,alert:alert)
                    }
                    
                }
            }
            
            i += 1
        }
    }
    
    //处理添加发货
    func addShipment(view:UIView,role:Role,alert:GameBottomAlert){
        let addShipmentTap = GameUITapGestureRecognizer(target: self, action: #selector(RoleQueryTableViewController.addShipmentGameUITapGestureRecognizer(tap:)))
        addShipmentTap.data = [role,alert]
        view.addGestureRecognizer(addShipmentTap)
        
    }
    
    //发货点击事件
    func addShipmentGameUITapGestureRecognizer(tap:GameUITapGestureRecognizer){
        var roleId:Int = 0
        var alert:GameBottomAlert?
        if (tap.data != nil) && (tap.data?.count)! > 0{
            let role:Role = tap.data?[0] as! Role
            roleId = role.id!
            alert = tap.data?[1] as? GameBottomAlert
        }
        
        
        //根据storyboard获取controller
        let sb = UIStoryboard(name:"shipment", bundle: nil)
        let addShipmentTableViewController = sb.instantiateViewController(withIdentifier: "AddShipmentTableViewController") as! AddShipmentTableViewController
        addShipmentTableViewController.hidesBottomBarWhenPushed = true
        addShipmentTableViewController.roleId = roleId
        self.navigationController?.pushViewController(addShipmentTableViewController, animated: true)
        alert?.removeFromSuperview()
    }
    
    //处理修改角色
    func updateRole(view:UIView,role:Role,alert:GameBottomAlert){
        let editRoleTap = GameUITapGestureRecognizer(target: self, action: #selector(RoleQueryTableViewController.editRoleGameUITapGestureRecognizer(tap:)))
        editRoleTap.data = [role,alert]
        view.addGestureRecognizer(editRoleTap)
    }
    
    //修改角色点击事件
    func editRoleGameUITapGestureRecognizer(tap:GameUITapGestureRecognizer){
        var roleId:Int = 0
        var alert:GameBottomAlert?
        if (tap.data != nil) && (tap.data?.count)! > 0{
            let role:Role = tap.data?[0] as! Role
            roleId = role.id!
            alert = tap.data?[1] as? GameBottomAlert
        }

        //根据storyboard获取controller
        let sb = UIStoryboard(name:"RoleContactDetail", bundle: nil)
        let roleEditController = sb.instantiateViewController(withIdentifier: "RoleEditTableViewController") as! RoleEditTableViewController
        roleEditController.hidesBottomBarWhenPushed = true
        roleEditController.roleId = roleId
        self.navigationController?.pushViewController(roleEditController, animated: true)
        alert?.removeFromSuperview()
    }
    
    //处理取消
    func cancel(view:UIView,alert:GameBottomAlert){
        let cancelTap = GameUITapGestureRecognizer(target: self, action: #selector(RoleQueryTableViewController.cacelEvent(tap:)))
        cancelTap.data = [alert]
        view.addGestureRecognizer(cancelTap)
    }
    
    //取消点击事件
    func cacelEvent(tap:GameUITapGestureRecognizer){
        if (tap.data != nil) && (tap.data?.count)! > 0{
            (tap.data?[0] as! GameBottomAlert).removeFromSuperview()
        }
    }
    
    //MARKS: 计算行高
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

}
