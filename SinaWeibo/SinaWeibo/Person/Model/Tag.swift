//
//  Tag.swift
//  SinaWeibo
//
//

import UIKit

class Tag: NSObject {
    var id:Int?
    var tag:String?
    
    init(dict:[String:AnyObject]) {
        self.id = dict["id"] as? Int
        self.tag = dict["tag"] as? String
    }
}
