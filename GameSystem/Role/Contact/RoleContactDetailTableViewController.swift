//
//  RoleContactDetailTableViewController.swift
//  GameSystem
//
//  Created by Smile on 2016/11/25.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class RoleContactDetailTableViewController: BaseTableViewController {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var roleNameLabel: UILabel!
    @IBOutlet weak var roleLevelLabel: UILabel!
    
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var gameAccountLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var isRoleShipLabel: UILabel!
    @IBOutlet weak var isRoleRechargeLabel: UILabel!
    @IBOutlet weak var shipmentBtn: UIButton!
    @IBOutlet weak var editRoleBtn: UIButton!
    
    
    var photoImage:UIImage?
    var roleId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFrame()
        initData()
    }
    
    //通过RoleId查找角色,显示在详情页面上
    func initData(){
        self.headerImageView.image = photoImage
        if roleId == nil { return }
        
        let params:Dictionary<String,Any> = ["id": roleId!]
        let role:Role = RoleUtil.queryRoleById(params: params)
        if role.isEqual(nil){ return }
        
        roleNameLabel.text = role.roleName ?? ""
        roleLevelLabel.text = "角色等级:\(role.roleLevel ?? 0)"
        
        currencyLabel.text = "\(role.currency ?? 0)"
        if role.isRoleShip == 0 {
            isRoleShipLabel.text = ConstantUtil.isRoleShipData[0]
            isRoleShipLabel.font = UIFont(name: ComponentUtil.fontNameBold, size: 18)
            isRoleShipLabel.textColor = ComponentUtil.fontColorGreen
        }else{
            isRoleShipLabel.text = ConstantUtil.isRoleShipData[1]
        }
       
        if role.isRoleRecharge == 0 {
            isRoleRechargeLabel.text = ConstantUtil.isRoleRechargeData[0]
            isRoleRechargeLabel.font = UIFont(name: ComponentUtil.fontNameBold, size: 18)
            isRoleRechargeLabel.textColor = ComponentUtil.fontColorBlue
        }else{
            isRoleRechargeLabel.text = ConstantUtil.isRoleRechargeData[1]
        }
        
        //设置游戏
        gameLabel.text = role.gameAccount?.game?.gameName ?? ""
        gameAccountLabel.text = role.gameAccount?.nickName ?? ""
    }
    
    //初始化页面属性
    func initFrame(){
        //tableView.separatorStyle = .none//取消分割线
        shipmentBtn.backgroundColor = ComponentUtil.fontColorGreen
        editRoleBtn.backgroundColor = ComponentUtil.fontColorBlue
        setCellStyleNone()
    }
    
    //取消点击事件
    func setCellStyleNone(){
        for i in 0...tableView.numberOfSections - 1 {
            for j in 0...tableView.numberOfRows(inSection: i) - 1 {
                let indexPath = NSIndexPath(row: j, section: i)
                let cell = tableView.cellForRow(at: indexPath as IndexPath)
                
                cell?.selectionStyle = .none
                
                if i == 2{
                    cell!.backgroundColor = UIColor.clear
                    //MARKS: 去掉最后一行cell的分割线
                    cell!.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
                    
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //编辑事件
    @IBAction func editRoleBtnClick(_ sender: AnyObject) {
        //根据storyboard获取controller
        let sb = UIStoryboard(name:"RoleContactDetail", bundle: nil)
        let roleEditController = sb.instantiateViewController(withIdentifier: "RoleEditTableViewController") as! RoleEditTableViewController
        roleEditController.hidesBottomBarWhenPushed = true
        prepareDetailForData(destinationController:roleEditController,roleId:roleId)
        self.navigationController?.pushViewController(roleEditController, animated: true)
    }
    
    //MARKS :跳转到下一个页面传值(手动)
    func prepareDetailForData(destinationController:RoleEditTableViewController,roleId:Int?){
        destinationController.roleId = roleId ?? 0
    }
    
    //发货事件
    @IBAction func shipmentBtnClick(_ sender: AnyObject) {
    }
}
