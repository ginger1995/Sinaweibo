//
//  MessageCenterViewController.swift
//  新浪微博
//
//  消息中心
//

import UIKit
import MJRefresh

class MessageCenterViewController: UITableViewController {
    
    private var messList = ["新评论数","新私信数","新提及我的评论数","新提及我的微博数"]
    private var message:Message?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //集成下拉
        setupDownRefresh()
        //获得未读数
        let timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(MessageCenterViewController.setUpUnreadCount), userInfo: nil, repeats: true)
        // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    // 集成下拉刷新控件
    func setupDownRefresh(){
        //        //添加控件
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.setUpUnreadCount()
            })
        self.tableView.mj_header.beginRefreshing()
    }
    
    internal func setUpUnreadCount(){
        //拼接请求参数
        let account = AccountTool.account()
        var params = [String:AnyObject]()
        params["access_token"] = account?.access_token
        params["uid"] = account?.uid
        
        let url = XLMess.User_Unread_Count_Url
        
        HttpTool.get(url, params: params, success: { (dict) in
            if dict["error"] != nil{
                print(dict["error"])
            }
            
            let message = Message(dict: dict)
            var count = 0
            count += message.cmt ?? 0
            count += message.dm ?? 0
            count += message.mention_cmt ?? 0
            count += message.mention_status ?? 0
            self.message = message
            
            
            if count == 0 { // 如果是0，得清空数字
                self.tabBarItem.badgeValue = nil
                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            }else{//非0
                self.tabBarItem.badgeValue = "\(count)"
                UIApplication.sharedApplication().applicationIconBadgeNumber = count
            }
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
        }
        
    }
    
    
    
    //MARK: - UITableViewSource
    
    private struct Static{
        static let CellID = "mess"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(Static.CellID)
        if cell == nil{
            cell = UITableViewCell(style: .Default, reuseIdentifier: Static.CellID)
        }
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "\(messList[indexPath.row]):\(message?.cmt ?? 0)"
        case 1:
            
            cell?.textLabel?.text = "\(messList[indexPath.row]):\(message?.dm ?? 0)"
        case 2:
            
            cell?.textLabel?.text = "\(messList[indexPath.row]):\(message?.mention_cmt ?? 0)"
        case 3:
            
            cell?.textLabel?.text = "\(messList[indexPath.row]):\(message?.mention_status ?? 0)"
        default:
            break
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0:
            clearUnread("cmt",indexPath:indexPath)
        case 1:
            clearUnread("dm",indexPath:indexPath)
        case 2:
            clearUnread("mention_cmt",indexPath:indexPath)
        case 3:
            clearUnread("mention_status",indexPath:indexPath)
        default:
            break
        }
        
    }
    
    //清理未读
    private func clearUnread(type:String,indexPath:NSIndexPath){
        var params = [String:AnyObject]()
        params["access_token"] = AccountTool.account()?.access_token
        params["type"] = type
        
        HttpTool.post(XLMess.User_ClearUnread_Count_Url, params: params, success: { (dict) in
            if dict["error"] != nil{
                print(dict["error"])
                return
            }
            //置0
            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            cell?.textLabel?.text = self.messList[indexPath.row] + ":\(0)"
            }, failure: nil)
    }
}
