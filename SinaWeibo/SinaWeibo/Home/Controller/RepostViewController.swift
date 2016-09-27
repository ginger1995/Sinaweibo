//
//  RepostViewController.swift
//  SinaWeibo
//
//  转发微博
//

import UIKit

class RepostViewController: TextViewController {
    
    //var id:NSNumber?
    var id:AnyObject?
    
    override func viewDidLoad() {
        prefix = "转发微博"
        super.viewDidLoad()
        textView.placeholder = "分享新鲜事..."
    }
    
    /**
     * 添加工具条
     */
    override func setupTooBar(){
        toolbar = ComposeToolbar(camra: false,picture: false,trend: false)
        toolbar.width = self.view.width
        toolbar.height = 44
        toolbar.delegate = self
        toolbar.y = self.view.height - toolbar.height
        self.view.addSubview(toolbar)
    }
    
    //发送
    override func send() {
        super.send()
        MessageTool.showLoadWithText("正在提交...")
        
//        let limitCount = 140
//        if !RegexHelper.limitChar(textView.fullText, count: limitCount) {
//            MessageTool.showText("不超过\(limitCount)个汉字")
//            return
//        }
        
        let account = AccountTool.account()
        var params = [String:AnyObject]()
        params["access_token"] = account?.access_token
        params["id"] = id
        if textView.fullText.characters.count > 0{
            params["status"] = textView.fullText
        }
        
        HttpTool.post(XLMess.Status_Repost_Url, params: params, success: { (dict) in
            if dict["error"] != nil{
                print(dict)
                MessageTool.dissm()
            }else{
                MessageTool.showText("转发成功")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            }, failure: nil)
        
    }

}
