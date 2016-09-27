//
//  SingleStatusController.swift
//  SinaWeibo
//
//  微博正文
//

import UIKit
import MJRefresh

class SingleStatusController: UITableViewController {
    
    init(){
        super.init(style: UITableViewStyle.Grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    var statusFrame:StatusFrame!
    private var comments:[Comment] = [Comment]()
    
    private var page = 1 //页码
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "微博正文"
        
        setUpDownRefresh()
        
        setUpUpRefresh()
        
        loadNewComment()
       // loadStatus()
        
        setNotification()
    }
    
    deinit{
        print("销毁")
        //移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //注册评论转发赞通知
    private func setNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SingleStatusController.RepostNotification), name: Notification.StatusDidRepostNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SingleStatusController.CommentNotification), name: Notification.StatusDidCommentNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SingleStatusController.PraiseNotification), name: Notification.StatusDidPraiseNotification, object: nil)
    }
    
    //MARK: - 通知
    //转发
    func RepostNotification(){
        let repostVC = RepostViewController()
        repostVC.id = statusFrame.status?.id
        let nav = UINavigationController(rootViewController: repostVC)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    //评论
    func CommentNotification(){
        let commentVC = CommentController()
        commentVC.delegate = self
        commentVC.id = statusFrame.status?.id
        let nav = UINavigationController(rootViewController: commentVC)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    //赞
    func PraiseNotification(){}
    
    //集成下拉刷新
    func setUpDownRefresh(){
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.loadNewComment()
        })
        self.tableView.mj_header.beginRefreshing()
    }
    
    //集成上拉刷新控件
    func setUpUpRefresh(){
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [unowned self] in
            self.loadMoreComment()
        })
    }
    
    //加载评论
    private func loadNewComment(){
        let account = AccountTool.account()
        var params = [String:AnyObject]()
        params["access_token"] = account?.access_token
        let id = statusFrame.status?.id
        //params["id"] = id!
        params["id"] = id
        params["page"] = 1
        params["count"] = 50
        
        let dealingResult:(arr:[AnyObject]) -> Void = { arr in
            // 将 "微博字典"数组 转为 "微博模型"数组
            let newComments = Comment.commentWith(arr)
            // 将最新的微博数据，添加到总数组的最前面
            self.comments = newComments
            print("newComments:\(newComments.count)")
            if self.comments.count < 40{
                self.tableView.mj_footer.hidden = true
            }else{
                self.tableView.mj_footer.hidden = false
            }
            self.page = 1
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        }
        
        HttpTool.get(XLMess.Single_Comment_Url, params: params, success: { (dict) in
            if dict["error"] != nil{
                print(dict)
            }else if let arr = dict["comments"] as? [AnyObject]{
                
                CommentTool.saveComments(arr, page: 1, id: id!)
                // 将 "微博字典"数组 转为 "微博模型"数组
                dealingResult(arr: arr)
            }
            }, failure: { (error) in
                CommentTool.commentWithParams(params) { (comments) -> Void in
                    if comments.count > 0{
                        dealingResult(arr: comments)
                    }else{
                        self.tableView.mj_header.endRefreshing()
                    }
                }
                
        })
       
    }
    
    //加载更多评论
    private func loadMoreComment(){
        //下一页
        page += 1
        //拼接请求参数
        let account = AccountTool.account()
        
        var params = [String:AnyObject]()
        params["access_token"] = account?.access_token
        let id = statusFrame.status?.id
        //params["id"] = id!
        params["id"] = id
        params["page"] = page
        params["count"] = 50
        
        let dealingResult:(comments:[AnyObject]) -> Void = { comments in
            let newComments = Comment.commentWith(comments)
            self.comments += newComments
            //刷新表格
            self.tableView.reloadData()
            self.tableView.mj_footer.endRefreshing()
        }
        
        HttpTool.get(XLMess.Single_Comment_Url, params: params, success: { (dict) in
            if dict["error"] != nil{
                print(dict)
                self.page -= 1
            }else if let arr = dict["comments"] as? [AnyObject]{
                CommentTool.saveComments(arr, page: self.page, id: id!)
                dealingResult(comments: arr)
            }
            self.tableView.mj_footer.endRefreshing()
            }, failure: { (error) in
                CommentTool.commentWithParams(params) { (comments) -> Void in
                    if comments.count > 0{
                        dealingResult(comments: comments)
                    }else{
                        self.page -= 1
                    }
                }
                self.tableView.mj_footer.endRefreshing()
        })
    }
    
    //加载微博
    private func loadStatus(){
        
        let account = AccountTool.account()
        var params = [String:AnyObject]()
        params["access_token"] = account?.access_token
        params["id"] = statusFrame.status?.id
       
        HttpTool.get(XLMess.Single_SingleStatus_Url, params: params, success: { (dict) in
            if  dict["error"] != nil{
                print(dict)
            }else{
               
                let status = Status(dict: dict)
                self.statusFrame.status = status
                self.tableView.reloadData()
                MessageTool.dissm()
            }
            }, failure: nil)
    }
    
    
    //MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return comments.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = StatusCell.cellWithTableView(self.tableView,delegate: self)
            cell.object = statusFrame
            return cell
        }else{
            let cell = CommentCell.cellWithTableView(tableView)
            cell.comment = comments[indexPath.row]
            return cell
        }
    }
    
    //MARK: - UITableViewDelegate
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return statusFrame.cellHeight
        } else{
            //高度自适应
            return UITableViewAutomaticDimension
        }
    }
    
    //虚算cell高度
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}

extension SingleStatusController:CommentControllerDelegate{
    func commentDidSumbit(comment: Comment) {
        self.comments.insert(comment, atIndex: 0)
        self.tableView.reloadData()
    }
}


//MARK: - StatusCellDelegate

extension SingleStatusController:StatusCellDelegate{
    //点击更多
    func statusCelldidMoreClick(status:Status) {
        
        //ios8以上
        //取消
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        //取消收藏
        if status.favorited!{
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
    
    
}


