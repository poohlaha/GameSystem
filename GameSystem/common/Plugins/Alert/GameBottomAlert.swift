//
//  WeChatBottomAlert.swift
//  WeChat
//
//  Created by Smile on 16/1/12.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class GameBottomAlert: BaseDrawView {
    
    //MARKS: Properties
    var isLayedOut:Bool = false//是否初始化view
    var fontSize:CGFloat = 12//默认字体大小
    var labelHeight:CGFloat = 25//默认标签高度
    var titles = [String]()
    var colors = [UIColor]()
    let paddintLeft:CGFloat = 30//padding-left
    let paddintTop:CGFloat = 15//padding-top
    let titleFontName:String = "Avenir-Light"//默认标题字体名称
    let fontName:String = "Cochin-Bold "//加粗字体
    let rectHeight:CGFloat = 5;//矩形高度
    var oneBlockHeight:CGFloat = 0//一块区域的高度
    var oneBlockWidth:CGFloat = 0//一块区域的宽度
    var otherSize:CGFloat = 18
    var originX:CGFloat = 0//开始绘制x坐标
    var originY:CGFloat = 0//开始绘制y坐标
    
    var views:Dictionary<String,UIView> = Dictionary<String,UIView>()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect,titles:[String],colors:[UIColor]?,fontSize:CGFloat,callback:@escaping (_ result:AnyObject,_ this:AnyObject)->()) {
        //MARKS: 初始化数据
        if fontSize > 0 {
            self.fontSize = fontSize
        }
        
        if colors != nil {
            self.colors = colors!
        }
        
        self.titles = titles
        
        oneBlockHeight = labelHeight + paddintTop * 2
        oneBlockWidth = frame.size.width - paddintLeft * 2
        
        //MARKS: 获取Alert总高度
        var totalHeight:CGFloat = 0
        for title in titles {
            if !title.isEmpty {
                totalHeight += oneBlockHeight
            }
        }
        
        totalHeight += 5
        
        var y:CGFloat = 0
        if frame.origin.y < 0 {
            if frame.size.height <= 0 {
                y = UIScreen.main.bounds.height - totalHeight
            }
        }else{
            y = frame.origin.y
        }
        
        originX = frame.origin.x
        originY = y
        
        //super.init(frame: CGRectMake(frame.origin.x, y, frame.size.width, totalHeight))
        
        //初始化整个屏幕
        super.init(frame: UIScreen.main.bounds)
    
        //设置背景
        self.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        //self.alpha = 0.8
        initLayoutSubviews(callback:callback)
    }
    
    func initLayoutSubviews(callback:(_ result:AnyObject,_ this:AnyObject)->()){
        
        if titles.count <= 1 {
            return
        }
        
        var _originY:CGFloat = originY
        var size:CGFloat = fontSize
        var i = 0
        for title in titles {
            if title.isEmpty {
                i += 1
                continue;
            }
            
            if i == 0 {
                size = fontSize
            } else {
                size = otherSize
            }
            if i != (titles.count - 1) {
                var color:UIColor
                var fontName:String = titleFontName
                if self.colors.count > 0 {
                    color = self.colors[i]
                } else {
                    color = UIColor.black
                }
                if i == 0 {
                    fontName = titleFontName
                }else{
                    fontName = self.fontName
                }
                
                if(!titles[i].isEmpty){
                    let label:UILabel = drawAlertLabel(content: titles[i],y: _originY,size: size,color:color,isBold: false,fontName: fontName,width:UIScreen.main.bounds.width,height: oneBlockHeight)
                    label.isUserInteractionEnabled = true
                    views[titles[i]] = label
                    self.addSubview(label)
                }
                
                _originY += oneBlockHeight
                if titles.count >= 3 {
                    if i != (titles.count - 2) {
                        self.layer.addSublayer(drawLine(beginPointX: 0, beginPointY: _originY, endPointX: self.frame.size.width, endPointY: _originY))
                    }else{
                        self.layer.addSublayer(drawRect(beginPointX: 0, beginPointY: _originY, width: self.frame.size.width, height: rectHeight))
                        _originY += rectHeight
                    }
                }
            }else{
                if(!titles[i].isEmpty){
                    let label:UILabel = drawAlertLabel(content: titles[i],y: _originY,size: size,color: UIColor.black,isBold: true,fontName: fontName,width:UIScreen.main.bounds.width,height: oneBlockHeight)
                    label.isUserInteractionEnabled = true
                    views[titles[i]] = label
                    self.addSubview(label)
                }
            }
            
            i += 1
        }

        callback(self.views as AnyObject,self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //let shapeLayer = self.setUp()
        if !isLayedOut {
            //shapeLayer.frame.origin = CGPointZero
            //shapeLayer.frame.size = self.layer.frame.size
            
            isLayedOut = true
        }
        
       
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       let location:CGPoint = (touches.first?.location(in: self))!
       if isInView(location: location){ return }
       
       super.touchesEnded(touches, with: event)
       super.removeFromSuperview()
    }
    
    //获取左上和右下坐标,判断坐标点是否在矩形内
    func isInView(location:CGPoint) -> Bool{
        let currentY:CGFloat = location.y
        
        if currentY < originY || currentY > (originY + self.frame.height) {
            return false
        }
        
        return true
         
    }
    

}
