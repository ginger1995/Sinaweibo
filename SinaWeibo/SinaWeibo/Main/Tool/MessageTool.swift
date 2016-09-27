//
//  MessageTool.swift
//  SinaWeibo
//
//  弹窗工具
//

import UIKit
import WSProgressHUD

class MessageTool: UIView {

    class func showText(string:String?){
        WSProgressHUD.showImage(nil, status: string)
    }
    
    class func showLoadWithText(string: String?){
        WSProgressHUD.showWithStatus(string, maskType: .Black)
    }
    
    class func showLoad(){
        showLoadWithText("正在加载...")
    }
    
    class func dissm(){
        WSProgressHUD.dismiss()
    }
    
}
