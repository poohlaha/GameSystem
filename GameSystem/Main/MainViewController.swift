//
//  MainViewController.swift
//  GameSystem
//
//  Created by Smile on 2016/11/9.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius:CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = (newValue > 0)
        }
    }
}

/**
 * 列面首页，开始页面s
 */
class MainViewController: UIViewController {
    
    
    var gameAccountManageView:MainBgView!//游戏账号管理
    var roleManageView:MainBgView!//角色管理
    var shipmentManageView:MainBgView!//出货管理
    
    var chargeAccountManageView:MainBgView!//充值管理
    var reportManageView:MainBgView!//报表管理
    var personManageView:MainBgView!//私人管理
    
    var navigationHeight:CGFloat!//导航条高度
    var bounds:CGRect = UIScreen.main.bounds//屏幕矩形
    var borderWidthSize:CGFloat = 3//横向边框个数
    var borderHeightSize:CGFloat = 2//纵向边框个数
    
    var mainView:UIView!
    var statusHeight:CGFloat!
    
    var eachWidth:CGFloat! //每个边框宽度
    var eachHeight:CGFloat!//每个边框高度
    let labelHeight:CGFloat = 20//标签高度
    
    var titleView:UIView!//标题试图
    let titleViewHeight:CGFloat = 40
    
    
    let labelFontColor:UIColor = UIColor(red: 70/355, green: 31/255, blue: 0/255, alpha: 0.8)
    let labelTitleColor:UIColor = UIColor(red: 255/255, green: 239/255, blue: 194/255, alpha: 0.8)
    
    let backgroundImageName:String = "background"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationItem.title = ConstantUtil.systemName
        
        initFrame()
        initComponent()
        initTitle()
        addGestureRecognizer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARKS: 初始化
    func initFrame(){
        let width = bounds.width
        //self.navigationHeight = (self.navigationController?.navigationBar.frame.height)!
        
        self.navigationHeight = 0
        
        //status bar
        let statusBarFrame = ComponentUtil.statusBarFrame
        self.statusHeight = statusBarFrame.height

        let height:CGFloat = bounds.height - self.navigationHeight - self.statusHeight
        
        //计算每个格子的宽度
        self.eachWidth = width / borderWidthSize
        self.eachHeight = self.eachWidth
        
        self.mainView = UIView()
        self.mainView.frame = CGRect(x: 0, y: bounds.height - self.eachWidth * 2, width: width, height: height)
        
        self.gameAccountManageView = MainBgView(frame: CGRect(x: 0, y: 0, width: self.eachWidth, height: self.eachHeight))
        self.roleManageView = MainBgView(frame: CGRect(x: self.eachWidth, y: 0, width: self.eachWidth, height: self.eachHeight))
        self.shipmentManageView = MainBgView(frame: CGRect(x: self.eachWidth * 2, y: 0, width: self.eachWidth, height: self.eachHeight))
        
        
        self.chargeAccountManageView = MainBgView(frame: CGRect(x: 0, y: self.eachHeight, width: self.eachWidth, height: self.eachHeight))
        self.reportManageView = MainBgView(frame: CGRect(x: self.eachWidth, y: self.eachHeight, width: self.eachWidth, height: self.eachHeight))
        self.personManageView = MainBgView(frame: CGRect(x: self.eachWidth * 2, y: self.eachHeight, width: self.eachWidth, height: self.eachHeight))
        
        self.mainView.addSubview(gameAccountManageView)
        self.mainView.addSubview(roleManageView)
        self.mainView.addSubview(shipmentManageView)
        self.mainView.addSubview(chargeAccountManageView)
        self.mainView.addSubview(reportManageView)
        self.mainView.addSubview(personManageView)
        
        self.gameAccountManageView.backgroundColor = ConstantUtil.mainBgColors[0]
        self.shipmentManageView.backgroundColor = ConstantUtil.mainBgColors[0]
        self.reportManageView.backgroundColor = ConstantUtil.mainBgColors[0]
        
        self.roleManageView.backgroundColor = ConstantUtil.mainBgColors[1]
        self.chargeAccountManageView.backgroundColor = ConstantUtil.mainBgColors[1]
        self.personManageView.backgroundColor = ConstantUtil.mainBgColors[1]
        
        //self.view.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 57/255, alpha: 0.8)
        self.view.layer.contents = UIImage(named:self.backgroundImageName)?.cgImage
        self.view.layer.backgroundColor = UIColor.clear.cgColor
        
        self.view.addSubview(mainView)
        
    }
    
    
    //初始化组件
    func initComponent(){
        self.gameAccountManageView.addSubview(createLabelComponent(strTop: ConstantUtil.gameAccountManageTextEn,strBottom:ConstantUtil.gameAccountManageText))
        
        self.roleManageView.addSubview(createLabelComponent(strTop: ConstantUtil.roleManageTextEn,strBottom:ConstantUtil.roleManageText))
        
        self.shipmentManageView.addSubview(createLabelComponent(strTop: ConstantUtil.shipmentManageTextEn,strBottom:ConstantUtil.shipmentManageText))
        
        self.chargeAccountManageView.addSubview(createLabelComponent(strTop: ConstantUtil.chargeAccountManageTextEn,strBottom:ConstantUtil.chargeAccountManageText))
        
        self.reportManageView.addSubview(createLabelComponent(strTop: ConstantUtil.reportManageTextEn,strBottom:ConstantUtil.reportManageText))
        
        self.personManageView.addSubview(createLabelComponent(strTop: ConstantUtil.personManageTextEn,strBottom:ConstantUtil.personManageText))
    }
    
    //MARKS:初始化标题
    func initTitle(){
        let beginY:CGFloat = self.statusHeight
        self.titleView = UIView(frame: CGRect(x: 0, y: beginY, width: bounds.width, height: self.titleViewHeight))
        self.titleView.backgroundColor = ConstantUtil.mainBgColors[0]
        
        let titleFont:UIFont = UIFont(name:ComponentUtil.fontName,size:18)!
        let titleLabelFrame:CGRect = ComponentUtil.getLabelRect(width: bounds.width,height:0, str: ConstantUtil.systemName, font: titleFont)
        let titleHeight:CGFloat = titleLabelFrame.size.height
        
        let titleBeginY:CGFloat = (self.titleViewHeight - titleHeight) / 2
        
        let titleLabel:UILabel = ComponentUtil.createLabel(rect: CGRect(x: 0, y: titleBeginY, width: bounds.width, height: titleHeight), content: ConstantUtil.systemName, color: self.labelFontColor, textAlignment: NSTextAlignment.center, background: UIColor.clear, fontName: ComponentUtil.fontName, fontSize: 18)
        
        self.titleView.addSubview(titleLabel)
        self.view.addSubview(self.titleView)
    }
    
    //MARKS:创建label标签（上下两个）
    func createLabelComponent(strTop:String,strBottom:String) -> UIView{
        let topFont:UIFont = UIFont(name: ComponentUtil.fontName, size: 12)!
        let bottomFont:UIFont = UIFont(name:ComponentUtil.fontName,size:18)!
        
        let topHeight:CGFloat = ComponentUtil.getLabelRect(width: self.eachWidth,height:0, str: strTop, font: topFont).size.height
        let bottomHeight:CGFloat = ComponentUtil.getLabelRect(width: self.eachWidth,height:0, str: strBottom, font: bottomFont).size.height
        let padding:CGFloat = 5
        let labelHeight:CGFloat = topHeight + padding + bottomHeight
        
        let labelBeginY:CGFloat = (self.eachHeight - labelHeight) / 2
        let labelView:UIView = UIView(frame: CGRect(x: 0, y: labelBeginY, width: self.eachWidth, height: labelHeight))
        
       
        let topLabel:UILabel = ComponentUtil.createLabel(rect: CGRect(x: 0, y: 0, width: self.eachWidth, height: topHeight), content: strTop, color: self.labelFontColor, textAlignment: NSTextAlignment.center, background: UIColor.clear, fontName: ComponentUtil.fontName, fontSize: 12)
        
        let bottomLabel:UILabel = ComponentUtil.createLabel(rect: CGRect(x: 0, y: topHeight + padding, width: self.eachWidth, height: topHeight), content: strBottom, color: self.labelFontColor, textAlignment: NSTextAlignment.center, background: UIColor.clear, fontName: ComponentUtil.fontName, fontSize: 18)
        
        labelView.addSubview(topLabel)
        labelView.addSubview(bottomLabel)
        return labelView
    }
    
    //添加手势
    func addGestureRecognizer(){
        self.gameAccountManageView.addGestureRecognizer(GameUITapGestureRecognizer(target: self, action: #selector(MainViewController.gameAccountManageViewTap(tap:))))
        
        self.roleManageView.addGestureRecognizer(GameUITapGestureRecognizer(target: self, action: #selector(MainViewController.roleManageViewTap(tap:))))
        
        self.shipmentManageView.addGestureRecognizer(GameUITapGestureRecognizer(target: self, action: #selector(MainViewController.shipmentManageViewTap(tap:))))
        
        self.chargeAccountManageView.addGestureRecognizer(GameUITapGestureRecognizer(target: self, action: #selector(MainViewController.chargeAccountManageViewTap(tap:))))
        
        self.reportManageView.addGestureRecognizer(GameUITapGestureRecognizer(target: self, action: #selector(MainViewController.reportManageViewTap(tap:))))
        
        self.personManageView.addGestureRecognizer(GameUITapGestureRecognizer(target: self, action: #selector(MainViewController.personManageViewTap(tap:))))
        
    }
    
    
    func gameAccountManageViewTap(tap:GameUITapGestureRecognizer){
        
    }
    
    func roleManageViewTap(tap:GameUITapGestureRecognizer){
        //根据storyboard获取controller
        let sb = UIStoryboard(name:"role", bundle: nil)
        let roleManageTabBarController = sb.instantiateViewController(withIdentifier: "RoleManageTabBar") as! UITabBarController
        self.navigationController?.pushViewController(roleManageTabBarController, animated: true)
    }
    
    func back(){
        self.navigationController?.popViewController(animated: true)
    }
   
    func shipmentManageViewTap(tap:GameUITapGestureRecognizer){
        let shipmentSB = UIStoryboard(name:"shipment", bundle: nil)
        let shipmentManageController = shipmentSB.instantiateViewController(withIdentifier: "ShipmentTableViewController") as! ShipmentTableViewController
        self.navigationController?.pushViewController(shipmentManageController, animated: true)

    }
    
    func chargeAccountManageViewTap(tap:GameUITapGestureRecognizer){
        
    }

    func reportManageViewTap(tap:GameUITapGestureRecognizer){
        
    }
    
    func personManageViewTap(tap:GameUITapGestureRecognizer){
        
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
