//
//  Special.swift
//  新浪微博
//
//  特殊字模块
//

import UIKit

class Special: NSObject {
    /** 这段特殊文字的内容 */
    var text:String?
    /** 这段特殊文字的范围 */
    var range:NSRange?
    /** 这段特殊文字的矩形框(要求数组里面存放CGRect) */
    var rects:[CGRect]?
}
