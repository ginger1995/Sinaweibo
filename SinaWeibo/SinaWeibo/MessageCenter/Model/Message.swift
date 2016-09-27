//
//  Message.swift
//  SinaWeibo
//
//

import UIKit

class Message: NSObject {
    //新评论数
    var cmt:Int?
    //新私信数
    var dm:Int?
    //	新提及我的微博数
    var mention_status:Int?
    //新提及我的评论数
    var mention_cmt:Int?
    //微群消息未读数
    //var group:Int?
    //私有微群消息未读数
    //var private_group:Int?
    //新通知未读数
    var notice:Int?
    //新邀请未读数
    var invite:Int?
    
    
    init(dict:[String:AnyObject]){
        self.cmt = dict["cmt"] as? Int
        self.dm = dict["dm"] as? Int
        self.mention_status = dict["mention_status"] as? Int
        self.mention_cmt = dict["mention_cmt"] as? Int
        
        
    }

}
