//
//  NavigationViewController.swift
//  新浪微博
//
//  自定义导航控制器
//

import UIKit

class NavigationViewController: UINavigationController {
   
    /**
    *  重写这个方法目的：能够拦截所有push进来的控制器
    *
    *  param viewController 即将push进来的控制器
    */
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        
        // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        if self.viewControllers.count > 0{
             /* 自动显示和隐藏tabbar */
            viewController.hidesBottomBarWhenPushed = true
            /* 设置导航栏上面的内容 */
            // 设置左边的返回按钮
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.item(self, action: #selector(NavigationViewController.back), image: "navigationbar_back", highImage: "navigationbar_back_highlighted")
            
            //设置右边的更多按钮
            viewController.navigationItem.rightBarButtonItem = UIBarButtonItem.item(self, action: #selector(NavigationViewController.more), image: "navigationbar_more", highImage: "navigationbar_more_highlighted")
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    func back(){
        self.popViewControllerAnimated(true)
    }
    
    func more(){
        self.popToRootViewControllerAnimated(true)
    }

}
