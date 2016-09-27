//
//  StatusToolBar.swift
//  新浪微博
//
//  状态摩评论转发工具栏
//

import UIKit

class StatusToolBar: UIView {

    /** 里面存放所有的按钮 */
    private var btns:[UIButton] = [UIButton]()
     
    /** 里面存放所有的分割线 */
    private var dividers:[UIImageView] = [UIImageView]()
    
    //转发按钮
    private var repostBtn:UIButton?
    //评论按钮
    private var commentBtn:UIButton?
    //赞按钮
    private var attituBtn:UIButton?
    
    var status:Status?{
        didSet{
            guard status != nil else{return}
            //转发
            var zf = "转发"
            self.repostBtn?.setupBtnCount(self.status?.reposts_count, title: &zf)
            var pl = "评论"
            self.commentBtn?.setupBtnCount(self.status?.comments_count, title: &pl)
            var zan = "赞"
            self.attituBtn?.setupBtnCount(self.status?.attitudes_count, title: &zan)
        }
    }
    
    class func toolbar() -> StatusToolBar{
        return StatusToolBar()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(patternImage: UIImage(named: "timeline_card_bottom_background")!)
        
        //添加按钮
        self.repostBtn = setupBtn("转发", icon: "timeline_icon_retweet")
        self.repostBtn?.addTarget(self, action: #selector(StatusToolBar.RepostClick), forControlEvents: .TouchUpInside)
        self.commentBtn = setupBtn("评论", icon: "timeline_icon_comment")
        self.commentBtn?.addTarget(self, action: #selector(StatusToolBar.CommentClick), forControlEvents: .TouchUpInside)
        self.attituBtn = setupBtn("赞", icon: "timeline_icon_unlike")
        self.attituBtn?.addTarget(self, action: #selector(StatusToolBar.PraiseClick), forControlEvents: .TouchUpInside)
        //添加分割线
        setupDivider()
        setupDivider()
    }
    
    //MARK: - 转发评论赞通知
    //转发
    func RepostClick(){
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.StatusDidRepostNotification, object: nil, userInfo: [Notification.StatusToolBarRow:status!.id!])    }
    
    func CommentClick(){
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.StatusDidCommentNotification, object: nil, userInfo: [Notification.StatusToolBarRow:status!.id!])
    }
    
    func PraiseClick(){
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.StatusDidPraiseNotification, object: nil, userInfo: [Notification.StatusToolBarRow:status!.id!])
    }
    
    
    /**
    * 添加分割线
    */
    private func setupDivider(){
        let divider = UIImageView()
        divider.image = UIImage(named: "timeline_card_bottom_line")
        self.addSubview(divider)
        dividers.append(divider)
    }
    
    /**
    * 初始化一个按钮
    * param title : 按钮文字
    * param icon : 按钮图标
    */
    private func setupBtn(title:String,icon:String) -> UIButton{
        let btn = UIButton()
        btn.setImage(UIImage(named: icon), forState: .Normal)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        btn.setTitle(title, forState: .Normal)
        btn.setTitleColor(UIColor.grayColor(), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background_highlighted"), forState: .Highlighted)
        self.addSubview(btn)
        self.btns.append(btn)
        return btn
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置按钮的frame
        let btnCount = self.btns.count
        let btnW = self.width / CGFloat(btnCount)
        let btnH = self.height
        for i in 0 ..< btnCount {
            let btn = self.btns[i]
            btn.y = 0
            btn.width = btnW
            btn.x = CGFloat(i) * btnW
            btn.height = btnH
        }
        
        //设置分割线的frame
        let dividerCount = self.dividers.count
        for i in 0 ..< dividerCount {
            let divider = self.dividers[i]
            divider.width = 1
            divider.height = btnH
            divider.x = CGFloat(i+1) * btnW
            divider.y = 0
        }
    }
    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
