//
//  EmotionPopView.swift
//  新浪微博
//
//

import UIKit

class EmotionPopView: UIView {

    var emotionButton:EmotionButton?
    
    class func popView() -> EmotionPopView{
        return NSBundle.mainBundle().loadNibNamed("EmotionPopView", owner: nil, options: nil).last as! EmotionPopView
    }
    
    func showFrom(btn:EmotionButton?){
        if btn == nil {
            return
        }
        
        //给popView传递数据
        self.emotionButton?.emotion = btn!.emotion
        
        //取得上面的window
        let window = UIApplication.sharedApplication().windows.last
        window?.addSubview(self)
        
        //计算出被点击的按钮在window的frame
        let btnFrame = btn!.convertRect(btn!.bounds, toView: nil)
        self.y = CGRectGetMinY(btnFrame) - self.height
        self.centerX = CGRectGetMidX(btnFrame)
    }

}
