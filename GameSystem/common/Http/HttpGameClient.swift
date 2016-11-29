//
//  HttpGameClient.swift
//  GameSystem
//
//  Created by Smile on 2016/11/22.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import Foundation

class HttpGameClient{
    static let auth = "auth"
    
    static func anaylsParams(url:String,params:Dictionary<String,Any>) -> String {
        let list  = NSMutableArray()
        list.add("auth=\(auth)")//添加认证
        //拆分字典,subDic是其中一项，将key与value变成字符串
        for param in params {
            let tmpStr = "\(param.0)=\(param.1)"
            list.add(tmpStr)
        }
        //用&拼接变成字符串的字典各项
        return list.componentsJoined(by: "&")
    }
    
    static func request(url:String,param:String) -> URLRequest{
        let httpUrl = URL.init(string: url)
        var request:URLRequest = NSMutableURLRequest.init(url: httpUrl!) as URLRequest
        
        //保用 POST 提交
        request.httpMethod = "POST"
        //request.httpBody = data?.data(using: String.Encoding.utf8)
        //设置请求体
        request.httpBody = param.data(using: String.Encoding.utf8)//UTF8转码，防止汉字符号引起的非法网址
        return request
    }
    
    //同步请求
    static func syncRequest(url:String,param:String,success: @escaping ((_ result: AnyObject) -> ())) -> NSString{
        if(url.isEmpty){
            print("url or body is null.")
            return ""
        }
        
        let request:URLRequest = self.request(url:url,param:param) as URLRequest
        return sync(request: request, success: success)
    }
    
    //同步请求
    static func syncRequest(url:String,params:Dictionary<String,Any>,success: @escaping ((_ result: AnyObject) -> ())) -> NSString{
        if(url.isEmpty){
            print("url or body is null.")
            return ""
        }
        
        let paramStr:String = anaylsParams(url: url, params: params)
        let request:URLRequest = self.request(url:url,param:paramStr) as URLRequest
         return sync(request: request, success: success)
    }
    
    static func sync(request:URLRequest,success: @escaping ((_ result: AnyObject) -> ())) -> NSString{
        //响应对象
        var response:URLResponse?
        
        do{
            //发出请求
            let received:NSData? = try NSURLConnection.sendSynchronousRequest(request as URLRequest,returning: &response) as NSData?
            //let data = NSString(data:received! as Data, encoding: String.Encoding.utf8.rawValue)
            
            var result:AnyObject? = nil
            if received != nil {
                result = try JSONSerialization.jsonObject(with: (received as? Data)!, options: .allowFragments) as AnyObject?
            }
            
            success(result!)
        }catch let error as NSError{
            //打印错误消息
            print("Http syncRequest errorCode:\(error.code)")
            print("Http syncRequest description:\(error.description)")
        }
        
        return ""
    }

    
    //异步请求
    static func asynRequest(url:String,params:Dictionary<String,Any>,success: @escaping ((_ result: AnyObject) -> ()),failure: @escaping ((_ error: Error) -> ())){
        if(url.isEmpty){
            print("url is null.")
            return
        }
        
        let paramStr:String = anaylsParams(url: url, params: params)
        let request:URLRequest = self.request(url:url,param:paramStr) as URLRequest
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let result:AnyObject = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject?{
                    success(result)
                }
            }else {
                failure(error!)
            }
        }
        

        //启动任务
        dataTask.resume()
    }
    
}

