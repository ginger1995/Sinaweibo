//
//  SinaWeiboStatic.swift
//  SinaWeibo
//
//  
//

import Foundation

struct XLMess {
    //授权
    static let OAuthUrl = "https://api.weibo.com/oauth2/access_token"
    
    static let Client_id = "1461153647"
    static let Client_secret = "7e19c6f998fafb1a957d3ad3925ef9ec"
    
    static let Qrant_type = "authorization_code"
    static let Redirect_uri = "http://www.baidu.com"
    
    //未读微博
    static let Home_Unread_Url = "https://rm.api.weibo.com/2/remind/unread_count.json"
    //获取当前登录用户及其所关注用户的最新微博
    static let Home_Friends_Timeline_Url = "https://api.weibo.com/2/statuses/friends_timeline.json"
    //获得用户信息
    static let Home_Show_Url = "https://api.weibo.com/2/users/show.json"
    
    //获取单条微博
    static let Single_SingleStatus_Url = "https://api.weibo.com/2/statuses/show.json"
    //获取评论
    static let Single_Comment_Url = "https://api.weibo.com/2/comments/show.json"
    //评论微博
    static let Status_Comment_Url = "https://api.weibo.com/2/comments/create.json"
    //转发微博
    static let Status_Repost_Url = "https://api.weibo.com/2/statuses/repost.json"
    
    //根据用户ID获取用户信息
    static let User_Show_Url = "https://api.weibo.com/2/users/show.json"
    //收藏列表
    static let User_Favorites_Url = "https://api.weibo.com/2/favorites.json"
    //添加收藏
    static let User_AddFavority_Url = "https://api.weibo.com/2/favorites/create.json"
    //删除收藏
    static let User_DeleteFavority_Url = "https://api.weibo.com/2/favorites/destroy.json"
    //批量删除收藏
    static let User_DeleteFavorites_Url = "https://api.weibo.com/2/favorites/destroy_batch.json"
    //获取用户的关注列表
    static let User_Friends_Url = "https://api.weibo.com/2/friendships/friends.json"
    //取消关注
    static let User_DeleteFollowing_Url = "https://api.weibo.com/2/friendships/destroy.json"
    //关注用户
    static let User_Following_Url = "https://api.weibo.com/2/friendships/create.json"
    //获取某个用户的各种消息未读数
    static let User_Unread_Count_Url = "https://rm.api.weibo.com/2/remind/unread_count.json"
    //对当前登录用户某一种消息未读数进行清零
    static let User_ClearUnread_Count_Url = "https://rm.api.weibo.com/2/remind/set_count.json"
    
    //发布文本微博
    static let Compose_Update_Url = "https://api.weibo.com/2/statuses/update.json"
    //发布带图片微博
    static let Compose_Update_Image_Url = "https://upload.api.weibo.com/2/statuses/upload.json"
    //获取某个用户最新发表的微博列表
    static let Person_Status_Url = "https://api.weibo.com/2/statuses/user_timeline.json"
    //获取用户的粉丝列表
    static let Person_Follower_Url = "https://api.weibo.com/2/friendships/followers.json"
    
    static let Discover_PlaceStatus_Url = "https://api.weibo.com/2/place/nearby_timeline.json"
    
    
}


struct StatusCellSize {
    static let BorderW:CGFloat = 10
    static let Margin:CGFloat = 15
}

struct StatusCellFont{
    static let TimeFont = UIFont.systemFontOfSize(13)
    static let SourceFont = TimeFont
    static let NameFont = UIFont.systemFontOfSize(16)
    static let ContentFont = UIFont.systemFontOfSize(15)
}

struct Notification {
    //表情选中通知
    static let SelectEmotionKey = "SelectEmotionKey"
    static let EmotionDidSelectNotification = "EmotionDidSelectNotification"
    //删除文字的通知
    static let EmotionDidDeleteNotification = "EmotionDidDeleteNotification"
    //转发评论赞的通知
    static let StatusDidRepostNotification = "StatusDidRepostNotification"
    static let StatusDidCommentNotification = "StatusDidCommentNotification"
    static let StatusDidPraiseNotification = "StatusDidPraiseNotification"
    static let StatusToolBarRow = "StatusToolBarRow"
    //微博配图通知
    static let StatusDidPhotoClickNotification = "StatusDidPhotoClickNotification"
    static let StatusPhotos = "StatusPhotos"
    static let StatusPhotosIndex = "StatusPhotosIndex"
    //头像通知
    static let StatusDidHeaderClickNotification = "StatusDidHeaderClickNotification"
    static let StatusHeaderUID = "StatusDidHeaderUID"
    
}