//
//  EmotionTextView.swift
//  新浪微博
//
//

import UIKit

class EmotionTextView: TextView {
    
    var fullText:String{
        get{
            let text = NSMutableString()
            //遍历所有的属性文字
            self.attributedText.enumerateAttributesInRange(NSMakeRange(0, self.attributedText.length), options: NSAttributedStringEnumerationOptions.init(rawValue: 0)) { (attrs, range, stop) -> Void in
                //如果是图片表情
                if let attch = attrs["NSAttachment"] as? EmotionAttachment{//图片
                    text.appendString(attch.emotion!.chs!)
                }else{//emoji，普通文本
                    //获得这个范围内的文字
                    let str = self.attributedText.attributedSubstringFromRange(range)
                    text.appendString(str.string)
                }
            }
            return text as String
        }
    }
    
    
   
    
    func insertEmotion(emotion:Emotion){
        if let code = emotion.code{
            //将文字插入到光标所在的位置
            self.insertText(code.emoji())
        }else if emotion.png != nil{
            //加载图片
            let attch = EmotionAttachment()
            //传递模型
            attch.emotion = emotion
            
            //设置图片的尺寸
            let attchWH = self.font!.lineHeight
            attch.bounds = CGRectMake(0, -4, attchWH, attchWH)
            
            //根据附件创建一个属性文字
            let imageStr = NSAttributedString(attachment: attch)
            
            //插入属性文字到光标位置
            self.insertAttributedText(imageStr, settingBlock: { (settingBlock) -> Void in
                //设置字体
                settingBlock.addAttribute(NSFontAttributeName, value: self.font!, range: NSMakeRange(0, settingBlock.length))
            })
        }
    }
    
    
    /**
    selectedRange :
    1.本来是用来控制textView的文字选中范围
    2.如果selectedRange.length为0，selectedRange.location就是textView的光标位置
    
    关于textView文字的字体
    1.如果是普通文字（text），文字大小由textView.font控制
    2.如果是属性文字（attributedText），文字大小不受textView.font控制，应该利用NSMutableAttributedString的- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;方法设置字体
    **/
}
