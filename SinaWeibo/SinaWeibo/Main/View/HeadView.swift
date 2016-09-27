//
//  IconView.swift
//  新浪微博
//
//  用户认证图标
//

import UIKit
import Kingfisher

class HeadView: UIImageView {
    
    var user:User?
    
    lazy var verifiedView:UIImageView = {
        let imageView = UIImageView()
        self.addSubview(imageView)
        return imageView
    }()
    
    
    init(){
        super.init(frame: CGRectZero)
        //添加手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HeadView.handleTapGesture))
        self.addGestureRecognizer(tapGesture)
        self.userInteractionEnabled = true // 开启交互
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func handleTapGesture(){
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.StatusDidHeaderClickNotification, object: nil, userInfo: [Notification.StatusHeaderUID:user!.idstr!])
    }
   
    
    func setSign(user:User){
        //设置加V图片
        switch user.verufued_type {
        case .Personal: //个认证
            self.verifiedView.hidden = false
            self.verifiedView.image = UIImage(named: "avatar_vip")
            break
        case .OrgEnterprice:
            setupOrg()
            break
        case .OrgMedia:
            setupOrg()
            break
        case .OrgWebsite: //官方认证
            setupOrg()
            break
        case .Daren: //微博达人
            self.verifiedView.hidden = false
            self.verifiedView.image = UIImage(named: "avatar_grassroot")
            break
        default:
            self.verifiedView.hidden = true //没有认证
            self.verifiedView.image = UIImage(named: "avatar_enterprise_vip")
            break
        }
    }
    
    func setupOrg(){
        self.verifiedView.hidden = false
        self.verifiedView.image = UIImage(named: "avatar_enterprise_vip")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard self.verifiedView.image != nil else{return}
        self.verifiedView.size = self.verifiedView.image!.size
        let scale:CGFloat = 0.6
        self.verifiedView.x = self.width - self.verifiedView.width * scale
        self.verifiedView.y = self.height - self.verifiedView.height * scale
    }

}
