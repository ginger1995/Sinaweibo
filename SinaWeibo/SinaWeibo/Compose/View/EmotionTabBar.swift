//
//  EmotionTabBar.swift
//  新浪微博
//
//

import UIKit

enum EmotionTabBarButtonType:Int{
    case Recent = 1 //最近
    case Default //默认
    case Emoji //emoji
    case Lxh //浪小花
}

protocol EmotionTabBarDelegate:class{
    func emotionTabBar(tabBar:EmotionTabBar,buttonType:EmotionTabBarButtonType)
}

class EmotionTabBar: UIView {
    
    weak var delegate:EmotionTabBarDelegate?{
        didSet{
            //选中默认按钮
            self.btnClick(self.viewWithTag(EmotionTabBarButtonType.Default.rawValue) as! EmotiontabBarButton)
        }
    }
    private var selectedBtn:EmotiontabBarButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBtn("最近", buttonType: .Recent)
        setupBtn("默认", buttonType: .Default)
        setupBtn("Emoji", buttonType: .Emoji)
        setupBtn("浪小花", buttonType: .Lxh)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    *  创建一个按钮
    *
    *  param title 按钮文字
    */
    func setupBtn(title:String,buttonType:EmotionTabBarButtonType) -> EmotiontabBarButton{
        //创建按钮
        let btn = EmotiontabBarButton()
        btn.addTarget(self, action: #selector(EmotionTabBar.btnClick(_:)), forControlEvents: .TouchDown)
        btn.tag = buttonType.rawValue
        btn.setTitle(title, forState: .Normal)
        self.addSubview(btn)
        //设置背景图片
        var image = "compose_emotion_table_mid_normal"
        var selectImage = "compose_emotion_table_mid_selected"
        if self.subviews.count == 1{
            image = "compose_emotion_table_left_normal"
            selectImage = "compose_emotion_table_left_selected"
        }else if self.subviews.count == 4{
            image = "compose_emotion_table_right_normal"
            selectImage = "compose_emotion_table_right_selected"
        }
        btn.setBackgroundImage(UIImage(named: image), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: selectImage), forState: .Disabled)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置按钮的frame
        let btnCount = self.subviews.count
        let btnW = self.width / CGFloat(btnCount)
        let btnH = self.height
        for i in 0 ..< btnCount {
            let btn = self.subviews[i] as! EmotiontabBarButton
            btn.y = 0
            btn.width = btnW
            btn.x = CGFloat(i) * btnW
            btn.height = btnH
        }
    }
    
    /**
    *  按钮点击
    */
    func btnClick(sender:EmotiontabBarButton){
        selectedBtn?.enabled = true
        sender.enabled = false
        selectedBtn = sender
        
        self.delegate?.emotionTabBar(self, buttonType: EmotionTabBarButtonType.init(rawValue: sender.tag)!)
    }
}
