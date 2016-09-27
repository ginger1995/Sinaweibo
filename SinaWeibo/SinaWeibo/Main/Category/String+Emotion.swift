//
//  String+Emoji.swift
//  新浪微博
//
//

import Foundation

extension String{
    
    func emoji() -> String{
        return emojiWithStringCode(self)
    }
    
    private func emojiWithStringCode(stringCode:String) -> String{
      
        let charCode = (stringCode as NSString).UTF8String
        let intCode = strtol(charCode, nil, 16)
        
       return String(UnicodeScalar(intCode))
    }
    
    
//    //sizeof(symbol.dynamicType)
//    static func emojiWithIntCode(intCode:Int) -> String{
//        var symbol = Emoji.EmojiCodeToSymbol(intCode)
//        var str = NSString(bytes: &symbol, length: sizeofValue(symbol), encoding: NSUTF8StringEncoding) as? String
//        if str == nil{
//            str = String(format: "%C", arguments: [unichar(intCode)])
//        }
//        return str!
//    }
//    
//    private struct Emoji{
//        static func EmojiCodeToSymbol(c:Int) -> Int{
//            return ((((0x808080F0 | (c & 0x3F000) >> 4) | (c & 0xFC0) << 10) | (c & 0x1C0000) << 18) | (c & 0x3F) << 24)
//        }
//    }
//    
//    
    
    // 判断是否是 emoji表情
    func isEmoji() -> Bool{
        var returnValue = false
        let hs:unichar = (self as NSString).characterAtIndex(0)
        if (0xd800 <= hs && hs <= 0xdbff){
            if self.characters.count > 1{
                let ls:unichar = (self as NSString).characterAtIndex(1)
                let uc:Int = ((Int(hs) - 0xd800) * 0x400) + (Int(ls) - 0xdc00) + 0x10000
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = true
                }
            }
        }else if self.characters.count > 1{
            let ls:unichar = (self as NSString).characterAtIndex(1)
            if (ls == 0x20e3){
                returnValue = true
            }
        }else{
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = true;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = true;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = true;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = true;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = true;
            }
        }
        
        return returnValue
    }
    
    
   
}