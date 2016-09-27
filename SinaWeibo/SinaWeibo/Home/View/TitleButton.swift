//
//  TitleButton.swift
//  新浪微博
//
//  标题
//

import UIKit

class TitleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        
        
        self.setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        self.setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        self.adjustsImageWhenHighlighted = false
    }
    
    struct Title {
        static let Margin:CGFloat = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 如果仅仅是调整按钮内部titleLabel和imageView的位置，那么在layoutSubviews中单独设置位置即可
        //计算titleLabel的frame
        self.titleLabel?.x = self.imageView!.x
        //计算imageView的frame
        self.imageView?.x = CGRectGetMaxX(self.titleLabel!.frame) + Title.Margin
    }
    
    override func setTitle(title: String?, forState state: UIControlState) {
        super.setTitle(title, forState: state)
        //只要修改了文字，就让按钮重新计算自己的尺寸
        self.sizeToFit()
    }
    
    override func setImage(image: UIImage?, forState state: UIControlState) {
        super.setImage(image, forState: state)
        //只要修改了图片，就让按钮重新计算自己的尺寸
        self.sizeToFit()
    }
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   

}
