//
//  TextView.swift
//  新浪微博
//
//  扩展文本带placeholder
//

import UIKit

class TextView: UITextView {

    /** 占位文字 */
    var placeholder:String?{
        didSet{
            self.setNeedsDisplay()
        }
    }
    /** 占位文字的颜色 */
    var placeholderColor:UIColor?{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    //重写text属性
    override var text: String!{
        didSet{
            self.setNeedsDisplay()
        }
    }

    override var font:UIFont?{
        didSet{
            self.setNeedsDisplay()
        }
    }

    override var attributedText: NSAttributedString!{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    var notificationCenter:NSNotificationCenter{
        get{return NSNotificationCenter.defaultCenter()}
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        //通知
        // 当UITextView的文字发生改变时，UITextView自己会发出一个UITextViewTextDidChangeNotification通知
        notificationCenter.addObserver(self, selector: #selector(TextView.textDidChange), name: UITextViewTextDidChangeNotification, object: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        //销毁时移除通知中心
        NSLog("销毁")
        notificationCenter.removeObserver(self)
    }
    
    //MARK: - NotificationCenter
    /**
    * 监听文字改变
    */
    func textDidChange(){
        //重绘(重新调用)
        self.setNeedsDisplay()
    }
    
    //MARK: - drawRect
    override func drawRect(rect: CGRect) {
        //如果有输入文字，就直接返回，不画占位文字
        guard !self.hasText() else{return}
        
        //文字属性
        var attrs = [String:AnyObject]()
        attrs[NSFontAttributeName] = self.font
        attrs[NSForegroundColorAttributeName] = self.placeholderColor != nil ? self.placeholderColor!:UIColor.grayColor()
        //画文字
        //    [self.placeholder drawAtPoint:CGPointMake(5, 8) withAttributes:attrs];
        let x:CGFloat = 5
        let w = rect.size.width - 2 * x
        let y:CGFloat = 8
        let h = rect.size.height - 2 * y
        let placeholderRect = CGRectMake(x, y, w, h)
        (placeholder! as NSString).drawInRect(placeholderRect, withAttributes: attrs)
    }
  
}
