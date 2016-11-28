//
//  BaseContact.swift
//  GameSystem
//
//  Created by Smile on 2016/11/25.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import Foundation
import Contacts

//用于存放值键队
struct ContactSession {
    var key:String
    var contacts:Array<AnyObject>
    
    init(){
        key = ""
        contacts = [AnyObject]()
    }
}

class ContactModel {
    
    //MARKS: Properties
    let image = ["contact1","contact2","contact3"]
    var contacts = [AnyObject]()//要传入的数据
    var contactSesion = [ContactSession]()//存储最终生成的实体
    var fieldName:String = ""
    var isNeedPhoto:Bool = true
    
   func convert(contacts:[AnyObject],fieldName:String,isNeedPhoto:Bool?) -> [ContactSession]{
        if (contacts.isEmpty || contacts.count <= 0) || fieldName.isEmpty {
            print("ContactModel init() contacts or fieldName null.")
            return self.contactSesion
        }
        
        self.contacts = contacts
        self.fieldName = fieldName
        self.isNeedPhoto = isNeedPhoto ?? true
        return initContacts()
    }
    
   private func initContacts() -> [ContactSession]{
        var count:Int = 0
        
        for contact in self.contacts {
            //根据字段反射实体类中的数据
            let children = Mirror(reflecting: contact).children.filter { $0.label != nil }
            
            var value:String = ""
            for child in children {
                if child.label != self.fieldName {  continue }
                value = child.value as! String
            }
            
            if value.isEmpty { continue }
            
            convertToDictionary(value:value, obj:contact)
            count += 1
        }
    
        return Array(self.contactSesion).sorted { (session1, session2) -> Bool in
            session1.key < session2.key
        }
    
    }
    
    
    //按英文名字组装成字典
    private func convertToDictionary(value:String,obj:AnyObject){
        var new = true
        var englishName:String = ContactModel.getEnglistByName(name: value)
        //如果没有,用"*"代替
        if  englishName.lengthOfBytes(using: String.Encoding.utf8) < 1 {
            englishName = "*"
        }
        
        let firstChar:String = ContactModel.getFirstChar(englishName: englishName)
        
        var i:Int = 0
        for session in contactSesion {
            if session.key == firstChar {
                new = false
                var _session = session
                _session.contacts.append(obj)
                contactSesion[i] = _session
                i += 1
                break;
            }
        
            i += 1
        }
        
        if new {
            var newContactSession = ContactSession()
            newContactSession.key = firstChar.uppercased()
            newContactSession.contacts = [obj]
            contactSesion.append(newContactSession)
        }
    }
    
    //MARKS: 获取中文的拼音
    static func getEnglistByName(name:String) -> String{
        let s =  NSMutableString(string:name) as CFMutableString
        CFStringTransform(s, nil, kCFStringTransformMandarinLatin, false)
        //去掉音标
        CFStringTransform(s, nil, kCFStringTransformStripDiacritics, false)
        return s as String
    }
    
    //获取英文名字的第一个字母,转大写
    static func getFirstChar(englishName:String) -> String{
        return englishName.substring(to: englishName.index(englishName.startIndex, offsetBy: 1)).uppercased()
    }
    
   
}
