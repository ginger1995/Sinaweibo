//
//  Comment.swift
//  SinaWeibo
//
//  评论模块
//

import UIKit

class Comment: NSObject {
    
    //评论创建时间
    var created_at:String?
    //评论id
    var id:NSNumber?
    //评论内容
    var text:NSAttributedString?
    //评论的来源
    var source:String?
    //评论作者的用户信息字段
    var user:User?
    //字符串型的评论ID
    var idstr:String?
    
    //评论的微博信息字段
    //var status:Status?
    //评论来源评论，当本评论属于对另一评论的回复时返回此字段
    //var reply_comment:Comment?
    
    init(dict:[String:AnyObject]) {
        self.id = dict["id"] as? NSNumber
        let text = dict["text"] as? String
        self.text = text?.setAttributedTextWithText()
        let time = dict["created_at"] as? String
        self.created_at = time?.setTime()
        let str = dict["source"] as? String
        self.source = str?.source()
        self.user = User(dict: dict["user"] as? [String:AnyObject])
        self.idstr = dict["idstr"] as? String
        
    }
    
    class func commentWith(arr:[AnyObject]) -> [Comment]{
        var list = [Comment]()
        for item in arr{
            guard let dict = item as? [String:AnyObject] else {continue}
            let comment = Comment(dict: dict)
            list.append(comment)
        }
        return list
    }
}
