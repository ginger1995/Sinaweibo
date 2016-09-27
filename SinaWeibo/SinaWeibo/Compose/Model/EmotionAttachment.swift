//
//  EmotionAttachment.swift
//  新浪微博
//
//  
//

import UIKit

class EmotionAttachment: NSTextAttachment {
    var emotion:Emotion?{
        didSet{
            self.image = UIImage(named: self.emotion!.png!)
        }
    }
}
