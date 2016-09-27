//
//  BigIconView.swift
//  SinaWeibo
//
//

import UIKit

class BigIconView: HeadView {
    
    override var user: User?{
        didSet{
            //下载图片
            let url = NSURL(string: user!.avatar_large!)
            self.kf_setImageWithURL(url!, placeholderImage: UIImage(named: "avatar_default_small"))
            setSign(user!)
        }
    }
}
