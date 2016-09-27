//
//  StatusTextView.swift
//  新浪微博
//
//  状态富文本
//

import UIKit

class StatusTextView: UITextView {
    /** 所有的特殊字符串(里面存放着Special) */
    var specials:NSArray?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    private func setUI(){
        self.backgroundColor = UIColor.clearColor()
        self.editable = false
        self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5)
        // 禁止滚动, 让文字完全显示出来
        self.scrollEnabled = false
        // self.font = StatusCellFont.ContentFont
    }
    
    //初始化矩形框
    func setupSpecialRects(){
    
        let specials = self.attributedText.attribute("specials", atIndex: 0, effectiveRange: nil) as! [Special]
        for special in specials {
            self.selectedRange = special.range!
            // self.selectedRange --影响--> self.selectedTextRange
            // 获得选中范围的矩形框
            let selectionRects = self.selectionRectsForRange(self.selectedTextRange!)
             // 清空选中范围
            self.selectedRange = NSMakeRange(0, 0)
            
            var rects = [CGRect]()
            for selectionRect in selectionRects {
                let rect = selectionRect.rect
                if rect.size.width == 0 || rect.size.height == 0 {continue}
                //添加rect
                rects.append(rect)
            }
            special.rects = rects
        }
    }
    
    /**
     找出被触摸的特殊字符串
     */
    func touchingSpecialWithPoint(point:CGPoint) -> Special?{
        
        let specials = self.attributedText.attribute("specials", atIndex: 0, effectiveRange: nil) as! [Special]
        
        for special in specials{
            for rect in special.rects!{
                if CGRectContainsPoint(rect, point){// 点中了某个特殊字符串

                    return special
                }
            }
        }
        return nil
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //触摸对象
        let touch = (touches as NSSet).anyObject
        //触摸点
        let point  = touch()?.locationInView(self)
        // 初始化矩形框
       setupSpecialRects()
        // 根据触摸点获得被触摸的特殊字符串
        let special = touchingSpecialWithPoint(point!)
        // 在被触摸的特殊字符串后面显示一段高亮的背景
        for rect in special!.rects!{
            // 在被触摸的特殊字符串后面显示一段高亮的背景
            let cover = UIView()
            cover.backgroundColor = UIColor.greenColor()
            cover.frame = rect
            cover.tag = Cover.tag
            cover.layer.cornerRadius = 5
            self.insertSubview(cover, atIndex: 0)
        }
        
    }
    
    // 在被触摸的特殊字符串后面显示一段高亮的背景
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3*Double(NSEC_PER_MSEC))), dispatch_get_main_queue()) { () -> Void in
            self.touchesCancelled(touches, withEvent: event)
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        // 去掉特殊字符串后面的高亮背景
        for item in self.subviews{
            if item.tag == Cover.tag{
                item.removeFromSuperview()
            }
        }
    }
    /**
     告诉系统:触摸点point是否在这个UI控件身上
     */
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        //初始化矩形框
        setupSpecialRects()
        // 根据触摸点获得被触摸的特殊字符串
        let special = touchingSpecialWithPoint(point)
        if special != nil {
            return true
        }else{
            return false
        }
    }
    
    
    struct Cover {
        static let tag = 999
    }
    
    
    // 触摸事件的处理
    // 1.判断触摸点在谁身上: 调用所有UI控件的- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
    // 2.pointInside返回YES的控件就是触摸点所在的UI控件
    // 3.由触摸点所在的UI控件选出处理事件的UI控件: 调用- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
}
