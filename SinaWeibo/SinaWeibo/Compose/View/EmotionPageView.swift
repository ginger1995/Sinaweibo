//
//  EmotionPageView.swift
//  新浪微博
//
//

import UIKit

class EmotionPageView: UIView {
    
    private var notificationCenter:NSNotificationCenter {
        get{return NSNotificationCenter.defaultCenter()}
    }
    
    /** 点击表情后弹出的放大镜 */
    private lazy var popView:EmotionPopView = {
        return EmotionPopView.popView()
    }()
    
    /** 删除按钮 */
    var deleteBtn:UIButton!
    
    /** 这一页显示的表情（里面都是HWEmotion模型） */
    var emotions:NSArray?{
        didSet{
            let count = emotions!.count
            for i in 0 ..< count {
                let btn = EmotionButton()
                self.addSubview(btn)
                //设置表情数据
                btn.emotion = emotions![i] as? Emotion
                btn.addTarget(self, action: #selector(EmotionPageView.btnClick(_:)), forControlEvents: .TouchUpInside)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //删除按钮
        deleteBtn = UIButton()
        deleteBtn.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: .Highlighted)
        deleteBtn.setImage(UIImage(named: "compose_emotion_delete"), forState: .Normal)
        deleteBtn.addTarget(self, action: #selector(EmotionPageView.deleClick), forControlEvents: .TouchUpInside)
        self.addSubview(deleteBtn)
        //添加长按手势
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(EmotionPageView.longPressPageView(_:))))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //内边距
        let inset:CGFloat = 20
        let count = self.emotions!.count
        let btnW = (self.width - 2 * inset) / CGFloat(EmotionList.EmotionMaxCols)
        let btnH = (self.height - inset) / CGFloat(EmotionList.EmotionMaxRows)
        for i in 0 ..< count {
            let btn = self.subviews[i+1] as! UIButton
            btn.width = btnW
            btn.height = btnH
            btn.x = inset + CGFloat(i % EmotionList.EmotionMaxCols) * btnW
            btn.y = (inset - 10) + CGFloat(i / EmotionList.EmotionMaxCols) * btnH
        }
        //删除按钮
        deleteBtn.width = btnW
        deleteBtn.height = btnH
        deleteBtn.y = self.height - btnH
        deleteBtn.x = self.width - inset - btnW
    }
    
    
    /**
    *  在这个方法中处理长按手势
    */
    func longPressPageView(recoginzer:UILongPressGestureRecognizer){
        let location = recoginzer.locationInView(recoginzer.view)
         // 获得手指所在的位置\所在的表情按钮
        let btn = emotionButton(location)
        
        switch(recoginzer.state){
        case .Cancelled:
            //移除popView
            removePopView(btn)
            break
        case .Ended: // 手指已经不再触摸pageView
            //移除popView
            removePopView(btn)
            break
        case .Began:// 手势开始（刚检测到长按）
            self.popView.showFrom(btn) // 手势改变（手指的位置改变）
        case .Changed:
            self.popView.showFrom(btn) // 手势改变（手指的位置改变）

            break
        default:
            break
        }
    }
    
    func removePopView(btn:EmotionButton?){
        //移除popView
        self.popView.removeFromSuperview()
        //如果手指还在表情按钮上
        if (btn != nil){
            //发出通知
            selectEmotion(btn!.emotion!)
        }
    }
    
    
    /**
    *  根据手指位置所在的表情按钮
    */
    func emotionButton(location:CGPoint) -> EmotionButton?{
        let count = self.emotions!.count
        for i in 0 ..< count {
            let btn = self.subviews[i + 1] as! EmotionButton
            if CGRectContainsPoint(btn.frame, location){
                // 已经找到手指所在的表情按钮了，就没必要再往下遍历
                return btn
            }
        }
        return nil
    }
    
    func selectEmotion(emotion:Emotion){
        //将这个表情存进沙盒
        EmotionTool.addRecentEmotion(emotion)
        //发出通知
        var userInfo = [NSObject:AnyObject]()
        userInfo[Notification.SelectEmotionKey] = emotion
        notificationCenter.postNotificationName(Notification.EmotionDidSelectNotification, object: nil, userInfo: userInfo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    *  监听表情按钮点击
    *
    *  param sender 被点击的表情按钮
    */
    func btnClick(sender:EmotionButton){
        //显示popView
        self.popView.showFrom(sender)
        
        //等会让popView自动消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.25 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.popView.removeFromSuperview()
        }
        
        //发出通知
        self.selectEmotion(sender.emotion!)
    }
    
    func deleClick(){
        notificationCenter.postNotificationName(Notification.EmotionDidDeleteNotification, object: nil)
    }
    
}
