//
//  EmotiontabBarButton.swift
//  新浪微博
//
//

import UIKit

class EmotiontabBarButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        //设置文字颜色
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.setTitleColor(UIColor.darkGrayColor(), forState: .Disabled)
        //设置字体
        self.titleLabel?.font = UIFont.systemFontOfSize(13)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
