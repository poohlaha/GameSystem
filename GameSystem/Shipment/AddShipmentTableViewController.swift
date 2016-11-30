//
//  AddShipmentTableViewController.swift
//  GameSystem
//
//  Created by Smile on 2016/11/30.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class AddShipmentTableViewController: BaseTableViewController {

    @IBOutlet weak var gameTextField: UITextField!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var gameIdLabel: UILabel!
    
    @IBOutlet weak var gameAccountTextField: UITextField!
    @IBOutlet weak var gameAccountLabel: UILabel!
    @IBOutlet weak var gameAccountIdLabel: UILabel!
    
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var roleIdLabel: UILabel!
    
    @IBOutlet weak var consigneeTextField: UITextField!
    @IBOutlet weak var cargoTextField: UITextField!
    @IBOutlet weak var shipCurrencyTextField: UITextField!
    @IBOutlet weak var buyBackCurrencyTextField: UITextField!
    @IBOutlet weak var isPaymentTextField: UITextField!
    @IBOutlet weak var isBuybackTextField: UITextField!
    
    var parentRoleDetailViewController:RoleContactDetailTableViewController?
    
    var flag:Int = 0 //默认为0,1--表示直接行踪角色进行发货
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFrame()
        setCellStyleNone()
    }
    
    func initFrame(){
        createLeftBarItem()
        if self.flag == 1 {
            gameTextField.isHidden = true
            gameAccountTextField.isHidden = true
            roleTextField.isHidden = true
        } else {
            gameLabel.isHidden = true
            gameAccountLabel.isHidden = true
            roleLabel.isHidden = true
        }
        
        
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
    
}
