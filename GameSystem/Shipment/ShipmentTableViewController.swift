//
//  ShipmentTableViewController.swift
//  GameSystem
//
//  Created by Smile on 2016/11/20.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class ShipmentTableViewController: BaseTableViewController {

    @IBOutlet weak var addShipmentBtn: UIBarButtonItem!
    
    var totalList:[Shipment] = Array<Shipment>()
    
    let cellHeight:CGFloat = 80
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initFrame()
    }
    
    func initFrame(){
        self.navigationController?.isNavigationBarHidden = false
        createLeftBarItem()
        setNavigationBarProperties(navigationBar: self.navigationController?.navigationBar)
    }
    
    //初始化数据
    func initData(){
        self.createLoadingView()
        startRequestTimer(info:nil,selector: #selector(ShipmentTableViewController.loadAllShipmentsList))
    }
    
    //加载列表
    func loadAllShipmentsList(timer:Timer){
        self.totalList = ShipmentUtil.loadShipmentList(params: nil,callback: {
            self.removeLoadingView()
        })
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalList.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  cellHeight
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = ShipmentQueryTableViewCell(style: .default, reuseIdentifier: "Cell\(indexPath.section)\(indexPath.row)",cellHeight:self.cellHeight)
        
        //角色
        let shipment:Shipment = totalList[indexPath.row]
        let roleNameLabel:UILabel = ComponentUtil.createLabel(rect: CGRect(x:0,y:0,width:cell.roleView!.frame.width,height:cell.roleView!.frame.height), content: shipment.role!.roleName!, color: UIColor.black, textAlignment: .left, background: UIColor.clear, font:cell.roleViewLabelFont)
        cell.roleView?.addSubview(roleNameLabel)
        
        //发货游戏币
        let shipmentCurrencyLabel:UILabel = ComponentUtil.createLabel(rect: CGRect(x:0,y:0,width:cell.shipmentCurrencyView!.frame.width,height:cell.shipmentCurrencyView!.frame.height), content: "\(shipment.shipCurrency!)", color: cell.shipmentCurrencyBoldColor, textAlignment: .left, background: UIColor.clear, font:cell.viewLabelFontBold)
        cell.shipmentCurrencyView?.addSubview(shipmentCurrencyLabel)
        
        //货物
        let cargoLabel:UILabel = ComponentUtil.createLabel(rect: CGRect(x:0,y:0,width:cell.cargoView!.frame.width,height:cell.cargoView!.frame.height), content: shipment.cargo!, color: cell.cargoBoldColor, textAlignment: .left, background: UIColor.clear, font:cell.cargoFontBold)
        cell.cargoView?.addSubview(cargoLabel)
        
        let shipMoneyLabel = ComponentUtil.createLabel(rect: CGRect(x:0,y:0,width:cell.shipMoneyView!.frame.width,height:cell.shipMoneyView!.frame.height), content: "\(shipment.shipMoney!)", color: cell.shipMoneyBoldColor, textAlignment: .left, background: UIColor.clear, font:cell.viewLabelFontBold)
        cell.shipMoneyView?.addSubview(shipMoneyLabel)
        
        if shipment.isPayment != nil {
            if shipment.isPayment != 0 {
                let isPaymentLabel:UILabel = ComponentUtil.createLabel(rect: CGRect(x:0,y:0,width:cell.isPaymentView!.frame.width,height:cell.isPaymentView!.frame.height), content: "\(ConstantUtil.isRolePaymentData[1])", color: cell.isNotPaymentBoldColor, textAlignment: .left, background: UIColor.clear, font:cell.viewLabelFontBold)
                cell.isPaymentView?.addSubview(isPaymentLabel)

            }
        }
        
        if shipment.isBuyback != nil {
            if shipment.isBuyback != 0 {
                let isPaymentLabel:UILabel = ComponentUtil.createLabel(rect: CGRect(x:0,y:0,width:cell.isBuybackView!.frame.width,height:cell.isBuybackView!.frame.height), content: "\(ConstantUtil.isRoleBuybackData[1])", color: cell.isNotPaymentBoldColor, textAlignment: .left, background: UIColor.clear, font:cell.viewLabelFontBold)
                cell.isBuybackView?.addSubview(isPaymentLabel)
                
            }
        }
        
        //日期,先取最后更新时间,如果没有则取创建时间
        let dateLabelText:String = shipment.lastUpdateDateString!
        let dateLabel:UILabel = ComponentUtil.createLabel(rect: CGRect(x:0,y:0,width:cell.dateView!.frame.width,height:cell.dateView!.frame.height), content: dateLabelText, color: cell.viewLabelColor, textAlignment: .right, background: UIColor.clear, font:cell.dateLabelFont!)
        cell.dateView?.addSubview(dateLabel)
        
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = setSelectCellBackgroundColor()
        return cell
    }
    
    //点击事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shipment:Shipment = self.totalList[indexPath.row]
        //根据storyboard获取controller
        let sb = UIStoryboard(name:"shipment", bundle: nil)
        let shipmentDetailTableViewController = sb.instantiateViewController(withIdentifier: "ShipmentDetailTableViewController") as! ShipmentDetailTableViewController
        shipmentDetailTableViewController.hidesBottomBarWhenPushed = true
        shipmentDetailTableViewController.shipmentId = shipment.id
        self.navigationController?.pushViewController(shipmentDetailTableViewController, animated: true)
    }
    
    //MARKS: 开启tableview编辑模式
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    //MARKS: 自定义向右滑动菜单
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "修改") { (action, indexPath) in
            let shipment:Shipment = self.totalList[indexPath.row]
            self.addShipmentController(roleId: shipment.role?.id, flag: 1, shipment: shipment)
            //让cell可以自动回到默认状态，所以需要退出编辑模式
            tableView.isEditing = false
        }
        
        let detailAction = UITableViewRowAction(style: .normal, title: "查看") { (action, indexPath) in
            let shipment:Shipment = self.totalList[indexPath.row]
            //根据storyboard获取controller
            let sb = UIStoryboard(name:"shipment", bundle: nil)
            let shipmentDetailTableViewController = sb.instantiateViewController(withIdentifier: "ShipmentDetailTableViewController") as! ShipmentDetailTableViewController
            shipmentDetailTableViewController.hidesBottomBarWhenPushed = true
            shipmentDetailTableViewController.shipmentId = shipment.id
            self.navigationController?.pushViewController(shipmentDetailTableViewController, animated: true)
            //让cell可以自动回到默认状态，所以需要退出编辑模式
            tableView.isEditing = false
        }
       
        editAction.backgroundColor = ComponentUtil.fontColorBlue
        detailAction.backgroundColor = ComponentUtil.fontColorGreen
        
        return [editAction,detailAction]
    }
    
    
}
