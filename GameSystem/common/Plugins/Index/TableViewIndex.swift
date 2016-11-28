
//
//  TableViewIndex.swift
//  WeChat
//
//  Created by Smile on 16/1/10.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//自定义索引
class TableViewIndex:UIView {
    
    var shapeLayer:CAShapeLayer?
    var fontSize:CGFloat?
    var letterHeight:CGFloat?
    var isLayedOut:Bool = false
    var letters = [String]()
    
    var tableView: UITableView?
    var datas = [ContactSession]()
    
    init(frame: CGRect,tableView:UITableView,datas:[ContactSession]) {
        self.letterHeight = 14;
        fontSize = 12;
        //letters = UILocalizedIndexedCollation.currentCollation().sectionTitles
        
        self.tableView = tableView
        self.datas = datas
        
        //MARKS: Get All Keys
        if datas.count > 0 {
            for data in datas {
                let key = data.key
                if !key.isEmpty {
                    letters.append(key)
                }
            }
        }
        
        let height:CGFloat = self.letterHeight! * CGFloat(datas.count)
        //重新计算位置
        let beginY:CGFloat = (tableView.bounds.height - height) / 2
        super.init(frame: CGRect(x:frame.origin.x, y:beginY, width:frame.width, height:height))
        
        //super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUp(){
        shapeLayer = CAShapeLayer()
        shapeLayer!.lineWidth = 0.5// 线条宽度
        shapeLayer!.fillColor = UIColor.clear.cgColor// 闭环填充的颜色
        shapeLayer!.lineJoin = kCALineCapSquare
        shapeLayer!.strokeColor = UIColor.clear.cgColor// 边缘线的颜色
        shapeLayer!.strokeEnd = 1.0
        self.layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setUp()
        
        if !isLayedOut {
            shapeLayer?.frame.origin = CGPoint.zero
            shapeLayer?.frame.size = self.layer.frame.size
            
            var count:CGFloat = 0
            for i in self.letters{
                if !letters.contains(i){
                    continue
                }
                
                let originY = count * self.letterHeight!
                let text = textLayerWithSize(size: fontSize!, string: i, frame: CGRect(x: 0, y: originY, width: self.frame.size.width, height: self.letterHeight!))
                self.layer.addSublayer(text)
                
                count += 1
            }
            
            self.layer.addSublayer(shapeLayer!)
            
            isLayedOut = true
        }
    }
    
    func reloadLayout(edgeInsets:UIEdgeInsets){
        /*var rect = self.frame;
         rect.size.height = self.indexs.count * self.letterHeight;
         rect.origin.y = edgeInsets.top + (self.superview!.bounds.size.height - edgeInsets.top - edgeInsets.bottom - rect.size.height) / 2;
         self.frame = rect;*/
    }
    
    func textLayerWithSize(size:CGFloat,string:String,frame:CGRect) -> CATextLayer{
        let textLayer = CATextLayer()
        textLayer.font = CTFontCreateWithName("TrebuchetMS-Bold" as CFString?,size,nil)
        textLayer.fontSize = size
        textLayer.frame = frame
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.contentsScale = UIScreen.main.scale
        //textLayer.foregroundColor  = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).CGColor
        
        textLayer.foregroundColor = UIColor.gray.cgColor
        textLayer.string = string
        return textLayer
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        sendEventToDelegate(touches:touches,event: event!)
    }
    
    func sendEventToDelegate(touches:Set<UITouch>,event:UIEvent){
        let point = (touches.first?.location(in: self))!
        //let point = ((event.allTouches! as NSSet).anyObject() as AnyObject).location(in: self)
        let index = Int(floorf(Float(point.y)) / Float(self.letterHeight!))
        if (index < 0 || index > self.letters.count - 1) {
            return
        }
        
        didSelectSectionAtIndex(index: index, withTitle: self.letters[index])
    }
    
    func didSelectSectionAtIndex(index:Int,withTitle title:String){
        if (index > -1){
            for i in 0...tableView!.numberOfSections - 1 {
                let key = datas[i].key
                if key == title {
                    tableView!.scrollToRow(at: NSIndexPath(row: 0, section: i) as IndexPath, at: .top, animated: false)
                }
            }
        }
    }
}
