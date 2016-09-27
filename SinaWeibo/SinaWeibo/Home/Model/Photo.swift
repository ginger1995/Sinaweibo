
//
//  Photo.swift
//  新浪微博
//
//  图片模块
//

import UIKit

class Photo: NSObject {
    /** 缩略图地址 */
    var thumbnail_pic:String?
    
    init(dict:[String:AnyObject]){
        super.init()
        self.thumbnail_pic = dict["thumbnail_pic"] as? String
    }
    
    class func photoWithArr(arr:[AnyObject]) -> [Photo]{
        var list = [Photo]()
        for item in arr{
            guard let dict = item as? [String:AnyObject] else{continue}
            list.append(Photo(dict:dict))
        }
        return list
    }
}
