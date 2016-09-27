//
//  User.swift
//  新浪微博
//
//  用户模块
//

import UIKit

class User: NSObject {
    
    /**	string	字符串型的用户UID*/
    var idstr:String?
    /**	string	友好显示名称*/
    var name:String?
    /**	string	用户头像地址，50×50像素*/
    var profile_image_url:String?
    /** 会员类型 > 2代表是会员 */
    var mbtype:Int?
    /** 会员等级 */
    var mbrank:Int?
    var vip:Bool = false
    //高清大图
    var avatar_large:String?
    
    //创建时间
    var created_at:String?
    //用户个人描述
    var descriptionStr:String?
    //粉丝数
    var followers_count:Int?
    //关注数
    var friends_count:Int?
    //微博数
    var statuses_count:Int?
    //收藏数
    var favourites_count:Int?
    //最新微博
    var status:Status?
    //关注这个用户
    var following:Bool? = false
    //关注自己
    var follow_me:Bool? = false
    /** 认证类型 */
    var verufued_type:UserVerifiedType = .None
    
    enum UserVerifiedType{
        case None // 没有任何认证
        case Personal  // 个人认证
        case OrgEnterprice // 企业官方：CSDN、EOE、搜狐新闻客户端
        case OrgMedia // 媒体官方：程序员杂志、苹果汇
        case OrgWebsite // 网站官方：猫扑
        case Daren// 微博达人
    }
    
    override init() {
        super.init()
    }
    
    init(dict:[String:AnyObject]?){
        self.idstr = dict?["idstr"] as? String
        self.name = dict?["name"] as? String
        self.profile_image_url = dict?["profile_image_url"] as? String
        self.mbtype = dict?["mbtype"] as? Int
        self.vip = self.mbtype > 2
        self.mbrank = dict?["mbrank"] as? Int
        
        self.descriptionStr = dict?["description"] as? String
        self.followers_count = dict?["followers_count"] as? Int
        self.friends_count = dict?["friends_count"] as? Int
        self.statuses_count = dict?["statuses_count"] as? Int
        self.favourites_count = dict?["favourites_count"] as? Int
        self.avatar_large = dict?["avatar_large"] as? String
        let dateStr = dict?["created_at"] as? String
        self.created_at = dateStr?.setTime()
        
        if let statusDict = dict?["status"] as? [String:AnyObject]{
            self.status = Status(dict: statusDict)
        }
        
        self.following = dict?["following"] as? Bool
        self.follow_me = dict?["follow_me"] as? Bool
        
    }
    
    class func userWithArray(arr:[AnyObject]) -> [User]{
        var list = [User]()
        for item in arr{
            if let dict = item as? [String:AnyObject]{
                list.append(User(dict:dict))
            }
        }
        return list
    }
    
}
