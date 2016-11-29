//
//  GameAccountRoleView.swift
//  GameSystem
//
//  Created by Smile on 2016/11/28.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class GameAccountRoleView: UIView {

    var mainView:UIView?
    private var isGameShow:Bool = true
    private var isGameAccountShow:Bool = true
    private var isRoleShow:Bool = true
    
    var gameView:LeftTableView?
    var gameAccountView:MiddleTableView?
    var roleView:RightTableView?
    
    var gameData:[Game] = []
    var gameAccountData:[GameAccount] = []
    var roleData:[Role] = []
    private var gameSelectedData:Int?
    private var gameAccountSelectedData:Int?
    private var roleSelectedData:Int?
    
    var viewDelegate:GameAccountRoleBaseViewDelegate?
    
    init(frame:CGRect,gameData:[Game],gameAccountData:[GameAccount],roleData:[Role],
         gameSelectedData:Int?,gameAccountSelectedData:Int?,roleSelectedData:Int?) {
        super.init(frame: UIScreen.main.bounds)
       
        self.isGameShow = (gameData.isEmpty || gameData.count == 0) ? false : true
        self.isGameAccountShow = (gameAccountData.isEmpty || gameAccountData.count == 0) ? false : true
        self.isRoleShow = (roleData.isEmpty || roleData.count == 0) ? false : true
        
        self.gameData = gameData
        self.gameAccountData = gameAccountData
        self.roleData = roleData
        
        self.gameSelectedData = gameSelectedData
        self.gameAccountSelectedData = gameAccountSelectedData
        self.roleSelectedData = roleSelectedData
        
        if !self.isGameShow && !self.isGameAccountShow && !isRoleShow { return }
        
        var count:Int = 0
        if self.isGameShow {
            count += 1
        }
        
        if self.isGameAccountShow {
            count += 1
        }
        
        if self.isRoleShow {
            count += 1
        }
        
        self.backgroundColor = ComponentUtil.backgroundBg
        self.mainView = UIView(frame: frame)
        self.addSubview(self.mainView!)
        
        initFrame(count:count)
        
    }
    
    
    func initFrame(count:Int){
        var beginX:CGFloat = 0
        let eachWidth = self.frame.width / CGFloat(count)
        let height:CGFloat = (self.mainView?.frame.height)!
        
        let game = Game();
        if self.isGameShow {
            self.gameView = LeftTableView(frame: CGRect(x: beginX, y: 0, width: eachWidth, height: height),data:self.gameData,selectedData:self.gameSelectedData)
            beginX += eachWidth
            self.mainView?.addSubview(gameView!)
            
            self.gameView?.eachWidth = eachWidth
            self.gameView?.parentView = self
            self.gameView?.eachHeight = height
            
            game.id = self.gameSelectedData
            
            var gameName:String = ""
            for g in self.gameData {
                if g.id == self.gameSelectedData {
                    gameName = g.gameName!
                    break
                }
            }
            
            game.gameName = gameName
            
            //if self.gameSelectedData != nil {
                //let indexPath = NSIndexPath(row: 0, section: 0) as IndexPath
                //self.gameView?.tableView?.selectRow(at: indexPath, animated: false, scrollPosition: .none)
           // }
        }
        
        if self.isGameAccountShow {
            self.gameAccountView = MiddleTableView(frame: CGRect(x: beginX, y: 0, width: eachWidth, height: height),data:self.gameAccountData,selectedData:self.gameAccountSelectedData)
            beginX += eachWidth
            self.mainView?.addSubview(gameAccountView!)
            
            self.gameView?.middelTableView = self.gameAccountView
            self.gameAccountView?.game = game
            self.gameAccountView?.parentView = self
        }
        
        
        if self.isRoleShow {
            self.roleView = RightTableView(frame: CGRect(x: beginX, y: 0, width: eachWidth, height: height),data:self.roleData,selectedData:self.roleSelectedData)
            beginX += eachWidth
            self.mainView?.addSubview(roleView!)
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location:CGPoint = (touches.first?.location(in: self))!
        if isInView(location: location){ return }
        
        super.touchesEnded(touches, with: event)
        super.removeFromSuperview()
    }
    
    //获取左上和右下坐标,判断坐标点是否在矩形内
    func isInView(location:CGPoint) -> Bool{
        let beginTopLeftX:CGFloat = (self.mainView?.frame.origin.x)!
        let beginTopLeftY:CGFloat = (self.mainView?.frame.origin.y)!
        
        let endBottomRightX:CGFloat = (self.mainView?.frame.origin.x)! + (self.mainView?.frame.width)!
        let endBottomRightY:CGFloat = (self.mainView?.frame.origin.y)! + (self.mainView?.frame.height)!
        
        let currentX:CGFloat = location.x
        let currentY:CGFloat = location.y
        
        if currentX < beginTopLeftX || currentX > endBottomRightX || currentY < beginTopLeftY || currentY > endBottomRightY {
            return false
        }
        
        return true
        
    }
    
}

class LeftTableView:GameAccountRoleBaseView {
    
    var middelTableView:MiddleTableView?
    var eachWidth:CGFloat = 0
    var eachHeight:CGFloat = 0
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! GameAccountRoleTableViewCell
        
        //通过gameId获取账号数据
        let gameId:Int = Int(cell.hiddenLabel!.text!)!
        let gameText:String = (cell.label?.text) ?? ""
        
        let game:Game = Game()
        game.id = gameId
        game.gameName = gameText
        
        if self.middelTableView != nil {
            self.middelTableView?.removeFromSuperview()
            
           
            let gameAccountData:[GameAccount] = GameUtil.anaylsGameAccountByGameId(gameId: gameId, gameAccountList: (self.parentView?.gameAccountData)!)
            
            let gameAccountView = MiddleTableView(frame: CGRect(x: eachWidth, y: 0, width: self.eachWidth, height: self.eachHeight),data:gameAccountData,selectedData:nil)
            gameAccountView.game = game
            self.parentView?.mainView?.addSubview(gameAccountView)
            
            gameAccountView.parentView = self.parentView
        } else {
            if ((self.parentView?.viewDelegate?.gameAccountRoleBaseViewCallback) != nil) {
                let data:NSDictionary = ["game":game]
                self.parentView?.viewDelegate?.gameAccountRoleBaseViewCallback!(data:data,view:self.parentView)
            }
        }
        
        disableAllCellMark()
        cell.accessoryType = .checkmark
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GameAccountRoleTableViewCell(style: .default, reuseIdentifier: "Cell\(indexPath.section)\(indexPath.row)")
        
        let game:Game = data[indexPath.row] as! Game
        cell.label?.text = game.gameName
        cell.hiddenLabel?.text = "\(game.id!)"
        
        if (self.selectedData != nil){
            if game.id == selectedData {
                cell.accessoryType = .checkmark
            }
        }
        
        //最后一个cell底部画线
        if indexPath.row == data.count - 1 {
            cell.layer.addSublayer(drawLastLine(width:cell.frame.width,height: cell.frame.height))
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

class MiddleTableView:GameAccountRoleBaseView {
    
    var rightTableView:RightTableView?
    
    var game:Game?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! GameAccountRoleTableViewCell
        
        let gameAccountId:Int = Int(cell.hiddenLabel!.text!)!
        let gameAccountText:String = cell.label?.text ?? ""
        
        let gameAccount:GameAccount = GameAccount()
        gameAccount.id = gameAccountId
        gameAccount.nickName = gameAccountText
        
        self.selectedData = Int(cell.hiddenLabel!.text!)!
        disableAllCellMark()
        cell.accessoryType = .checkmark
        
        if self.rightTableView != nil {
            
        }else{
            let data:NSDictionary = ["game":self.game,"gameAccount":gameAccount]
            self.parentView?.viewDelegate?.gameAccountRoleBaseViewCallback!(data:data,view:self.parentView)
        }
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = GameAccountRoleTableViewCell(style: .default, reuseIdentifier: "Cell\(indexPath.section)\(indexPath.row)")
        
        let gameAccount:GameAccount = data[indexPath.row] as! GameAccount
        cell.label?.text = gameAccount.nickName
        cell.hiddenLabel?.text = "\(gameAccount.id!)"
        
        if (self.selectedData != nil){
            if gameAccount.id == selectedData {
                cell.accessoryType = .checkmark
            }
        }
        
        //最后一个cell底部画线
        if indexPath.row == data.count - 1 {
           cell.layer.addSublayer(drawLastLine(width:cell.frame.width,height: cell.frame.height))
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

class RightTableView:GameAccountRoleBaseView {
    
    var gameAccount:GameAccount?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! GameAccountRoleTableViewCell
        //let roleId:Int = Int(cell.hiddenLabel!.text!)!
        //let roleText:String = (cell.label?.text)!
        
        if ((self.parentView?.viewDelegate?.gameAccountRoleBaseViewCallback) != nil) {
            //var data:NSDictionary = ["game":self.game,"gameAccount":gameAccount]
            //self.parentView?.viewDelegate?.gameAccountRoleBaseViewCallback!(data:data)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GameAccountRoleTableViewCell(style: .default, reuseIdentifier: "Cell\(indexPath.section)\(indexPath.row)")
        
        let role:Role = data[indexPath.row] as! Role
        cell.label?.text = role.roleName
        cell.hiddenLabel?.text = "\(role.id!)"
        
        if (self.selectedData != nil){
            if role.id == selectedData {
                cell.accessoryType = .checkmark
            }
        }
        
        //最后一个cell底部画线
        if indexPath.row == data.count - 1 {
           cell.layer.addSublayer(drawLastLine(width:cell.frame.width,height: cell.frame.height))
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

@objc protocol GameAccountRoleBaseViewDelegate {
    @objc optional func gameAccountRoleBaseViewCallback(data:NSDictionary,view:GameAccountRoleView?)
}

class GameAccountRoleBaseView:UIView,UITableViewDelegate,UITableViewDataSource {
    
    var tableView:UITableView?
    private let height:CGFloat = 40
    var data:[AnyObject] = []
    var selectedData:Int?
    var parentView:GameAccountRoleView?

    
    init(frame:CGRect,data:[AnyObject],selectedData:Int?) {
        super.init(frame: frame)
        self.data = data
        self.selectedData = selectedData
        initFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initFrame(){
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.addSubview(tableView!)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARKS: 返回每组行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    //MARKS: 计算行高
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height
    }*/
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GameAccountRoleTableViewCell(style: .default, reuseIdentifier: "Cell\(indexPath.section)\(indexPath.row)")
       
        return cell
    }
    
    func drawLastLine(width:CGFloat,height:CGFloat) -> CALayer {
         return BaseDrawView().drawLine(beginPointX:10,beginPointY:height,endPointX:width - 10,endPointY:height,color:ComponentUtil.sepatatorColor)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func disableAllCellMark(){
        for i in 0...(self.tableView?.numberOfSections)! - 1 {
            for j in 0...(self.tableView?.numberOfRows(inSection: i))! - 1 {
                let indexPath = NSIndexPath(row: j, section: i)
                let cell = tableView?.cellForRow(at: indexPath as IndexPath)
                cell?.accessoryType = .none
            }
        }
    }
}

class GameAccountRoleTableViewCell:UITableViewCell {
    
    var label:UILabel?
    private var leftOrRightPadding:CGFloat = 10
    private var topOrBottomPadding:CGFloat = 10
    
    var hiddenLabel:UILabel?

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initFrame()
    }
    
    func initFrame(){
        label = ComponentUtil.createLabel(rect: CGRect(x:leftOrRightPadding,y:topOrBottomPadding,width:self.frame.width - leftOrRightPadding * 2,height:self.frame.height - topOrBottomPadding * 2), content: "", color: UIColor.black, textAlignment: .left, background: UIColor.clear, fontName: ComponentUtil.fontName, fontSize: 16)
        
        hiddenLabel = ComponentUtil.createLabel(rect: CGRect(x:0,y:0,width:0,height:0), content: "", color: UIColor.black, textAlignment: .left, background: UIColor.clear, fontName: ComponentUtil.fontName, fontSize: 16)
        hiddenLabel?.isHidden = true
        self.addSubview(hiddenLabel!)
        self.addSubview(label!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
