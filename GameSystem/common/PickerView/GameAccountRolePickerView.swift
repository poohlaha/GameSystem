//
//  GameAccountRolePickerView.swift
//  GameSystem
//
//  Created by Smile on 2016/11/28.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//游戏,账号,角色三级联动
class GameAccountRoleCollectionView:UIView{
    
    var collectionViewCount:Int?
    var collectionViews:[GameCollectionView]?
    
    var mainView:UIView?
    
    init(frame:CGRect,collectionViewCount:Int) {
        super.init(frame: UIScreen.main.bounds)
        if collectionViewCount == 0 { return }
        
        self.backgroundColor = ComponentUtil.backgroundBg
        self.mainView = UIView(frame: frame)
        self.addSubview(self.mainView!)
        
        initFrame(collectionViewCount:collectionViewCount)
        
    }
    
    
    func initFrame(collectionViewCount:Int){
        self.collectionViewCount = collectionViewCount
        
        var beginX:CGFloat = 0
        let eachWidth = self.frame.width / CGFloat(self.collectionViewCount!)
        let height:CGFloat = (self.mainView?.frame.height)!
        
        var gameOtherCollectionViews:[UICollectionView]?
        var gameInt:Int = 0
        for i in 0...self.collectionViewCount! - 1 {
            var collectionView:GameCollectionView?
            if i == 0 {//game
                collectionView = GameCollectionView(frame: CGRect(x: beginX, y: 0, width: eachWidth, height: height), collectionViewName: ConstantUtil.names[i], itemInSectionCount: 1, sectionCount: 8)
            }else if i == 1 {
                collectionView = GameCollectionView(frame: CGRect(x: beginX, y: 0, width: eachWidth, height: height), collectionViewName: ConstantUtil.names[i], itemInSectionCount: 1, sectionCount: 8)
                gameOtherCollectionViews?[gameInt] = (collectionView?.collectionView)!
                gameInt += 1
            }
            
            collectionViews?[i] = collectionView!
            self.mainView?.addSubview(collectionView!)
            beginX += eachWidth
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

@objc protocol GameCollectionViewDelegate {
    @objc optional func gameCallback(_ indexPath:IndexPath,_ collectionView: UICollectionView)
    @objc optional func gameAccountCallback(_ indexPath:IndexPath,_ collectionView: UICollectionView)
    @objc optional func roleCallback(_ indexPath:IndexPath,_ collectionView: UICollectionView)
}

class LeftCollectionView:GameCollectionView {
    
    var middleCollectionView:UICollectionView?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? GameAccountRoleViewCellCollectionViewCell
        let name:String = self.collectionViewName!
        if name == ConstantUtil.names[0] {
            getAllItems(collectionView, callback: { (itemCell) in
             itemCell.layer.backgroundColor = UIColor.white.cgColor
             })
             
             if self.middleCollectionView != nil {
                //清除collectionView,重新加载
                self.middleCollectionView?.removeFromSuperview()
             }
            
            cell?.layer.backgroundColor = ComponentUtil.backgroundColor.cgColor
            
        }else if name == ConstantUtil.names[1] {
            
        }else if name == ConstantUtil.names[2] {
            
        }
    }
}

class MiddleCollectionView:GameCollectionView{
    
}

class RightCollectionView:GameCollectionView{
    
}



class GameCollectionView:UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var collectionView:UICollectionView?
    var collectionViewName:String?
    
    private var itemInSectionCount:Int?
    private var sectionCount:Int?
    
    private let itemHeight:CGFloat = 40
    
    var sectionCellIdentifiers:[String] = Array<String>()
    
    //前一个视图选中的值,如果没有,则显示所有数据
    private var nextCollectionViewData:String?
    
    init(frame:CGRect,collectionViewName:String,itemInSectionCount:Int,sectionCount:Int) {
        super.init(frame: frame)
        
        self.collectionViewName = collectionViewName
        self.itemInSectionCount = itemInSectionCount
        self.sectionCount = sectionCount
        
        for i in 0...self.sectionCount! - 1 {
            self.sectionCellIdentifiers.append("GameAccountRoleViewCellCollectionViewCell\(i)")
        }
        initFrame()
    }
    
    //初始化collectionLayout
    func initCollectionLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical  //滚动方向
        layout.itemSize = CGSize(width: self.frame.width, height: self.itemHeight) //设置所有cell的size  太重要了 找了半天。(自学就是辛苦呀！！)
        layout.minimumLineSpacing = 0.0  //上下间隔
        layout.minimumInteritemSpacing = 0.0 //左右间隔
        //layout.headerReferenceSize = CGSize(width: 20,height: 20)
        //layout.footerReferenceSize = CGSize(width: 20,height: 20)
        return layout
    }
    
    //初始化collectionView
    func initFrame(){
        let layout = initCollectionLayout()
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.dataSource  = self
        collectionView?.delegate = self
        //collectionView?.register(GameAccountRoleViewCellCollectionViewCell.self, forCellWithReuseIdentifier: "GameAccountRoleViewCellCollectionViewCell")
        
        for i in 0...self.sectionCellIdentifiers.count - 1 {
            collectionView?.register(GameAccountRoleViewCellCollectionViewCell.self, forCellWithReuseIdentifier: self.sectionCellIdentifiers[i])
        }
        self.addSubview(collectionView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //返回多少个cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemInSectionCount!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: (self.sectionCellIdentifiers[indexPath.section]), for: indexPath) as? GameAccountRoleViewCellCollectionViewCell
        cell?.label?.text = "测试一"
        
        let layer = BaseDrawView().drawLine(beginPointX:10,beginPointY:(cell?.frame.height)!,endPointX:(cell?.frame.width)! - 10,endPointY:(cell?.frame.height)!,color:ComponentUtil.sepatatorColor)
        
         cell!.layer.addSublayer(layer)
         return cell!
    }
    
    //返回多少个组
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionCount!
    }
    
    //返回自定义HeadView或者FootView
    /*func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
     
     }*/
    //选中事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func getAllItems(_ collectionView: UICollectionView,callback:(_ itemCell: UICollectionViewCell) -> ()){
        for i in 0...collectionView.numberOfSections - 1 {
            for j in 0...collectionView.numberOfItems(inSection: i) - 1 {
                let index = NSIndexPath(row: j, section: i)
                let itemCell = collectionView.cellForItem(at: index as IndexPath)
                callback(itemCell!)
            }
        }
    }
}
