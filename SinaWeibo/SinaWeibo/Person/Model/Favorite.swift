//
//  Favorite.swift
//  SinaWeibo
//
//  收藏模块
//

import UIKit

class Favorite: NSObject {
    
    //id
    var id:String?
    //微博frame
    var statusFrame:StatusFrame?
    //标签集
    var tags:[Tag]?
    //收藏时间
    var favorited_time:String?
    
    init(dict:[String:AnyObject]) {
        let statusDict = dict["status"] as! [String:AnyObject]
        let status = Status(dict: statusDict)
        let statusFrame = StatusFrame()
        statusFrame.status = status
        self.statusFrame = statusFrame
        
        var tags = [Tag]()
        if let tagsArr = dict["tags"] as? [AnyObject]{
            for item in tagsArr{
                let temp = item as? [String:AnyObject]
                let tag = Tag(dict: temp!)
                tags.append(tag)
            }
            self.tags = tags
        }
        
        self.favorited_time = dict["favorited_time"] as? String
        self.id = dict["id"] as? String
    }
    
    class func favoriteWithArr(arr:[AnyObject]) -> [Favorite]{
        var list = [Favorite]()
        for item in arr{
            if let dict = item as? [String:AnyObject]{
                list.append(Favorite(dict: dict))
            }
        }
        return list
    }
}
