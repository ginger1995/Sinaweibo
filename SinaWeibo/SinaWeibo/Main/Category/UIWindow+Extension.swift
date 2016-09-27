
//
//  UIWindow+Extension.swift
//  新浪微博
//
//

import UIKit

extension UIWindow{
    
    func switchRootViewController(){
        let key = "CFBundleVersion"
        
        //当前软件的版本号(从Info.plist中获得)
        let currentVersion = NSBundle.mainBundle().infoDictionary![key]
        // 版本号相同：这次打开和上次打开的是同一个版本
        
        //上一次的使用版本（存储在沙盒中的版本号）
        if let lastVersion = NSUserDefaults.standardUserDefaults().objectForKey(key){
           
            if currentVersion!.isEqualToString(lastVersion as! String){
                self.rootViewController = TabBarViewController()
            }else{
               setNewfeatureWithRoot(currentVersion!, key: key)
            }
        }else{
            setNewfeatureWithRoot(currentVersion!, key: key)
        }
    }
    
    func setNewfeatureWithRoot(currentVersion:AnyObject,key:String){
        self.rootViewController = NewfeatureViewController()
        //存储沙盒
        NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: key)
        //强制写入硬盘
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
