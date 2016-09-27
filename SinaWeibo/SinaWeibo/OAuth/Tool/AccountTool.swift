//
//  AccountTool.swift
//  新浪微博
//
//

import Foundation

class AccountTool:NSObject{
    
    struct ATool{
        static let Path = (NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("account.archive")
    }
    
    /**
    *  存储账号信息
    *
    *  param account 账号模型
    */
    class func saveAccount(account:Account){
        //自定义对象的存储必须用NSKeyedArchiver,不再有什么writeToFile方法
        NSKeyedArchiver.archiveRootObject(account, toFile: ATool.Path as String)
    }
    
    /**
    *  返回账号信息
    *
    *  return 账号模型（如果账号过期，返回nil）
    */
    class func account() -> Account?{
        //加载模型
        if let account = NSKeyedUnarchiver.unarchiveObjectWithFile(ATool.Path as String) as? Account{
            /* 验证账号是否过期 */
            
            // 过期的秒数
            let expires_in = account.expires_in?.doubleValue
            //获得过期时间
            let expiresTime = account.created_time?.dateByAddingTimeInterval(expires_in!)
            //获得当前时间
            let now = NSDate()
            // 如果expiresTime <= now，过期
            /**
            OrderedAscending = -1L, 升序，右边 > 左边
            OrderedSame, 一样
            OrderedDescending 降序，右边 < 左边
            */
            let result = expiresTime?.compare(now)
            if result != NSComparisonResult.OrderedDescending{ //过期
                return nil
            }
            return account
        }
        return nil
    }
    
}