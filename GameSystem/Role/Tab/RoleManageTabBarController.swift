//
//  RoleManageTabBarController.swift
//  GameSystem
//
//  Created by Smile on 2016/11/23.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class RoleManageTabBarController: UITabBarController {
    
    let itemTexts:[String] = ["查询","角色"];

    override func viewDidLoad() {
        super.viewDidLoad()

       createSubTabViewControllers()
       configTabBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //创建TabViewController
    func createSubTabViewControllers(){
        let roleQueryController  = RoleQueryTableViewController()
        let roleQueryItem:UITabBarItem = UITabBarItem(title: itemTexts[0], image: ConstantUtil.messageTabImages[0], selectedImage: ConstantUtil.messageTabImages[1])
        roleQueryController.tabBarItem = roleQueryItem
        
        let roleContactController = RoleContactTableViewController()
        let roleManageItem:UITabBarItem = UITabBarItem (title: itemTexts[1], image: ConstantUtil.roleManageTabImages[0], selectedImage: ConstantUtil.roleManageTabImages[1])
        roleContactController.tabBarItem = roleManageItem
        
        
        let tabArray = [roleQueryController,roleContactController]
        self.viewControllers = tabArray
    }
    
    //初始化tabbar图标
    func configTabBar() {
        var count:Int = 0;
        let items = self.tabBar.items!
        for item in items{
            var image:UIImage
            var selectedImage:UIImage
            
            if count == 0 {
                image = ConstantUtil.messageTabImages[0]
                selectedImage = ConstantUtil.messageTabImages[1]
            } else {
                image = ConstantUtil.roleManageTabImages[0]
                selectedImage = ConstantUtil.roleManageTabImages[1]
            }
            
            image = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
            selectedImage = selectedImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
            item.selectedImage = selectedImage
            item.image = image
            
            //set font color for text #38ae31
            item.setTitleTextAttributes( [NSForegroundColorAttributeName: UIColor(red: 56/255, green: 174/255, blue: 49/255, alpha: 1)], for: .selected)
            count += 1;
        }
        
        
        self.selectedIndex = 0
    }
}
