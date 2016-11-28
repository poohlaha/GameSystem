//
//  RoleEditTableViewController.swift
//  GameSystem
//
//  Created by Smile on 2016/11/27.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//编辑角色
class RoleEditTableViewController: BaseTableViewController,RolePickerViewDelegate {

    @IBOutlet weak var roleNameTextField: UITextField!
    @IBOutlet weak var gameAccountPickerView: UIPickerView!
    @IBOutlet weak var roleLevelTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    //@IBOutlet weak var isRoleRechargeView: UIView!
    
    @IBOutlet weak var isRoleRechargeBtn: UIButton!
    var roleId:Int?
    var role:Role = Role()
    //var isRoleRechargeLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFrame()
        initData()
    }
    
    func initFrame(){
        isRoleRechargeBtn.addTarget(self, action: #selector(RoleEditTableViewController.isRoleRechargeView), for: .touchUpInside)
        setCellStyleNone()
        //居左显示
        isRoleRechargeBtn.contentHorizontalAlignment = .left
        
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
    
    func createRolePickerView() -> RolePickerView{
        let navigationHeight:CGFloat = (self.navigationController?.navigationBar.frame.height)! + ComponentUtil.statusBarFrame.height
        return RolePickerView(beginHeight:navigationHeight,pickerData: ConstantUtil.isRoleRechargeData)
    }
    
    func isRoleRechargeView() {
        let rolePickerView = createRolePickerView()
        rolePickerView.rolePickerViewDelegate = self
        
        //设置默认选中
        rolePickerView.pickerView?.selectRow(role.isRoleRecharge ?? 0, inComponent: 0, animated: true)
        let controller = self.parent
        controller?.view.addSubview(rolePickerView)
    }

    
    //通过RoleId查找角色,显示在详情页面上
    func initData(){
        if roleId == nil { return }
        
        let params:Dictionary<String,Any> = ["id": roleId!]
        self.role = RoleUtil.queryRoleById(params: params)
        if role.isEqual(nil){ return }
        
        roleNameTextField.text = role.roleName ?? ""
        roleLevelTextField.text = "\(role.roleLevel ?? 0)"
        
        currencyTextField.text = "\(role.currency ?? 0)"
        
        let roleRechargeText:String = (role.isRoleRecharge == 0) ? ConstantUtil.isRoleRechargeData[0] : ConstantUtil.isRoleRechargeData[1]
        //设置isRoleRecharge选中
        isRoleRechargeBtn.setTitle(roleRechargeText, for: .normal)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        }else{
            return 0.1
        }
        
    }
    
    //调整section距离,0.1时为最小
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //rolePickerView选择事件
    func rolePickerViewDidSelectRow(row:Int) {
         let value = ConstantUtil.isRoleRechargeData[row]
         isRoleRechargeBtn.setTitle(value, for: .normal)
         print(value)
    }

}
