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
        loadData()
    }

    //加载数据
    func loadData(){
        let params:Dictionary<String,Any> = ["pageNumber": 1,"pageSize":ConstantUtil.pageSize]
        self.totalList = RoleUtil.loadRoleList(params: params)
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
        let shipLabelText:String = (role.isRoleShip == 0) ? "可发货":"不可发货"
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
        let chargeLabelText:String = role.isRoleRecharge == 0 ? "可首充" : "不可首充"
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
                
                let alert = self.createCustomAlert(titles: self.titles,colors:self.colors){ (result,this) in
                    self.alertEvents(views: result as! Dictionary<String, Any>,role:role,alert: this as! GameBottomAlert)
                }
               
                let controller = self.parent
                controller?.view.addSubview(alert)
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
                        addShipment(role: role,alert:alert)
                    } else if i == 2 {//修改
                        updateRole(role: role,alert:alert)
                    } else if i == 3 {//取消
                        cancel(view: _view as! UIView,alert:alert)
                    }
                    
                }
            }
            
            i += 1
        }
    }
    
    //处理添加发货
    func addShipment(role:Role,alert:GameBottomAlert){
        print(role)
    }
    
    //处理修改角色
    func updateRole(role:Role,alert:GameBottomAlert){
        print(role)
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
