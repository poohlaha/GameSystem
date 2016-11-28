//
//  AddGameAccountViewController.swift
//  GameSystem
//
//  Created by Smile on 2016/11/10.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//添加游戏账号
class AddGameAccountViewController: UIViewController {

    @IBOutlet weak var gameNameText: UITextField!
    @IBOutlet weak var gameCompanyNameText: UITextField!
    @IBOutlet weak var gameCompanyCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addGameAccount();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func addGameAccount(){
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
