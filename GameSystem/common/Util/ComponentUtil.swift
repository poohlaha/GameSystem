//
//  ComponentUtil.swift
//  GameSystem
//
//  Created by Smile on 2016/11/9.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class ComponentUtil: NSObject {
    
    static let fontName:String = "Arial"//AlNile
    static let fontNameBold:String = "Helvetica-Bold"
    static let fontColorGreen:UIColor = UIColor(red: 0/255, green: 200/255, blue: 150/255, alpha: 0.8)
    static let fontColorBlue:UIColor = UIColor(red: 0/255, green: 148/255, blue: 255/255, alpha: 1)
    static let backgroundColor:UIColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    static let backgroundBg = UIColor(patternImage: UIImage(named: "bg")!)
    static let fontColorGold = UIColor(red: 253/255, green: 191/255, blue: 44/255, alpha: 0.8)
    static let sepatatorColor: UIColor = UIColor(red: 219/255.0, green: 219/255.0, blue: 219/255.0, alpha: 1)//分割线
    static let navigationColor = ConstantUtil.mainBgColors[0]
    
    static let statusBarFrame = UIApplication.shared.statusBarFrame//status bar
    static let backImage:UIImage = UIImage(named: "back")!
    

    //MARKS: 创建Label
    static func createLabel(rect:CGRect,content:String,color:UIColor,textAlignment:NSTextAlignment,background:UIColor,fontName:String,fontSize:CGFloat) -> UILabel {
        let label = UILabel()
        label.text = content
        label.textAlignment = textAlignment
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        if !fontName.isEmpty && fontSize > 0 {
            label.font = UIFont(name: (fontName.isEmpty) ? fontName : self.fontName, size: fontSize)
        }
        label.textColor = color
        label.frame = rect
        //label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = background
        return label
    }
    
    static func createLabel(rect:CGRect,content:String,color:UIColor,textAlignment:NSTextAlignment,background:UIColor,font:UIFont) -> UILabel {
        let label = UILabel()
        label.text = content
        label.textAlignment = textAlignment
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        if !font.isEqual(nil){
            label.font = font
        }
        label.textColor = color
        label.frame = rect
        //label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = background
        return label
    }
    
    //MARKS: 获取Label高度和宽度
    static func getLabelRect(width:CGFloat,height:CGFloat,str:String,font:UIFont) -> CGRect{
        let options : NSStringDrawingOptions = [.usesLineFragmentOrigin,.usesFontLeading]
        let boundingRect = str.boundingRect(with: CGSize(width: width, height: height), options: options, attributes: [NSFontAttributeName:font], context: nil)
        return boundingRect
    }
    
    /**
     * 计算label的宽度和高度
     */
    static func labelSize(text:String,width:CGFloat,font:UIFont) -> CGRect{
        let size = CGSize(width: width, height: 0);//设置label的最大宽度
        return text.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font] , context: nil)
    }
    
    //MARKS: 添加阴影
    static func addShadow(layer:CALayer){
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.8, height: 0.8)
        layer.shadowRadius = 1
    }
    
    //创建Photo
    static func createPhotoView(frame:CGRect,image:UIImage,bounds:CGFloat) -> UIImageView{
        let photoView = UIImageView(frame: frame)
        photoView.image = image
        if bounds > 0 {
            photoView.layer.masksToBounds = true
            photoView.layer.cornerRadius = bounds
        }
        return photoView
    }
    
    //系统弹出框
    static func alert(title:String?,message:String?,isShowCancel:Bool,cancelCallBack:@escaping (_ alertAction:UIAlertAction)->(),doneCallback:@escaping (_ alertAction:UIAlertAction)->()) -> UIAlertController{
        let alertController = UIAlertController(title: title ?? "", message: message ?? "", preferredStyle: UIAlertControllerStyle.alert)
        if isShowCancel {
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel){ (alertAction) -> Void in
                cancelCallBack(alertAction)
            }
            alertController.addAction(cancelAction)
        }
        
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            doneCallback(alertAction)
        }
        
        alertController.addAction(okAction)
        
        return alertController
    }
}
