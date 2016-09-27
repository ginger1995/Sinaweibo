//
//  HttpTool.swift
//  SinaWeibo
//
//  网络请求工具
//

import UIKit
import UIKit
import Alamofire


class HttpTool {

   
    //get 请求
    class func get(url:String,params:[String:AnyObject]?,success:((_:[String:AnyObject]) -> Void)?,failure:((error:NSError?) -> Void)?){
        Alamofire.request(.GET, url, parameters: params).responseJSON { (response) -> Void in
            if response.result.error != nil || response.response == nil{
                failure?(error: response.result.error)
                MessageTool.showText("请检查你的网络")
                return
            }
            
            if let JSON = response.result.value {
                guard let dict = JSON as? [String:AnyObject] else{
                    MessageTool.dissm()
                    return}
                success?(dict)
            }
        }
    }
    
    //post 请求
    class func post(url:String,params:[String:AnyObject]?,success:((_:[String:AnyObject]) -> Void)?,failure:((error:NSError?) -> Void)?){
        Alamofire.request(.POST, url, parameters: params).responseJSON { (response) -> Void in
            if response.result.error != nil || response.response == nil{
                failure?(error: response.result.error)
                MessageTool.showText("请检查你的网络")
                return
            }
            
            if let JSON = response.result.value {
                guard let dict = JSON as? [String:AnyObject] else{
                    MessageTool.dissm()
                    return
                }
                success?(dict)
            }
        }
    }
    
    //post 带json 请求
    class func postWidthJson(url:String,params:[String:AnyObject]?,success:((_:[String:AnyObject]) -> Void)?,failure:((error:NSError?) -> Void)?){
        
        Alamofire.request(.POST, url, parameters: params, encoding: .JSON).responseJSON { (response) -> Void in
            if response.result.error != nil || response.response == nil{
                failure?(error: response.result.error)
                MessageTool.showText("请检查你的网络")
                return
            }
            
            if let JSON = response.result.value {
                guard let dict = JSON as? [String:AnyObject] else{
                    MessageTool.dissm()
                    return}
                success?(dict)
            }
        }
    }
    
    //图片上传
    class func upload(request:(URLRequestConvertible, NSData),progress:((Int64, Int64, Int64) -> Void)?,success:((_:[String:AnyObject]) -> Void)?,failure:((error:NSError?) -> Void)?){
        Alamofire.upload(request.0,data: request.1).progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                //                print("Total bytes written on main queue: \(totalBytesWritten)")
                progress?(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
            }
            }.responseJSON { (response) -> Void in
                if response.result.error != nil || response.response == nil{
                    failure?(error: response.result.error)
                    MessageTool.showText("请检查你的网络")
                    return
                }
                
                if let JSON = response.result.value {
                    guard let dict = JSON as? [String:AnyObject] else{
                        MessageTool.dissm()
                        return}
                    success?(dict)
                }
        }
    }
    
    
    
    
    class func urlRequestWithComponents(urlString:String, parameters:NSDictionary) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Method.POST.rawValue
        //let boundaryConstant = "myRandomBoundary12345"
        let boundaryConstant = "NET-POST-boundary-\(arc4random())-\(arc4random())"
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add parameters
        for (key, value) in parameters {
            
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            if value is NetData {
                // add image
                let postData = value as! NetData
                
                
                //uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(postData.filename)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                
                // append content disposition
                let filenameClause = " filename=\"\(postData.filename)\""
                let contentDispositionString = "Content-Disposition: form-data; name=\"\(key)\";\(filenameClause)\r\n"
                let contentDispositionData = contentDispositionString.dataUsingEncoding(NSUTF8StringEncoding)
                uploadData.appendData(contentDispositionData!)
                
                // append content type
                //uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!) // mark this.
                let contentTypeString = "Content-Type: \(postData.mimeType.getString())\r\n\r\n"
                let contentTypeData = contentTypeString.dataUsingEncoding(NSUTF8StringEncoding)
                uploadData.appendData(contentTypeData!)
                uploadData.appendData(postData.data)
                
            }else{
                uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
            }
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        // return URLRequestConvertible and NSData
        return (ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }


}
