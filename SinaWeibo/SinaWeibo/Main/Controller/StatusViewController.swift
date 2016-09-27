//
//  StatusViewController.swift
//  SinaWeibo
//
//  微博列表，用来继承
//

import UIKit
import MJRefresh

class StatusViewController: UITableViewController {
    
    /**
     *  微博数组（里面放的都是Status模型，一个Status对象就代表一条微博）
     */
    var list = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.color(211, 211,211)
        self.tableView.separatorStyle = .None
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //注册通知
    private func setNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StatusViewController.repostNotification(_:)), name: Notification.StatusDidRepostNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StatusViewController.commentNotification(_:)), name: Notification.StatusDidCommentNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StatusViewController.praiseNotification(_:)), name: Notification.StatusDidPraiseNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StatusViewController.photosNotification(_:)), name: Notification.StatusDidPhotoClickNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StatusViewController.headClick(_:)), name: Notification.StatusDidHeaderClickNotification, object: nil)
    }
    
    //MARK: - 通知
    //头像通知
    internal func headClick(notification:NSNotification){
        let userinfo = notification.userInfo
        let idStr = userinfo?[Notification.StatusHeaderUID] as? String
        let personVC = PersonInfoController()
        personVC.uid = idStr
        self.navigationController?.pushViewController(personVC, animated: true)
    }
    
    //图片浏览
    internal func photosNotification(notification:NSNotification){
        let userinfo = notification.userInfo
        let status = userinfo?[Notification.StatusPhotos] as? Status
        let index = userinfo?[Notification.StatusPhotosIndex] as? Int
        
        let photoPageVC = PhotosPageController()
        photoPageVC.status = status
        photoPageVC.index = index
        
        //自定义转场动画
        photoPageVC.modalPresentationStyle = .Custom
        photoPageVC.transitioningDelegate = Transition.sharedInstance
        
        self.presentViewController(photoPageVC, animated: true, completion: nil)
    }
    
    //转发
    internal  func repostNotification(notification:NSNotification){
        let userinfo = notification.userInfo
        let id = userinfo?[Notification.StatusToolBarRow] as? NSNumber
        
        let repostVC = RepostViewController()
        repostVC.id = id
        let nav = UINavigationController(rootViewController: repostVC)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    //评论
    internal func commentNotification(notification:NSNotification){
        let userinfo = notification.userInfo
        let id = userinfo?[Notification.StatusToolBarRow] as? NSNumber
        let commentVC = CommentController()
        commentVC.id = id
        let nav = UINavigationController(rootViewController: commentVC)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    //赞
     internal func praiseNotification(notification:NSNotification){}
    
    //集成上拉刷新控件
    func setUpUpRefresh(){
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [unowned self] in
            self.loadMoreStatus()
        })
    }
    
    // 集成下拉刷新控件
    func setupDownRefresh(){
//        //添加控件
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.loadNewStatus()
        })
        self.tableView.mj_header.beginRefreshing()
    }
    
    //加载数据
    func loadNewStatus(){
      
    }
    
    
    //上拉加载更多微博数据
    func loadMoreStatus(){
       
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = StatusCell.cellWithTableView(self.tableView,delegate:self)
        //给cell传递模型数据
        cell.object = self.list[indexPath.row] as? StatusFrame
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let frame = list[indexPath.row] as? StatusFrame{
            return frame.cellHeight
        }else{
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = SingleStatusController()
        vc.statusFrame = list[indexPath.row] as? StatusFrame
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - StatusCellDelegate

extension StatusViewController:StatusCellDelegate{
    //点击更多
    func statusCelldidMoreClick(status:Status) {
     
        //ios8以上
        //取消按钮
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        //收藏按钮
        if status.favorited!{//取消收藏
            let deleteFavority = UIAlertAction(title: "取消收藏", style: .Default, handler: { (action) in
                self.deleteFavority(status)
            })
            actionSheet.addAction(deleteFavority)
        }else{
            //收藏
            let favorityAction = UIAlertAction(title: "收藏", style: .Default) { (action) in
                self.addFavority(status)
            }
            actionSheet.addAction(favorityAction)
        }
        
        //关注按钮
        if status.user!.following! {
            let deletefollowAction = UIAlertAction(title: "取消关注", style: .Default, handler: { (action) in
                self.deleteFollowing(status)
            })
            actionSheet.addAction(deletefollowAction)
        }
        
        actionSheet.addAction(cancelAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    //取消关注
    private func deleteFollowing(status:Status){
        var param = [String:AnyObject]()
        param["access_token"] = AccountTool.account()?.access_token
        param["uid"] = status.user?.idstr
        
        HttpTool.post(XLMess.User_DeleteFollowing_Url, params: param, success: { (dict) in
            if dict["error"] != nil{
                print(dict["error"])
                return
            }
            MessageTool.showText("取消关注成功")
            status.user?.following = false
            }, failure: nil)
    }
    
    //取消收藏
    private func deleteFavority(status:Status){
        let account = AccountTool.account()
        var params = [String:AnyObject]()
        params["access_token"] = account?.access_token
        params["id"] = status.id
        
        HttpTool.post(XLMess.User_DeleteFavority_Url, params: params, success: { (dict) in
            if dict["error"] != nil{
                print(dict["error"])
                return
            }
            MessageTool.showText("取消收藏成功！")
            status.favorited = false
            }, failure: nil)
    }
    
    //收藏
    private func addFavority(status:Status){
        let account = AccountTool.account()
        var params = [String:AnyObject]()
        params["access_token"] = account?.access_token
        params["id"] = status.id
        
        HttpTool.post(XLMess.User_AddFavority_Url, params: params, success: { (dict) in
            if dict["error"] != nil{
                print(dict["error"])
                return
            }
            MessageTool.showText("收藏成功！")
            status.favorited = true
            }, failure: nil)
    }
    
    //供子类调用
    func statusCellDidFavorityClick(favorite:Favorite, selected: Bool) {
        
    }
    
}
