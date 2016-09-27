//
//  EmotionTool.swift
//  新浪微博
//
//  表情工具
//

import UIKit

class EmotionTool: NSObject {
    
    static var defaultEmotions:NSArray {
        let path = NSBundle.mainBundle().pathForResource("EmotionIcons/default/info", ofType: "plist")
        return Emotion.objectArrayWithKeyValuesArray(NSArray(contentsOfFile: path!)!)
    }
    
    static var emoji:NSArray {
        let path = NSBundle.mainBundle().pathForResource("EmotionIcons/emoji/info", ofType: "plist")
        return Emotion.objectArrayWithKeyValuesArray(NSArray(contentsOfFile: path!)!)
    }
    
    static var lxh:NSArray{
        let path = NSBundle.mainBundle().pathForResource("EmotionIcons/lxh/info", ofType: "plist")
        return Emotion.objectArrayWithKeyValuesArray(NSArray(contentsOfFile: path!)!)
    }
    
    
    // 最近表情的存储路径
    struct EmotionT {
        static let RecentEmotionsPath = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentationDirectory,NSSearchPathDomainMask.UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("emotions.archive")
    }
    
    //分配内存
    static var recentEmotions:NSMutableArray? = {
        var _recentEmotions = NSKeyedUnarchiver.unarchiveObjectWithFile(EmotionT.RecentEmotionsPath) as? NSMutableArray
        if _recentEmotions == nil{
            _recentEmotions = NSMutableArray()
        }
        return _recentEmotions!
    }()
    
    class func addRecentEmotion(emotion:Emotion){
        //删除重复的表情
        recentEmotions?.removeObject(emotion)
        //将表情放到数组的最前面
        recentEmotions?.insertObject(emotion, atIndex: 0)
        //将所有的表情数据写入沙盒
        NSKeyedArchiver.archiveRootObject(recentEmotions!, toFile: EmotionT.RecentEmotionsPath)
    }

    class func emotionWithChs(chs:String) -> Emotion?{
        let defaults = self.defaultEmotions
        for item in defaults{
            let emotion = item as! Emotion
            if emotion.chs == chs{
                return emotion
            }
        }
        
        let lxhs = self.lxh
        for item in lxhs{
            let lxh = item as! Emotion
            if lxh.chs == chs{return lxh}
        }
        return nil
    }
    

}
