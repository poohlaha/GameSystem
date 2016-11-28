//
//  BaseViewController.swift
//  GameSystem
//
//  Created by Smile on 2016/11/23.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class BaseView{
    
    //导航条Properties
    static let barTintColor = UIColor(red: 0/255, green: 170/255, blue: 221/255, alpha:1)
    static let tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha:1)
    static let titleColor = UIColor.white
    static let curColor = UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1)//光标颜色
    
    //AlertView
    let alertViewColor = UIColor(red: 0/255, green: 170/255, blue: 221/255, alpha:1)

    //设置导航条字体
    static func setNavigationBarProperties(navigationBar:UINavigationBar) {
        //MARKS: 设置导航行背景及字体颜色
        navigationBar.barTintColor = barTintColor
        navigationBar.tintColor = tintColor
        
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: titleColor,forKey: NSForegroundColorAttributeName as NSCopying)
        navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
    }
}
