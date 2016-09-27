//
//  Account.swift
//  新浪微博
//
//

import Foundation

class Account:NSObject, NSCoding{
    /**　string	用于调用access_token，接口获取授权后的access token。*/
    var access_token:String?
    /**　string	access_token的生命周期，单位是秒数。*/
    var expires_in:NSNumber?
    /**　string	当前授权用户的UID。*/
    var uid:String?
    /**	access token的创建时间 */
    var created_time:NSDate?
    /** 用户的昵称 */
    var name:String?
   
    override init(){
        super.init()
    }
    //    /**
    //    *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
    //    *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
    //    */
    @objc required init?(coder aDecoder: NSCoder) {
        self.access_token = aDecoder.decodeObjectForKey("access_token") as? String
        self.expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        self.uid = aDecoder.decodeObjectForKey("uid") as? String
        self.created_time = aDecoder.decodeObjectForKey("created_time") as? NSDate
        self.name = aDecoder.decodeObjectForKey("name") as? String
    }
    //MJCodingImplementation
    /**
    *  当一个对象要归档进沙盒中时，就会调用这个方法
    *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
    */
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.access_token, forKey: "access_token")
        aCoder.encodeObject(self.expires_in, forKey: "expires_in")
        aCoder.encodeObject(self.uid, forKey: "uid")
        aCoder.encodeObject(self.created_time, forKey: "created_time")
        aCoder.encodeObject(self.name, forKey: "name")
    }
    
    class func account(dict:[String:AnyObject]) -> Account{
        let account = Account()
        account.access_token = dict["access_token"] as? String
        account.uid = dict["uid"] as? String
        account.expires_in = dict["expires_in"] as? NSNumber
        //获得帐号存储的时间（accessToken的产生时间）
        account.created_time = NSDate()
        return account
    }
}