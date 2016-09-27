//
//  StatusCell.swift
//  新浪微博
//
//  状态Cell


import UIKit

//协议和方法最好以statusCell开头，方便快速搜索
@objc protocol StatusCellDelegate:class {
    
    optional func statusCellDidFavorityClick(favorite:Favorite,selected:Bool)
    optional func statusCelldidMoreClick(status:Status)
}


class StatusCell: UITableViewCell {
    
    weak var delegate:StatusCellDelegate?
    
    /** 更多按钮 **/
    private var moreBtn:UIButton?
    /** 收藏按钮 **/
    private var favoriteBtn:UIButton?
    /* 原创微博 */
    /** 原创微博整体 */
    private var originalView:UIView?
    /** 头像 */
    private var iconView:IconView?
    /** 会员图标 */
    private var vipView:UIImageView?
    /** 配图 */
    private var photosView:StatusPhotosView?
    /** 昵称 */
    private var nameLabel:UILabel?
    /** 时间 */
    private var timeLabel:UILabel?
    /** 来源 */
    private var sourceLabel:UILabel?
    /** 正文 */
    private var contentLabel:StatusTextView?
    
    /* 转发微博 */
    /** 转发微博整体 */
    private var retweetView:UIView?
    /** 转发微博正文 + 昵称 */
    private var retweetContentLabel:StatusTextView?
    /** 转发配图 */
    private var retweetPhotosView:StatusPhotosView?
    
    /** 工具条 */
    private var toolbar:StatusToolBar?

    
    var object:AnyObject?{
        didSet{
            updateUI()
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.color(64,224,208)
        //点击的时候不变色
        self.selectionStyle = .None
        
        //设置选中时的背景为蓝色
        //let bg = UIView()
       // bg.backgroundColor = UIColor.blueColor()
        //self.selectedBackgroundView = bg
    
        //初始化原创微博
        setupOriginal()
        
        //初始化转发微博
        setupReweet()
        
        //初始化工具条
        setupToobar()
        
        //初始化收藏按钮
        setupFavorite()
        
        //初始化更多按钮
        setupMore()
    }
    
    /**
     * 初始化更多按钮
     */
    private func setupMore(){
        moreBtn = UIButton()
        moreBtn?.addTarget(self, action: #selector(StatusCell.moreClick(_:)), forControlEvents: .TouchUpInside)
        moreBtn?.setImage(UIImage(named: "timeline_icon_more"), forState: .Normal)
        moreBtn?.hidden = true
        self.originalView?.addSubview(moreBtn!)
    }
    
    //点击更多
    internal func moreClick(sender:UIButton){
        let statusFrame = object as? StatusFrame
        let status = statusFrame?.status
        delegate?.statusCelldidMoreClick?(status!)
    }
    
    /**
     * 初始化收藏按钮
     */
    private func setupFavorite(){
        favoriteBtn = UIButton()
        favoriteBtn?.addTarget(self, action: #selector(StatusCell.favoriteClick(_:)), forControlEvents: .TouchUpInside)
        favoriteBtn?.setImage(UIImage(named: "start_normal"), forState: .Normal)
        favoriteBtn?.setImage(UIImage(named: "start_selected"), forState: .Selected)
        favoriteBtn?.hidden = true
        self.originalView?.addSubview(favoriteBtn!)
    }
    
    //点击收藏
    internal func favoriteClick(sender:UIButton){
        sender.selected = !sender.selected
        
        let favorite = object as! Favorite
        delegate?.statusCellDidFavorityClick?(favorite, selected: sender.selected)
    }
    
    /**
    * 初始化工具条
    */
    private func setupToobar(){
        toolbar = StatusToolBar.toolbar()
        self.contentView.addSubview(toolbar!)
    }
    
    /**
    * 初始化转发微博
    */
    private func setupReweet(){
        /** 转发微博整体 */
        retweetView = UIView()
        retweetView?.backgroundColor = UIColor.color(176,224,230)
        self.contentView.addSubview(retweetView!)
        
        /** 转发微博正文 + 昵称 */
        retweetContentLabel = StatusTextView()
        retweetContentLabel?.font = StatusCellFont.ContentFont
        retweetView?.addSubview(retweetContentLabel!)
        
        /** 转发微博配图 */
        retweetPhotosView = StatusPhotosView()
        retweetView?.addSubview(retweetPhotosView!)
    }
    
    //初始化原创微博
    private func setupOriginal(){
        /** 原创微博整体 */
        originalView = UIView()
        originalView?.backgroundColor = UIColor.color(220,255,255)
        self.contentView.addSubview(originalView!)
        
        /** 头像*/
        iconView = IconView()
        originalView?.addSubview(iconView!)
        
        /**会员图标*/
        vipView = UIImageView()
        vipView?.contentMode = .Center
        originalView?.addSubview(vipView!)
        
        /**配图*/
        photosView = StatusPhotosView()
        originalView?.addSubview(photosView!)
        
        /** 昵称 */
        nameLabel = UILabel()
        nameLabel?.font = StatusCellFont.NameFont
        originalView?.addSubview(nameLabel!)
        
        /**时间*/
        timeLabel = UILabel()
        timeLabel?.textColor = UIColor.color(34,139,34)
        timeLabel?.font = StatusCellFont.TimeFont
        originalView?.addSubview(timeLabel!)
        
        /**来源*/
        sourceLabel = UILabel()
        sourceLabel?.textColor = UIColor.color(34,139,34)
        sourceLabel?.font = StatusCellFont.SourceFont
        originalView?.addSubview(sourceLabel!)
        
        /**正文*/
        contentLabel = StatusTextView()
        contentLabel?.font = StatusCellFont.ContentFont
        originalView?.addSubview(contentLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private struct HomeStatus {
        static let CellID = "status"
    }
    
    class func cellWithTableView(tableView:UITableView,delegate:StatusCellDelegate?=nil) -> StatusCell{
        var cell = tableView.dequeueReusableCellWithIdentifier(HomeStatus.CellID) as? StatusCell
        if cell == nil {
            cell = StatusCell(style: .Subtitle, reuseIdentifier: HomeStatus.CellID)
            cell?.delegate = delegate
        }
        return cell!
    }
    
    /**
    * 更新视图
    */
    private func updateUI(){
        guard object != nil else{return}
        
        var statusFrame:StatusFrame? = nil
        
        if object!.isKindOfClass(StatusFrame){
            //是StatusFrame类
            statusFrame = object as? StatusFrame
            moreBtn?.hidden = false
            favoriteBtn?.hidden = true
            
        }else if object!.isKindOfClass(Favorite){
            //是Favorite类
            let favorite = object as? Favorite
            statusFrame = favorite?.statusFrame
            favoriteBtn?.hidden = false
            moreBtn?.hidden = true
            
        }else{
            return
        }
        
        
        let status = statusFrame?.status
        
        let user = status?.user
        
        /** 收藏 **/
        if status!.favorited! {
            favoriteBtn?.selected = true
        }
        
        
        /** 原创微博整体 */
        originalView?.frame = statusFrame!.originalViewF!
        /** 头像 */
        iconView?.frame = statusFrame!.iconViewF!
        iconView?.user = user
        
        /** 更多 **/
        moreBtn?.frame = statusFrame!.moreBtnF!
        
        /** 收藏 **/
        favoriteBtn?.frame = statusFrame!.favoriteF!
        
        /** 会员图标 */
        if user!.vip {
            vipView?.hidden = false
            self.vipView?.frame = statusFrame!.vipViewF!
            
            let vipName = String(format: "common_icon_membership_level%d", arguments: [user!.mbrank!])
            vipView?.image = UIImage(named: vipName)
            
            nameLabel?.textColor = UIColor.orangeColor()
        }else{
            nameLabel?.textColor = UIColor.blackColor()
            vipView?.hidden = true
        }
        
        /** 配图 */
        if let pic_urls = status?.pic_urls{
            if pic_urls.count > 0{
                photosView?.frame = statusFrame!.photosViewF!
                photosView?.status = status
                photosView?.hidden = false
            }else{
                photosView?.hidden = true
            }
        }else{
            photosView?.hidden = true
        }
        
        /** 昵称 */
        nameLabel?.text = user!.name
        nameLabel?.frame = statusFrame!.nameLabelF!
        
        /** 时间 */
        let time = status?.created_at
        let timeX = statusFrame!.nameLabelF!.origin.x
        let timeY = CGRectGetMaxY(statusFrame!.nameLabelF!) + StatusCellSize.BorderW
        let timeSize = time!.size(StatusCellFont.TimeFont)
        timeLabel?.frame = CGRect(origin: CGPoint(x: timeX,y: timeY), size: timeSize)
        timeLabel?.text = time!
        
        /** 来源 */
        let sourceX = CGRectGetMaxX(timeLabel!.frame) + StatusCellSize.BorderW
        let sourceY = timeY
        let sourceSize = status!.source!.size(StatusCellFont.SourceFont)
        sourceLabel?.frame = CGRect(origin: CGPoint(x: sourceX, y: sourceY), size: sourceSize)
        sourceLabel?.text = status!.source!
        
        /** 正文 */
        contentLabel?.attributedText = status!.attributedText
        contentLabel?.frame = statusFrame!.contentLabelF!
        
        /** 被转发的微博 */
        if let retweeted_status = status?.retweeted_status{
            retweetView?.hidden = false
            /** 被转发的微博整体 */
            retweetView?.frame = statusFrame!.retweetViewF!
            
            /** 被转发的微博正文 */
            retweetContentLabel?.attributedText = status!.retweetedAttributedText
            retweetContentLabel?.frame = statusFrame!.retweetContentLabelF!
            
            /** 被转发的微博配图 */
            if let pic_urls = retweeted_status.pic_urls {
                if pic_urls.count > 0{
                    retweetPhotosView?.frame = statusFrame!.retweetPhotosViewF!
                    retweetPhotosView?.status = retweeted_status
                    self.retweetPhotosView?.hidden = false
                }else{
                    retweetPhotosView?.hidden = true
                }
            }else{
                retweetPhotosView?.hidden = true
            }
            
        }else{
            retweetView?.hidden = true
        }
        
        /** 工具条 */
        toolbar?.frame = statusFrame!.toolbarF!
        toolbar?.status = status
    }

    

}
