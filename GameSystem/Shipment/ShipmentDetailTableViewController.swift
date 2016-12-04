//
//  ShipmentDetailTableViewController.swift
//  GameSystem
//
//  Created by Smile on 2016/12/4.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class ShipmentDetailTableViewController: BaseStaticTableViewController {
    
    var shipmentId:Int?
    
    @IBOutlet weak var gameAccountRoleLabel: UILabel!
    @IBOutlet weak var consigneeLabel: UILabel!
    @IBOutlet weak var cargoLabel: UILabel!
    @IBOutlet weak var shipCurrencyLabel: UILabel!
    @IBOutlet weak var buyBackCurrencyLabel: UILabel!
    @IBOutlet weak var isPaymentLabel: UILabel!
    @IBOutlet weak var isBuybackLabel: UILabel!
    @IBOutlet weak var shipMoneyLabel: UILabel!
    
    @IBOutlet weak var shipmentLastUpdateDateLabel: UILabel!
    private var gameList:[Game] = []
    private var gameAccountList:[GameAccount] = []
    private var roleList:[Role] = []
    
    var shipment:Shipment?

    override func viewDidLoad() {
        super.viewDidLoad()
        setCellStyleNone()
        createLeftBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        initFrame()
    }
    
    func initFrame(){
        self.createLoadingView()
        startRequestTimer(info:nil,selector: #selector(ShipmentDetailTableViewController.initData))
    }
    
    func initData(){
        if shipmentId == nil { return }
        
        let params:Dictionary<String,Any> = ["id": shipmentId!]
        self.shipment = ShipmentUtil.queryShipmentById(params: params,callback: {
            self.removeLoadingView()
            }())
        
        if self.shipment == nil { return }
        
        let roleName = self.shipment?.role?.roleName ?? ""
        var gameName:String = ""
        var accountName:String = ""
        
        if self.shipment?.role?.gameAccount != nil {
            accountName = self.shipment?.role?.gameAccount?.nickName ?? ""
            
            if self.shipment?.role?.gameAccount?.game != nil {
                gameName = self.shipment?.role?.gameAccount?.game?.gameName ?? ""
            }
        }
        
        gameAccountRoleLabel.text = gameName + " " + accountName + " " + roleName
        
        consigneeLabel.text = self.shipment?.consignee! ?? ""
        cargoLabel.text = self.shipment?.cargo! ?? ""
        cargoLabel.textColor = ComponentUtil.fontColorBlue
        
        let shipMoney = self.shipment?.shipMoney ?? 0
        shipMoneyLabel.text = "\(shipMoney)"
        shipMoneyLabel.textColor = ComponentUtil.fontColorGreen
        
        let shipCurrency = self.shipment?.shipCurrency! ?? 0
        shipCurrencyLabel.text = "\(shipCurrency)"
        shipCurrencyLabel.textColor = ComponentUtil.fontColorGold
        
        let buybackCurrency = self.shipment?.buyBackCurrency! ?? 0
        buyBackCurrencyLabel.text = "\(buybackCurrency)"
        
        
        let isPaymentStr = (self.shipment?.isPayment == 0) ? ConstantUtil.isRolePaymentData[0] : ConstantUtil.isRolePaymentData[1]
        isPaymentLabel.text = isPaymentStr
        if self.shipment?.isPayment != 0 {
            isPaymentLabel.textColor = UIColor.red
        }
        
        let isBuybackStr = (self.shipment?.isBuyback == 0) ? ConstantUtil.isRoleBuybackData[0] : ConstantUtil.isRoleBuybackData[1]
        isBuybackLabel.text = isBuybackStr
        if self.shipment?.isBuyback != 0 {
            isBuybackLabel.textColor = UIColor.red
        }
        
        shipmentLastUpdateDateLabel.text = shipment?.lastUpdateDateString ?? ""
    }

   
    @IBAction func updateShipmentBtnClick(_ sender: AnyObject) {
        self.addShipmentController(roleId: self.shipment?.role?.id, flag: 1,shipment: self.shipment)
    }
}
