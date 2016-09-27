//
//  Emotion.swift
//  新浪微博
//
// 表情模块
//

import UIKit

class Emotion: NSObject,NSCoding {
    /** 表情的文字描述 */
    var chs:String?
    /** 表情的png图片名 */
    var png:String?
    /** emoji表情的16进制编码 */
    var code:String?
    
    func equal(other:Emotion) -> Bool{
        return self.chs! == other.chs || self.code! == other.code
    }
    
    override init(){
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.chs, forKey: "chs")
        aCoder.encodeObject(self.png, forKey: "png")
        aCoder.encodeObject(self.code, forKey: "code")
        
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        self.chs = aDecoder.decodeObjectForKey("chs") as? String
        self.png = aDecoder.decodeObjectForKey("png") as? String
        self.code = aDecoder.decodeObjectForKey("code") as? String
        
    }
    
}
