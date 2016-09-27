//
//  StatusFrame.swift
//  新浪微博
//
//  新浪状态frame模块
//

import UIKit

class StatusFrame: NSObject {

    /** 更多 **/
    var moreBtnF:CGRect?
    /** 收藏 **/
    var favoriteF:CGRect?
    /** 原创微博整体 */
    var originalViewF:CGRect?
    /** 头像 */
    var iconViewF:CGRect?
    /** 会员图标 */
    var vipViewF:CGRect?
    /** 配图 */
    var photosViewF:CGRect?
    /** 昵称 */
    var nameLabelF:CGRect?
    /** 时间 */
    var timeLabelF:CGRect?
    /** 来源 */
    var sourceLabelF:CGRect?
    /** 正文 */
    var contentLabelF:CGRect?
    
    /** 转发微博整体 */
    var retweetViewF:CGRect?
    /** 转发微博正文 + 昵称 */
    var retweetContentLabelF:CGRect?
    /** 转发配图 */
    var retweetPhotosViewF:CGRect?
    
    /** 底部工具条 */
    var toolbarF:CGRect?
    
    /** cell的高度 */
    var cellHeight:CGFloat = 44
    
    
    var status:Status?{
        didSet{
            setFrame()
        }
    }
    
    func setFrame(){
        
        let user = status?.user
        // cell的宽度
        let cellW = UIScreen.mainScreen().bounds.size.width
        
        /** 原创微博 */
        /** 头像 */
        let iconWH:CGFloat = 35
        let iconX = StatusCellSize.BorderW
        let iconY = StatusCellSize.BorderW
        iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH)
        
        /** 更多 **/
        let moreWH:CGFloat = 30
        let moreX = UIScreen.mainScreen().bounds.size.width - moreWH - 16
        let moreY = iconY
        moreBtnF = CGRectMake(moreX, moreY, moreWH, moreWH)
        
        /** 收藏 **/
        let favoriteWH:CGFloat = 30
        let favoriteX = UIScreen.mainScreen().bounds.size.width - favoriteWH - 16
        let favoriteY = iconY
        favoriteF = CGRectMake(favoriteX, favoriteY, favoriteWH, favoriteWH)
        
        /** 昵称 */
        let nameX = CGRectGetMaxX(iconViewF!) + StatusCellSize.BorderW
        let nameY = iconY
        let nameSize = user!.name!.size(StatusCellFont.NameFont)
        nameLabelF = CGRect(origin: CGPoint(x: nameX, y: nameY), size: nameSize)
        
        /** 会员图标 */
        if user!.vip {
            let vipX = CGRectGetMaxX(nameLabelF!) + StatusCellSize.BorderW
            let vipY = nameY
            let vipH = nameSize.height
            let vipW:CGFloat = 14
            vipViewF = CGRectMake(vipX, vipY, vipW, vipH)
        }
        
        /** 时间 */
        let timeX = nameX
        let timeY = CGRectGetMaxY(nameLabelF!) + StatusCellSize.BorderW
        let timeSize = status!.created_at!.size(StatusCellFont.TimeFont)
        timeLabelF =  CGRect(origin: CGPoint(x: timeX, y: timeY), size: timeSize)
        
        /** 来源 */
        let sourceX = CGRectGetMaxX(timeLabelF!) + StatusCellSize.BorderW
        let sourceY = timeY
        let sourceSize = status!.source!.size(StatusCellFont.SourceFont)
        sourceLabelF = CGRect(origin: CGPoint(x: sourceX, y: sourceY), size: sourceSize)
        
        /** 正文 */
        let contentX = iconX
        let contentY = max(CGRectGetMaxY(iconViewF!), CGRectGetMaxY(timeLabelF!)) + StatusCellSize.BorderW
        let maxW = cellW - 2 * contentX
        let contentSize = status?.attributedText?.boundingRectWithSize(CGSizeMake(maxW, CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).size
        contentLabelF = CGRect(origin: CGPoint(x: contentX, y: contentY),size: contentSize!)
        
        /** 配图 */
        var originalH:CGFloat = 0
        if let pic_urls = status?.pic_urls{ //有配图
            if pic_urls.count > 0{
                let photosX = contentX
                let photosY = CGRectGetMaxY(contentLabelF!) + StatusCellSize.BorderW
                let photosSize = StatusPhotosView.sizeWithCount(pic_urls.count)
                photosViewF = CGRect(origin: CGPoint(x: photosX, y: photosY), size: photosSize)
                originalH = CGRectGetMaxY(photosViewF!) + StatusCellSize.BorderW
            }else{
                originalH = CGRectGetMaxY(contentLabelF!) + StatusCellSize.BorderW
            }
        }else{
             originalH = CGRectGetMaxY(contentLabelF!) + StatusCellSize.BorderW
        }
        /** 原创整体 */
        let originalX:CGFloat = 0
        let originalY = StatusCellSize.Margin
        let originalW = cellW
        originalViewF = CGRectMake(originalX, originalY, originalW, originalH)
        var toolbarY:CGFloat = 0
        /** 被转发微博 */
        if let retweeted_status = status?.retweeted_status{
            /** 被转发微博正文 */
            let retweetContentX = StatusCellSize.BorderW
            let retweetContentY = StatusCellSize.BorderW
            let retweetContentSize = status?.retweetedAttributedText?.boundingRectWithSize(CGSizeMake(maxW, CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).size
            self.retweetContentLabelF = CGRect(origin: CGPoint(x: retweetContentX, y: retweetContentY), size: retweetContentSize!)
            
            /** 被转发微博配图 */
            var retweetH:CGFloat = 0
            if let pic_urls = retweeted_status.pic_urls{
                if pic_urls.count > 0{
                    let retweetPhotosX = retweetContentX
                    let retweetPhotosY = CGRectGetMaxY(retweetContentLabelF!) + StatusCellSize.BorderW
                    let retweetPhotosSize = StatusPhotosView.sizeWithCount(pic_urls.count)
                    retweetPhotosViewF = CGRect(origin: CGPoint(x: retweetPhotosX, y: retweetPhotosY), size: retweetPhotosSize)
                    retweetH = CGRectGetMaxY(retweetPhotosViewF!) + StatusCellSize.BorderW
                }else{
                    retweetH = CGRectGetMaxY(retweetContentLabelF!) + StatusCellSize.BorderW
                }
            }else{
                retweetH = CGRectGetMaxY(retweetContentLabelF!) + StatusCellSize.BorderW
            }
            
            /** 被转发微博整体 */
            let retweetX:CGFloat = 0
            let retweetY = CGRectGetMaxY(originalViewF!)
            let retweetW = cellW
            retweetViewF = CGRectMake(retweetX, retweetY, retweetW, retweetH)
            toolbarY = CGRectGetMaxY(retweetViewF!)
        }else {
            toolbarY = CGRectGetMaxY(originalViewF!)
        }
        /** 工具条 */
        let toolbarX:CGFloat = 0
        let toolbarW = cellW
        let toolbarH:CGFloat = 35
        toolbarF = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH)
        
        /** cell的高度 */
        self.cellHeight = CGRectGetMaxY(toolbarF!)
    }
    
    
    /**
    *  将Status模型转为StatusFrame模型
    */
    
    class func statusFramesWithStatuses(statuses:[AnyObject]) -> [StatusFrame]{
        var frames = [StatusFrame]()
        for status in statuses{
            let frame = StatusFrame()
            frame.status = status as? Status
            frames.append(frame)
        }
        return frames
    }
}
