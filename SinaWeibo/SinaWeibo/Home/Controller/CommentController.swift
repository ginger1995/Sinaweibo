//
//  CommentController.swift
//  SinaWeibo
//
//  评论
//

import UIKit
protocol CommentControllerDelegate:class{
    func commentDidSumbit(comment:Comment)
}

class CommentController: TextViewController {
    //微博id
    //var id:NSNumber!
    
    var id:AnyObject?
    
    weak var delegate:CommentControllerDelegate?

    override func viewDidLoad() {
        prefix = "评论微博"
        super.viewDidLoad()
        textView.placeholder = "评论微博..."
        
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
    override func send(){
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
        params["comment"] = textView.fullText
        
        HttpTool.post(XLMess.Status_Comment_Url, params: params, success: { (dict) in
            if dict["error"] != nil{
                print(dict)
            }else{
                let comment = Comment(dict: dict)
                self.delegate?.commentDidSumbit(comment)
                MessageTool.showText("评论成功")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            MessageTool.dissm()
            }, failure: nil)
    }
    
}


