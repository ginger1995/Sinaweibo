//
//  UIBarButtonItem+Extension.swift
//  新浪微博
//
//

import UIKit

extension UIBarButtonItem{
    /**
    *  创建一个item
    *
    *  param target    点击item后调用哪个对象的方法
    *  param action    点击item后调用target的哪个方法
    *  param image     图片
    *  param highImage 高亮的图片
    *
    *  return 创建完的item
    */
    
    class func item(target:AnyObject?,action: Selector,image:String,highImage:String) -> UIBarButtonItem{
        
        let btn = UIButton(type: .Custom)
        btn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        //设置图片
        btn.setBackgroundImage(UIImage(named: image), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: highImage), forState: .Highlighted)
        //设置尺寸
        btn.size = btn.currentBackgroundImage!.size
        return UIBarButtonItem(customView: btn)
    }
}