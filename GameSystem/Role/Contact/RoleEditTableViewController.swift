//
//  RoleEditTableViewController.swift
//  GameSystem
//
//  Created by Smile on 2016/11/27.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//编辑角色
class RoleEditTableViewController: BaseTableViewController,RolePickerViewDelegate,GameAccountRoleBaseViewDelegate {

    @IBOutlet weak var roleNameTextField: UITextField!
    @IBOutlet weak var roleLevelTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var gameAccountBtn: UIButton!
    @IBOutlet weak var isRoleRechargeBtn: UIButton!
    @IBOutlet weak var gameIdLabel: UILabel!
    @IBOutlet weak var gameAccountIdLabel: UILabel!
    @IBOutlet weak var isRoleRechargeLabel: UILabel!
    @IBOutlet weak var roleIdLabel: UILabel!
    
    private var gameList:[Game] = []
    private var gameAccountList:[GameAccount] = []
    private var roleList:[Role] = []
    
    var roleId:Int?
    var role:Role = Role()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLeftBarItem()
        initFrame()
        
        self.createLoadingView()
        startRequestTimer(info:nil,selector: #selector(RoleEditTableViewController.initData))
    }
    
    //返回事件,添加提示对话框
   override func back() {
        let alertController = ComponentUtil.alert(title: RoleUtil.ROLEEDIT_TIP, message: "", isShowCancel: true, cancelCallBack: { (alertAction) in
                self.navigationController?.popViewController(animated: true)
            }) { (alertAction) in
                self.updateRole()
            }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func initFrame(){
        isRoleRechargeBtn.addTarget(self, action: #selector(RoleEditTableViewController.isRoleRechargeBtnClick), for: .touchUpInside)
        setCellStyleNone()
        //居左显示
        isRoleRechargeBtn.contentHorizontalAlignment = .left
        gameAccountBtn.addTarget(self, action: #selector(RoleEditTableViewController.gameAccountBtnClick), for: .touchUpInside)
        gameAccountBtn.contentHorizontalAlignment = .left
    }

    
    let gameAccountRolePickerViewHeight:CGFloat = 200
    func createGameAccountRoleView(gameSelectedData: Int?,gameAccountSelectedData:Int?,roleSelectedData:Int?) -> GameAccountRoleView {
        return GameAccountRoleView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - gameAccountRolePickerViewHeight, width: UIScreen.main.bounds.width, height: gameAccountRolePickerViewHeight), gameData:self.gameList,gameAccountData:self.gameAccountList,roleData:[],gameSelectedData: gameSelectedData,gameAccountSelectedData:gameAccountSelectedData,roleSelectedData:roleSelectedData)
    }
    
    func createRolePickerView() -> RolePickerView{
        let navigationHeight:CGFloat = (self.navigationController?.navigationBar.frame.height)! + ComponentUtil.statusBarFrame.height
        return RolePickerView(beginHeight:navigationHeight,pickerData: ConstantUtil.isRoleRechargeData)
    }
    
    //是否可首充点击事件
    func isRoleRechargeBtnClick() {
        resignKeyBoard()
        
        let rolePickerView = createRolePickerView()
        rolePickerView.rolePickerViewDelegate = self
        
        //设置默认选中
        rolePickerView.pickerView?.selectRow(role.isRoleRecharge ?? 0, inComponent: 0, animated: true)
        let controller = self.parent
        controller?.view.addSubview(rolePickerView)
    }
    
    //取消键盘
    func resignKeyBoard(){
        self.currencyTextField.resignFirstResponder()
        self.roleLevelTextField.resignFirstResponder()
        self.roleNameTextField.resignFirstResponder()
    }
    
    //游戏联动返回函数
    func gameAccountRoleBaseViewCallback(data:NSDictionary,view:GameAccountRoleView?) {
        let game = data["game"] as? Game ?? Game()
        let gameAccount = data["gameAccount"] as? GameAccount ?? GameAccount()
        let value = game.gameName! + " " + gameAccount.nickName!
        gameAccountBtn.setTitle(value, for: .normal)
        gameIdLabel.text = "\(game.id!)"
        gameAccountIdLabel.text = "\(gameAccount.id!)"
        view?.removeFromSuperview()
    }

    //游戏账号点击事件
    func gameAccountBtnClick(){
        resignKeyBoard()
        let gameId = Int(gameIdLabel.text!)
        let gameAccountId = Int(gameAccountIdLabel.text!)
        let gameAccountRoleView = createGameAccountRoleView(gameSelectedData: gameId,gameAccountSelectedData:gameAccountId,roleSelectedData:nil)
        
        gameAccountRoleView.viewDelegate = self
        let controller = self.parent
        controller?.view.addSubview(gameAccountRoleView)
    }
    
    //通过RoleId查找角色,显示在详情页面上
    func initData(timer:Timer){
        if roleId == nil { return }
        
        roleIdLabel.text = "\(roleId!)"
        //获取gamelist,gameaccountlist,rolelist
        
        let params:Dictionary<String,Any> = ["id": roleId!]
        self.role = RoleUtil.queryRoleById(params: params,callback: {
            let list:Dictionary<String,Array<AnyObject>> = GameUtil.loadAllList(callback:{
                self.removeLoadingView()
            }())
            
            if list.isEmpty || list.count == 0 { return }
            
            self.gameList = list["game"] as? [Game] ?? []
            self.gameAccountList = list["gameAccount"] as? [GameAccount] ?? []
            self.roleList = list["role"] as? [Role] ?? []
            
        }())
        if role.isEqual(nil){ return }
        
        roleNameTextField.text = role.roleName ?? ""
        roleLevelTextField.text = "\(role.roleLevel ?? 0)"
        
        currencyTextField.text = "\(role.currency ?? 0)"
        
        let roleRechargeText:String = (role.isRoleRecharge == 0) ? ConstantUtil.isRoleRechargeData[0] : ConstantUtil.isRoleRechargeData[1]
        //设置isRoleRecharge选中
        isRoleRechargeBtn.setTitle(roleRechargeText, for: .normal)
        isRoleRechargeLabel.text = "\(ConstantUtil.isRoleRechargeDataValue[role.isRoleRecharge!])"
        
        //设置游戏账号
        gameAccountBtn.setTitle((role.gameAccount?.game?.gameName)! + " " + (role.gameAccount?.nickName!)!, for: .normal)
        gameIdLabel.text = "\(role.gameAccount!.game!.id!)"
        gameAccountIdLabel.text = "\(role.gameAccount!.id!)"
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
    func rolePickerViewDidSelectRow(row:Int,view:RolePickerView) {
         let value = ConstantUtil.isRoleRechargeData[row]
         isRoleRechargeBtn.setTitle(value, for: .normal)
         isRoleRechargeLabel.text = "\(ConstantUtil.isRoleRechargeDataValue[row])"
    }
    
    //修改角色信息
    func updateRole(){
        //所有textfield回收键盘
        roleNameTextField.resignFirstResponder()
        roleLevelTextField.resignFirstResponder()
        currencyTextField.resignFirstResponder()
        
        let role = Role()
        role.id = Int(roleIdLabel.text!)
        
        let roleName:String = roleNameTextField.text ?? ""
        if roleName.isEmpty {
            alert(title: "角色名称不能为空!")
            return
        }
        
        role.roleName = roleName
        
        let roleLevel:String? = roleLevelTextField.text ?? ""
        if (roleLevel?.isEmpty)! {
            alert(title: "角色等级不能为空!")
            return
        }
        
        role.roleLevel = Int(roleLevel!)
        
        let currency:String? = currencyTextField.text ?? ""
        if (currency?.isEmpty)! {
            alert(title: "游戏币不能为空!")
            return
        }
        
        role.currency = Int(currency!)
        
        let gameId:String? = gameIdLabel.text ?? ""
        let gameAccountId:String? = gameAccountIdLabel.text ?? ""
        
        if (gameId?.isEmpty)! || (gameAccountId?.isEmpty)!{
            alert(title: "请选择游戏账号!")
            return
        }
        
        let isRoleRecharge:String = isRoleRechargeLabel.text ?? ""
        if isRoleRecharge.isEmpty {
            alert(title: "请选择是否可充!")
            return
        }
        
        let account = GameAccount()
        account.id = Int(gameAccountId!)
        role.gameAccount = account
        
        let game = Game()
        game.id = Int(gameId!)
        role.gameAccount?.game = game
        role.isRoleRecharge = Int(isRoleRecharge)
        
        createLoadingView()
        startRequestTimer(info:role,selector: #selector(RoleEditTableViewController.update))
    }
    
    func update(timer: Timer){
        let role = timer.userInfo as! Role
        RoleUtil.updateRole(role: role){ (resultCode:String,resultMessage:String) in
            self.removeLoadingView()
            if resultCode != "success" {
                self.alert(title: resultMessage)
                return
            }
            
            let alertController = UIAlertController(title: RoleUtil.ROLEEDIT_SUCCESS, message: "", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
                //self.performSegue(withIdentifier: "toEditRolePage", sender: nil)
                /*self.dismiss(animated: true, completion: {
                 })*/
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //完成事件
    @IBAction func doneClick(_ sender: AnyObject) {
        updateRole()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toEditRolePage"){
            let roleEditTableViewController:RoleEditTableViewController = segue.destination as! RoleEditTableViewController
            roleEditTableViewController.roleId = self.roleId
        }
    }
    
}
