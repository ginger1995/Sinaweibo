//
//  UIButton+Extension.swift
//  SinaWeibo
//
//

import UIKit

extension UIButton {

    func setupBtnCount(count:Int?,inout title:String){
        
        guard count != nil else {return }
        if count > 0{
            if count < 10000 { //不足10000：直接显示数字
                title = String(format: "%d", arguments: [count!])
            }else{ //达到1000：显示xx.x万，不要有.0的情况
                let wan = Double(count!)/10000.0
                title = String(format: "%.1f万", arguments: [wan])
                //将字符串里面的.0去掉
                title = title.stringByReplacingOccurrencesOfString(".0", withString: "")
            }
        }
        self.setTitle(title, forState: .Normal)
    }
    
    func setupBtnCount(count:Int?,title:String){
        
        guard count != nil else {return }
        var newTitle = title
        
        if count < 10000 { //不足10000：直接显示数字
            newTitle += String(format: "%d", arguments: [count!])
        }else{ //达到1000：显示xx.x万，不要有.0的情况
            let wan = Double(count!)/10000.0
            let temp = String(format: "%.1f万", arguments: [wan])
            //将字符串里面的.0去掉
            newTitle = temp.stringByReplacingOccurrencesOfString(".0", withString: "")
            }
        self.setTitle(newTitle, forState: .Normal)
    }

}
