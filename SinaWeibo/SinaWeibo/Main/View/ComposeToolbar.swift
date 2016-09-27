//
//  ComposeToolbar.swift
//  新浪微博
//
//  发表工具栏
//

import UIKit

protocol ComposeToolbarDelegate:class{
    func composeToolbar(toolbar:ComposeToolbar,buttonType:ComposeToolBarButtonType)
}
enum ComposeToolBarButtonType:Int{
    case Camera = 1//拍照
    case Picture//相册
    case Mention // @
    case Trend //#
    case Emotion//表情
}
class ComposeToolbar: UIView {
    
    
    weak var delegate:ComposeToolbarDelegate?
    /** 是否要显示键盘按钮  */
    var showKeyboardButton:Bool = false {
        didSet{
            //默认的图片名
            var image = "compose_emoticonbutton_background"
            var highImage = "compose_emoticonbutton_background_highlighted"
            //显示键盘图标
            if self.showKeyboardButton{
                image = "compose_keyboardbutton_background"
                highImage = "compose_keyboardbutton_background_highlighted"
            }
            
            //设置图片
            self.emotionButton?.setImage(UIImage(named: image), forState: .Normal)
            self.emotionButton?.setImage(UIImage(named: highImage), forState: .Highlighted)
        }
    }
    
    init(){
        super.init(frame: CGRectZero)
        setBtns(true, picture: true, trend: true)
    }
    
    init(camra:Bool,picture:Bool,trend:Bool){
        super.init(frame: CGRectZero)
        setBtns(camra, picture: picture, trend: trend)
    }
    
    private func setBtns(camra:Bool,picture:Bool,trend:Bool){
        self.backgroundColor = UIColor(patternImage: UIImage(named: "compose_toolbar_background")!)
        //初始化按钮
        if camra{
            setupBtn("compose_camerabutton_background", highImage: "compose_camerabutton_background_highlighted", type: .Camera)
        }
        if picture{
            setupBtn("compose_toolbar_picture", highImage: "compose_toolbar_picture_highlighted", type: .Picture)
        }
        if trend{
            setupBtn("compose_trendbutton_background", highImage: "compose_trendbutton_background_highlighted", type: .Trend)
        }
        
        setupBtn("compose_mentionbutton_background", highImage: "compose_mentionbutton_background_highlighted", type: .Mention)
        emotionButton = setupBtn("compose_emoticonbutton_background", highImage: "compose_emoticonbutton_background_highlighted", type: .Emotion)
    }
    
    private var emotionButton:UIButton?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置所有按钮的frame
        let count = 5
        let btnW = self.width / CGFloat(count)
        let btnH = self.height
        for i in 0 ..< self.subviews.count {
            let btn = self.subviews[i] as! UIButton
            btn.y = 0
            btn.width = btnW
            btn.x = CGFloat(i) * btnW
            btn.height = btnH
        }
    }
    
    /**
    * 创建一个按钮
    */
    func setupBtn(image:String,highImage:String,type:ComposeToolBarButtonType) -> UIButton{
        let btn = UIButton()
        btn.setImage(UIImage(named: image), forState: .Normal)
        btn.setImage(UIImage(named: highImage), forState: .Highlighted)
        btn.addTarget(self, action: #selector(ComposeToolbar.btnClick(_:)), forControlEvents: .TouchUpInside)
        btn.tag = type.rawValue
        self.addSubview(btn)
        return btn
    }
    
    //监听按钮
    func btnClick(sender:UIButton){
        delegate?.composeToolbar(self, buttonType: ComposeToolBarButtonType.init(rawValue: sender.tag)!)
    }
    
}
