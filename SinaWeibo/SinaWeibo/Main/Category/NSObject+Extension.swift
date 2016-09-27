//
//  NSObject+Extension.swift
//  新浪微博
//
//  
//

import Foundation

extension NSObject{
    
    
    class func objectArrayWithKeyValuesArray(keyValuesArray:NSArray) -> NSMutableArray{
        
        let modelArray = NSMutableArray()
        if keyValuesArray.isKindOfClass(NSArray){//判断是否数组
            for keyValues in keyValuesArray{
                if !keyValues.isKindOfClass(NSDictionary){
                    continue
                }
                let model = self.objectWithKeyValues(keyValues as! NSDictionary)//判断是否是字典
                modelArray.addObject(model)
            }
        }else{
            NSLog("keyValuesArray不是一个数组 %@ ", #function)
        }
        return modelArray
    }
//    
//    class func objectWithKeyValues(keyValues:NSDictionary) -> Self{
//        let objc = self.init()
//        if keyValues.isKindOfClass(NSDictionary){
//            objc.setKeyValues(keyValues)
//        }
//        return objc
//    }
//    
//    func setKeyValues(keyValues:NSDictionary){
//        
//    }
//    
    /// 通过字典来创建一个模型  @param keyValues 字典 @return 新建的对象如果你的模型中有Number Int 8 32 64等 请写成String 预防类型安全
    class func objectWithKeyValues(Dict:NSDictionary)->Self{
        let objc = self.init()
        var count:UInt32 = 0
        //        var ivars = class_copyIvarList(self.classForCoder(), &count)
        let properties = class_copyPropertyList(self.classForCoder(),&count)
        
        for i in 0 ..< Int(count){
            //var ivar :Ivar = ivars[i]
            
            let propert : objc_property_t  = properties[i];
            
            let keys : NSString = NSString(CString: property_getName(propert), encoding: NSUTF8StringEncoding)!
            
            let types : NSString = NSString(CString: property_getAttributes(propert), encoding: NSUTF8StringEncoding)!
            
            let value :AnyObject? = Dict[keys]
            let CoustomPrefix:String?
            = types.substringFromIndex("T@".lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            var CustomValueName:String?
            if !CoustomPrefix!.hasPrefix(","){
                CustomValueName = CoustomPrefix!.componentsSeparatedByString(",").first!
            }
            //  自定义类型
            if value != nil{
                if  value! is [String:AnyObject] {
                    // 根据类型字符串创建类
                    
                    if swiftClassFromString(CustomValueName!) != nil {
                        // 递归
                        let CustomValueObject: AnyObject =
                        swiftClassFromString(CustomValueName!).objectWithKeyValues(value as! [String:AnyObject])
                        
                        objc.setValue(CustomValueObject, forKey: keys as String)
                    }
                    
                }else{
                    
                    if value! is NSNumber {
                        
                        objc.setValue("\(value!)", forKeyPath:keys as String)
                        
                    }else{
                        objc.setValue(value!, forKeyPath:keys as String)
                        
                    }
                    
                }
            }
            
        }
        free(properties)
        return objc
        
    }
    
    /// 得到自定义类型的类名 如果你的模型中有Number Int 8 32 64等 请写成String 预防类型安全
    
    private  class func swiftClassFromString(className: String) -> AnyClass! {
        
        if  let appName: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String? {
            
            if className.hasPrefix("\""){
                
                // "\"User\""
                var rang = (className as NSString).substringFromIndex("\"".lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
                // 类型字符串截取
                let length = rang.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
                // User\""
                rang = (rang as NSString).substringToIndex(length.hashValue-1)
                return NSClassFromString("\(appName).\(rang)")
                
            }
            
        }
        
        return nil;
        
    }
    


}