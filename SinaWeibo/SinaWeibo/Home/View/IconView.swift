//
//  IconView.swift
//  SinaWeibo
//
//

import UIKit

class IconView: HeadView {

   override var user:User?{
        didSet{
            
            //下载图片
            let url = NSURL(string: user!.profile_image_url!)
            self.kf_setImageWithURL(url!, placeholderImage: UIImage(named: "avatar_default_small"))
            setSign(user!)
        }
    }

}
