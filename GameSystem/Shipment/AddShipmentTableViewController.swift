//
//  AddShipmentTableViewController.swift
//  GameSystem
//
//  Created by Smile on 2016/11/30.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class AddShipmentTableViewController: BaseTableViewController,RolePickerViewDelegate,GameAccountRoleBaseViewDelegate {

    
    @IBOutlet weak var gameAccountRoleBtn: UIButton!
    @IBOutlet weak var gameAccountRoleLabel: UILabel!
    @IBOutlet weak var gameIdLabel: UILabel!
    @IBOutlet weak var gameAccountIdLabel: UILabel!
    @IBOutlet weak var roleIdLabel: UILabel!
    
    @IBOutlet weak var consigneeTextField: UITextField!
    @IBOutlet weak var cargoTextField: UITextField!
    @IBOutlet weak var shipCurrencyTextField: UITextField!
    @IBOutlet weak var buyBackCurrencyTextField: UITextField!
    @IBOutlet weak var isPaymentBtn: UIButton!
    @IBOutlet weak var isBuybackBtn: UIButton!
    @IBOutlet weak var isPaymentLabel: UILabel!
    @IBOutlet weak var isBuybackLabel: UILabel!

    @IBOutlet weak var roleCurrencyLabel: UILabel!
    var roleId:Int? //如果有角色id表示直接行踪角色进行发货
    var role:Role?
    
    var navigationHeight:CGFloat = 0
    var isPaymentPickerView:RolePickerView?
    var isBuybackPickerView:RolePickerView?
    
    private var gameList:[Game] = []
    private var gameAccountList:[GameAccount] = []
    private var roleList:[Role] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationHeight = (self.navigationController?.navigationBar.frame.height)! + ComponentUtil.statusBarFrame.height
        setCellStyleNone()
        
        isPaymentBtn.addTarget(self, action: #selector(AddShipmentTableViewController.isPaymentBtnClick), for: .touchUpInside)
        isBuybackBtn.addTarget(self, action: #selector(AddShipmentTableViewController.isBuybackBtnClick), for: .touchUpInside)
        //居左显示
        isPaymentBtn.contentHorizontalAlignment = .left
        //居左显示
        isBuybackBtn.contentHorizontalAlignment = .left
        
        addKeyboardEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         initFrame()
    }
    
    func initFrame(){
        createLeftBarItem()
        if self.roleId != nil {
            gameAccountRoleBtn.isHidden = true
            
            self.createLoadingView()
            startRequestTimer(info:nil,selector: #selector(AddShipmentTableViewController.initData))
        } else {
            gameAccountRoleLabel.isHidden = true
            
            self.createLoadingView()
            startRequestTimer(info:nil,selector: #selector(AddShipmentTableViewController.initList))
            gameAccountRoleBtn.contentHorizontalAlignment = .left
        }
        
        isPaymentBtn.setTitle(ConstantUtil.isRolePaymentData[1], for: .normal)
        isBuybackBtn.setTitle(ConstantUtil.isRoleBuybackData[1], for: .normal)
        isPaymentLabel.text = "\(ConstantUtil.isRolePaymentDataValue[1])"
        isBuybackLabel.text = "\(ConstantUtil.isRoleBuybackDataValue[1])"
        
     }
    
    //获取gamelist,gameaccountlist,rolelist
    func initList(timer:Timer){
        let list:Dictionary<String,Array<AnyObject>> = GameUtil.loadAllList(callback:{
            self.removeLoadingView()
        }())
        
        if list.isEmpty || list.count == 0 { return }
        
        self.gameList = list["game"] as? [Game] ?? []
        self.gameAccountList = list["gameAccount"] as? [GameAccount] ?? []
        self.roleList = list["role"] as? [Role] ?? []
    }

    let gameAccountRolePickerViewHeight:CGFloat = 200
    func createGameAccountRoleView(gameData:[Game],gameAccountData:[GameAccount],roleData:[Role],gameSelectedData: Int?,gameAccountSelectedData:Int?,roleSelectedData:Int?) -> GameAccountRoleView {
        return GameAccountRoleView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - gameAccountRolePickerViewHeight, width: UIScreen.main.bounds.width, height: gameAccountRolePickerViewHeight), gameData:gameData,gameAccountData:gameAccountData,roleData:roleData,gameSelectedData: gameSelectedData,gameAccountSelectedData:gameAccountSelectedData,roleSelectedData:roleSelectedData)
    }
    
    //是否付款点击事件
    func isPaymentBtnClick() {
        reginKeyboard()
        self.isPaymentPickerView = createPickerView(pickerData: ConstantUtil.isRolePaymentData)
        self.isPaymentPickerView?.viewName = "isPaymentPickerView"
        //设置默认选中否
        self.isPaymentPickerView?.pickerView?.selectRow(ConstantUtil.isRoleRechargeDataValue[1], inComponent: 0, animated: true)
    }
    
    //是否买回点击事件
    func isBuybackBtnClick(){
        reginKeyboard()
        self.isBuybackPickerView = createPickerView(pickerData: ConstantUtil.isRoleBuybackData)
        self.isBuybackPickerView?.viewName = "isBuybackPickerView"
        //设置默认选中否
        self.isBuybackPickerView?.pickerView?.selectRow(ConstantUtil.isRoleRechargeDataValue[1], inComponent: 0, animated: true)
    }
    
    func createPickerView(pickerData:[String]) -> RolePickerView{
        let rolePickerView = RolePickerView(beginHeight:navigationHeight,pickerData: pickerData)
        rolePickerView.rolePickerViewDelegate = self
        let controller = self.parent
        controller?.view.addSubview(rolePickerView)
        return rolePickerView
    }
    
    //选中事件
    func rolePickerViewDidSelectRow(row: Int,view:RolePickerView) {
        if view.viewName == "isPaymentPickerView" {
            let value = ConstantUtil.isRolePaymentData[row]
            self.isPaymentBtn.setTitle(value, for: .normal)
            self.isPaymentLabel.text = "\(ConstantUtil.isRolePaymentDataValue[row])"
        } else if view.viewName == "isBuybackPickerView" {
            let value = ConstantUtil.isRoleBuybackData[row]
            self.isBuybackBtn.setTitle(value, for: .normal)
            self.isBuybackLabel.text = "\(ConstantUtil.isRoleBuybackDataValue[row])"
        }
    }
    
    //初始化数据
    func initData(timer:Timer){
        if roleId == nil { return }
        
        let params:Dictionary<String,Any> = ["id": roleId!]
        self.role = RoleUtil.queryRoleById(params: params,callback: {
            self.removeLoadingView()
        }())
        
        if self.role == nil { return }
        
        let roleName = role?.roleName ?? ""
        var gameName:String = ""
        var accountName:String = ""
        
        roleIdLabel.text = "\(role?.id!)"
        if role?.gameAccount != nil {
            accountName = role?.gameAccount?.nickName ?? ""
            gameAccountIdLabel.text = "\(role?.gameAccount?.id!)"
            
            if role?.gameAccount?.game != nil {
                gameName = role?.gameAccount?.game?.gameName ?? ""
                gameIdLabel.text = "\(role?.gameAccount?.game?.id!)"
            }
        }
        
        let roleCurrency = role?.currency! ?? 0
        roleCurrencyLabel.text = "\(roleCurrency)"
        roleCurrencyLabel.textColor = ComponentUtil.fontColorGold
        
        gameAccountRoleLabel.text = gameName + " " + accountName + " " + roleName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    //完成事件
    @IBAction func doneClick(_ sender: AnyObject) {
        addShipment()
    }
    
    //取消键盘
    func reginKeyboard(){
        self.consigneeTextField.resignFirstResponder()
        self.cargoTextField.resignFirstResponder()
        self.shipCurrencyTextField.resignFirstResponder()
        self.buyBackCurrencyTextField.resignFirstResponder()
    }
    
    func addShipment(){
        reginKeyboard()
        let shipment = Shipment()
        let role = Role()
        if self.roleId != nil {
            role.id = self.roleId!
            shipment.role = role
        } else {//验证游戏,账号,角色
            var roleId:Int?
            let roleIdText = roleIdLabel.text ?? ""
            
            if roleIdText.isEmpty {
                self.alert(title: "请选择发货角色!")
                return
            }
            
            role.id = Int(roleIdText)
            shipment.role = role
        }
        
        let consignee = consigneeTextField.text ?? ""
        if consignee.isEmpty {
            self.alert(title: "收货人不能为空!")
            return
        }
        
        shipment.consignee = consignee
        
        let cargo = cargoTextField.text ?? ""
        if cargo.isEmpty {
            self.alert(title: "货物不能为空!")
            return
        }
        
        shipment.cargo = cargo
        
        let shipCurrency = shipCurrencyTextField.text ?? ""
        if shipCurrency.isEmpty {
            self.alert(title: "出货游戏币不能为空!")
            return
        }
        
        shipment.shipCurrency = Int(shipCurrency)
        
        let buyBackCurrency = buyBackCurrencyTextField.text ?? ""
        if buyBackCurrency.isEmpty {
            self.alert(title: "买回游戏币不能为空!")
            return
        }
        
        shipment.buyBackCurrency = Int(buyBackCurrency)
        shipment.isPayment = Int(isPaymentLabel.text!)
        shipment.isBuyback = Int(isBuybackLabel.text!)
        
        createLoadingView()
        startRequestTimer(info: shipment, selector: #selector(AddShipmentTableViewController.add))
    }
    
    
    func add(timer: Timer){
        let shipment = timer.userInfo as! Shipment
        ShipmentUtil.saveShipment(shipment: shipment){ (resultCode:String,resultMessage:String) in
            self.removeLoadingView()
            if resultCode != "success" {
                self.alert(title: resultMessage)
                return
            }
            
            let alertController = UIAlertController(title: ShipmentUtil.SHIPMENTADD_SUCCESS, message: "", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func gameAccountRoleBaseViewCallback(data: NSDictionary, view: GameAccountRoleView?) {
        let game = data["game"] as? Game ?? Game()
        let gameAccount = data["gameAccount"] as? GameAccount ?? GameAccount()
        let role = data["role"] as? Role ?? Role()
        
        let gameName:String = game.gameName ?? ""
        let accountName:String = gameAccount.nickName ?? ""
        let roleName = role.roleName ?? ""
        
        if game.id != nil {
            gameIdLabel.text = "\(game.id!)"
        }
        
        if gameAccount.id != nil {
            gameAccountIdLabel.text = "\(gameAccount.id!)"
        }
        
        if role.id != nil {
            roleIdLabel.text = "\(role.id!)"
        }
        
        gameAccountRoleBtn.setTitle(gameName + " " + accountName + " " + roleName, for: .normal)
        view?.removeFromSuperview()
        
        let params:Dictionary<String,Any> = ["id": role.id!]
        let r = RoleUtil.queryRoleById(params: params,callback: {
           
        }())
        
        let roleCurrency = r.currency!
        roleCurrencyLabel.text = "\(roleCurrency)"
        roleCurrencyLabel.textColor = ComponentUtil.fontColorGold
    }
    
    /*var gameView:GameAccountRoleView?
    var gameAccountViw:GameAccountRoleView?
    var roleView:GameAccountRoleView?*/
    //游戏账号角色点击事件
    @IBAction func gameAccountRoleClick(_ sender: AnyObject) {
        reginKeyboard()
        var gameId:Int?
        var gameAccountId:Int?
        var roleId:Int?
        
        let gameIdText = gameIdLabel.text ?? ""
        let gameAccountIdText = gameAccountIdLabel.text ?? ""
        let roleIdText = roleIdLabel.text ?? ""
        
        if !gameIdText.isEmpty {
            gameId = Int(gameIdText)
        }
        
        if !gameAccountIdText.isEmpty {
            gameAccountId = Int(gameAccountIdText)
        }
        
        if !roleIdText.isEmpty {
            roleId = Int(roleIdText)
        }
        
        let gameAccountRoleView = createGameAccountRoleView(gameData: self.gameList, gameAccountData: self.gameAccountList, roleData: self.roleList, gameSelectedData: gameId, gameAccountSelectedData: gameAccountId, roleSelectedData: roleId)
        gameAccountRoleView.viewDelegate = self
        let controller = self.parent
        controller?.view.addSubview(gameAccountRoleView)
    }
    
    
}
