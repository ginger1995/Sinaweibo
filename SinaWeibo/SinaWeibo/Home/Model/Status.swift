//
//  Status.swift
//  新浪微博
//
//  新浪状态模块
//

import UIKit


class Status: NSObject {

    //var id:NSNumber?
    var id:AnyObject?
    
    /**	string	字符串型的微博ID*/
    var idstr:String?
    
    /**	string	微博信息内容*/
    var text:String?
    /**	string	微博信息内容 -- 带有属性的(特殊文字会高亮显示\显示表情)*/
    var attributedText:NSAttributedString?
    /**	object	微博作者的用户信息字段 详细*/
    var user:User?
    
    /**	string	微博创建时间*/
    var created_at:String?
    
    /**	string	微博来源*/
    var source:String?
    
    /** 微博配图地址。多图时返回多图链接。无配图返回“[]” */
    var pic_urls:[Photo]?
    
    /** 被转发的原微博信息字段，当该微博为转发微博时返回 */
    var retweeted_status:Status?{
        didSet{
            self.retweetedAttributedText = setRetweetedAttributedTextWithStatus(self.retweeted_status)
        }
    }
    /**	被转发的原微博信息内容 -- 带有属性的(特殊文字会高亮显示\显示表情)*/
    var retweetedAttributedText:NSAttributedString?
    
    /**	int	转发数*/
    var reposts_count:Int?
    /**	int	评论数*/
    var comments_count:Int?
    /**	int	表态数*/
    var attitudes_count:Int?
    /** 是否收藏 **/
    var favorited:Bool? = false
    
    /** 中等尺寸图片地址 **/
    var bmiddle_pic:String?
    
    /**	原始图片地址 **/
    var original_pic:String?
    
    override init(){
        super.init()
    }
    
    init(dict:[String:AnyObject]) {
        super.init()
        self.id = dict["id"] 
        //self.id = dict["id"] as? NSNumber
        self.idstr = dict["idstr"] as? String
        self.text = dict["text"] as? String
        self.attributedText = self.text?.setAttributedTextWithText()
        let time = dict["created_at"] as? String
        self.created_at = time?.setTime()
        let str = dict["source"] as? String
        self.source = str?.source()
        
        if let pic_urlsArr = dict["pic_urls"] as? [AnyObject]{
            self.pic_urls = Photo.photoWithArr(pic_urlsArr)
        }
        
        self.reposts_count = dict["reposts_count"] as? Int
        self.comments_count = dict["comments_count"] as? Int
        self.attitudes_count = dict["attitudes_count"] as? Int
        self.user = User(dict: dict["user"] as? [String:AnyObject])
        self.favorited = dict["favorited"] as? Bool
        self.bmiddle_pic = dict["bmiddle_pic"] as? String
        self.original_pic = dict["original_pic"] as? String
        
    }
    
    func setRetweetedAttributedTextWithStatus(status:Status?) ->
        NSAttributedString{
        let retweetContent = String(format: "@%@ : %@", arguments: [status!.user!.name!,status!.text!])
        return retweetContent.setAttributedTextWithText()
    }
    
   
    
    class func statusWithArr(array:[AnyObject]) -> [Status]{
        var list = [Status]()
        
        for item in array{
            let statusDict = item as! [String:AnyObject]
            let status = Status(dict: statusDict)
            if let retweeted = statusDict["retweeted_status"]{
                status.retweeted_status = Status(dict: retweeted as! [String : AnyObject])
            }
            list.append(status)
        }
        return list
    }
}
