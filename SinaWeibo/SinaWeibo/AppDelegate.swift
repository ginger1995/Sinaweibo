//
//  AppDelegate.swift
//  SinaWeibo
//
//

import UIKit
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //1.主窗口创建
        self.window = UIWindow()
        self.window?.frame = UIScreen.mainScreen().bounds
        
        //2.设置根控制器
        self.window?.switchRootViewController()        
        
        //3.显示窗口
        self.window?.makeKeyAndVisible()
        
        return true
    }

     // 内存警告
    func applicationDidReceiveMemoryWarning(application: UIApplication) {
       
        let cache = KingfisherManager.sharedManager.cache
        
        // Set max disk cache to 50 mb. Default is no limit.
        cache.maxDiskCacheSize = 50 * 1024 * 1024
        
        // Set max disk cache to duration to 3 days, Default is 1 week.
        cache.maxCachePeriodInSecond = 60 * 60 * 24 * 7
        
        //        // Get the disk size taken by the cache.
        //        cache.calculateDiskCacheSizeWithCompletionHandler { (size) -> () in
        //            print("disk size in bytes: \(size)")
        //        }
        
        // Clear memory cache right away.
        cache.clearMemoryCache()
        
        // Clear disk cache. This is an async operation.
        cache.clearDiskCache()
    }
    


}

