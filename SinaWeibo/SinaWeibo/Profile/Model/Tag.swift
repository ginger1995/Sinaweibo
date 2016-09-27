//
//  Tag.swift
//  SinaWeibo
//
//  Created by GDG on 16/4/18.
//  Copyright © 2016年 chashao. All rights reserved.
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
