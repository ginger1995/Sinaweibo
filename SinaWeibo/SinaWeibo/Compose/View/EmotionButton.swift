

//
//  EmotionButton.swift
//  新浪微博
//
//

import UIKit

class EmotionButton: UIButton {

    var emotion:Emotion?{
        didSet{
//            let a =  CGFloat(Int(arc4random_uniform(254)) + 1)
//            self.backgroundColor = UIColor.color(a, a, a)
            if let png = emotion?.png{ //有图片
                self.setImage(UIImage(named: png), forState: .Normal)
            }else if let code = emotion?.code{// 是emoji表情
                self.setTitle(code.emoji(), forState: .Normal)
            }
        }
    }

    /**
    *  当控件不是从xib、storyboard中创建时，就会调用这个方法
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel?.font = UIFont.systemFontOfSize(32)
    }

 
    
    /**
    *  当控件是从xib、storyboard中创建时，就会调用这个方法
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.titleLabel?.font = UIFont.systemFontOfSize(32)
    }
    
    /**
    *  当控件是从xib、storyboard中创建时，就会调用这个方法
    */
//    init?(coder aDecoder: NSCoder) {
//        
//    }
    
    /**
    *  这个方法在initWithCoder:方法后调用
    */
//    override func awakeFromNib() {
//        
//    }
}
