//
//  RegexHelper.swift
//  SinaWeiBo
//
//  正则工具
//

import UIKit

struct RegexHelper {
    
    let regex: NSRegularExpression?
    init(_ pattern: String) {
        do{
            regex = try NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
        }catch{
            regex = nil
        }
    }
    
    func match(input: String) -> [NSTextCheckingResult]? {
        let matches = regex?.matchesInString(input, options: NSMatchingOptions.init(rawValue: 0), range: NSMakeRange(0, input.characters.count))
        return matches
    }
    
    func matchReturnBool(input: String) -> Bool {
        if let matches = regex?.matchesInString(input, options: NSMatchingOptions.init(rawValue: 0), range: NSMakeRange(0, input.characters.count)) {
            return matches.count > 0
        }else{
            return false
        }
    }
    
    
//    static func limitChar(str:String,count:Int)->Bool{
//        let charPattern = "^[\\w]{0,\(count)}$"
//        let matcher = RegexHelper(charPattern)
//        return matcher.matchReturnBool(str)
//    }

}
