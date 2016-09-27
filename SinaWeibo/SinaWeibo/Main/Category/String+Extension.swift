//
//  String+Extension.swift
//  新浪微博
//
//

import UIKit

extension String {

    //内容自适应
    func size(font:UIFont,maxW:CGFloat) -> CGSize{
        var attrs = [String:AnyObject]()
        attrs[NSFontAttributeName] = font
        let maxSize = CGSizeMake(maxW, CGFloat(MAXFLOAT))
        return self.boundingRectWithSize(maxSize, options: .UsesLineFragmentOrigin, attributes: attrs, context: nil).size
    }
    
    //内容自适应，宽度最大
    func size(font:UIFont) -> CGSize{
        return self.size(font, maxW: CGFloat(MAXFLOAT))
    }
    
    func fileSize() -> Int{
        
        let mgr = NSFileManager.defaultManager()
        // 判断是否为文件
        var dir:ObjCBool = false
        let exist = mgr.fileExistsAtPath(self, isDirectory: &dir)
        if !exist {return 0}
        
        if dir{
            // self是一个文件夹
            // 遍历caches里面的所有内容 --- 直接和间接内容
            let subpaths = mgr.subpathsAtPath(self)! as NSArray
            var totalByteSize = 0
            for subpath in subpaths{
                // 获得全路径
                let fullSubpath = (self as NSString).stringByAppendingPathComponent(subpath as! String)
                // 判断是否为文件
                var dir:ObjCBool = false
                mgr.fileExistsAtPath(fullSubpath, isDirectory: &dir)
                if !dir {
                    do{
                        totalByteSize += try mgr.attributesOfItemAtPath(fullSubpath)[NSFileSize] as! Int
                    }catch{}
                }
            }
            return totalByteSize
        }else{// self是一个文件
            do{
            
               return try mgr.attributesOfItemAtPath(self)[NSFileSize] as! Int
            }catch{
                return 0
            }
        }
        
    }
    
    //Rane 转 NSRange
    func NSRangeFromRange(range : Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        let from = String.UTF16View.Index(range.startIndex, within: utf16view)
        let to = String.UTF16View.Index(range.endIndex, within: utf16view)
        return NSMakeRange(utf16view.startIndex.distanceTo(from), from.distanceTo(to))
    }
    
    
    
    /**
     日期转化
     */
    
    func setTime() -> String{
        let fmt = NSDateFormatter()
        //转换欧美时间
        fmt.locale = NSLocale(localeIdentifier: "en_US")
        // 设置日期格式（声明字符串里面每个数字和单词的含义）
        // E:星期几
        // M:月份
        // d:几号(这个月的第几天)
        // H:24小时制的小时
        // m:分钟
        // s:秒
        // y:年
        fmt.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        // created_at = @"Tue Sep 30 17:06:25 +0600 2014";
        
        //微博的创建时间
        let createDate = fmt.dateFromString(self)
        //当前时间
        let now  = NSDate()
        
        //日历对象
        let calendar = NSCalendar.currentCalendar()
        // NSCalendarUnit枚举代表想获得哪些差值
        let unit:NSCalendarUnit = [.Year,.Month,.Day,.Hour,.Minute,.Second]
        // 计算两个日期之间的差值
        let cmps = calendar.components(unit, fromDate: createDate!, toDate: now, options:NSCalendarOptions.MatchStrictly)
        
        if createDate!.isThisYear(){
            if createDate!.isYesterday(){//昨天
                fmt.dateFormat = "昨天 HH:mm"
                return fmt.stringFromDate(createDate!)
            }else if createDate!.isTody(){//今天
                if cmps.hour >= 1{
                    return String(format: "%d小时前", arguments: [Int(cmps.hour)])
                }else if cmps.minute >= 1{
                    return String(format: "%d分钟前", arguments: [Int(cmps.minute)])
                }else{
                    return "刚刚"
                }
            }else{//今年的其他日子
                fmt.dateFormat = "MM-dd HH:mm"
                return fmt.stringFromDate(createDate!)
            }
        }else{//非今年
            fmt.dateFormat = "yyyy-MM-dd HH:mm"
            return fmt.stringFromDate(createDate!)
        }
    }
    
    //来源
    func source() -> String{
        if self.isEmpty{
            return ""
        }
        let startIndex = self.rangeOfString(">")?.endIndex
        let endIndex = self.rangeOfString("</")?.startIndex
        let range = Range<String.Index>(start: startIndex!,end: endIndex!)
        return String(format: "来自%@", arguments: [self.substringWithRange(range)])
    }
    
    
    /*****
     
     富文本
     ****/
    
    
    func setAttributedTextWithText() -> NSAttributedString{
        return attributedTextWithText(self)
    }
    
    
    private func attributedTextWithText(text:String?) -> NSAttributedString{
        var attributedText = NSMutableAttributedString()
        if text == nil{return attributedText}
        
        //表情
        let emotionPattern = "\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]"
        //attributedText = emotion(text!,attributedText: nil,font: StatusCellFont.ContentFont, pattern: emotionPattern)
        // @的规则
        let atPattern = "@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+"
        // #话题#的规则
        let topicPattern = "#[0-9a-zA-Z\\u4e00-\\u9fa5]+#"
        // url链接的规则
        let urlPattern = "\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))"
        let pattern = topicPattern + "|" + urlPattern + "|" + atPattern + "|" + emotionPattern
        
        
        
        
        attributedText = NSMutableAttributedString(string: text!)
        
        
        let regex = RegexHelper(pattern)
        let resultArray = regex.match(text!)
        
        //用来存放字典，字典中存储的是图片和图片对应的位置
        let arr = NSMutableArray(capacity: resultArray!.count)
        //根据匹配范围来用图片进行相应的替换
        for item:NSTextCheckingResult in resultArray!{
            let range = item.range
            //获取原字符串中对应的值
            let subStr = (text! as NSString).substringWithRange(range)
            if let emotion = EmotionTool.emotionWithChs(subStr){
                let attach = setAttachmentImage(emotion, font: StatusCellFont.ContentFont, range: range)
                arr.addObject(attach)
            }else if (subStr.hasPrefix("[") && subStr.hasSuffix("]")) {
                arr.addObject(NSAttributedString(string: subStr))
            }else{
                let specialDict = setAttachmentSpecial(subStr, font: StatusCellFont.ContentFont, range: range)
                arr.addObject(specialDict)
                
            }
            
        }
        
        //从后往前替换
        for var i = arr.count - 1; i>=0; i -= 1 {
            if let range:NSRange = arr[i]["imageRange"] as? NSRange{
                let imageAttr = arr[i]["image"] as! NSAttributedString
                //进行替换
                attributedText.replaceCharactersInRange(range, withAttributedString: imageAttr)
            }else if let range:NSRange = arr[i]["specialRange"] as? NSRange{
                let special = arr[i]["special"] as! NSAttributedString
                //进行替换
                
                attributedText.replaceCharactersInRange(range, withAttributedString: special)
                
            }
            
        }
        
        var specials = [Special]()
        for i in 0..<arr.count{
            if let special = arr[i]["special"] as? NSAttributedString{
                let range = attributedText.string.rangeOfString(special.string)
                let newRange = special.string.NSRangeFromRange(range!)
                arr.replaceObjectAtIndex(i, withObject: newRange)
                let sp = Special()
                sp.range = newRange
                specials.append(sp)
            }
        }
        
        
        attributedText.addAttribute(NSFontAttributeName, value: StatusCellFont.ContentFont, range: NSMakeRange(0, attributedText.length))
        attributedText.addAttribute("specials", value: specials, range: NSMakeRange(0,1))
        
        
        return attributedText
    }
    
    
    private func setAttachmentSpecial(subStr:String,font:UIFont,range:NSRange) -> NSMutableDictionary{
        let att = NSAttributedString(string: subStr, attributes: [NSForegroundColorAttributeName:UIColor.redColor()])
        let specialDic = NSMutableDictionary(capacity: 2)
        specialDic.setObject(att, forKey: "special")
        specialDic.setObject(NSValue(range: range), forKey: "specialRange")
        //把字典存入数组中
        return specialDic
    }
    
    
    private func setAttachmentImage(emotion:Emotion,font:UIFont,range:NSRange) ->NSMutableDictionary{
        //face[i][@"gif"]就是我们要加载的图片
        //新建文字附件来存放我们的图片
        let textAttachment = NSTextAttachment()
        //设置图片的尺寸
        let attchWH = font.lineHeight
        textAttachment.bounds = CGRectMake(0, -4, attchWH, attchWH)
        //给附件添加图片
        textAttachment.image = UIImage(named:emotion.png!)
        //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
        let imageStr = NSAttributedString(attachment: textAttachment)
        
        
        //把图片和图片对应的位置存入字典中
        let imageDic = NSMutableDictionary(capacity: 2)
        imageDic.setObject(imageStr, forKey: "image")
        imageDic.setObject(NSValue(range: range), forKey: "imageRange")
        //把字典存入数组中
        return imageDic
    }
    
    
    
    
    
}
