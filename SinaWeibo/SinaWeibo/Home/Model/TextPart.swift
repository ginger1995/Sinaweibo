//
//  TextPart.swift
//  新浪微博
//
//  富文本模块
//

import UIKit

class TextPart: NSObject {

    /** 这段文字的内容 */
    var text:String?
    /** 这段文字的范围 */
    var range:NSRange?
    /** 是否为特殊文字 */
    var special:Bool = false
    /** 是否为表情 */
    var emotion:Bool = false
    
}
