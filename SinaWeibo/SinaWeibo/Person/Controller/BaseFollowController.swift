//
//  BaseFollowController.swift
//  SinaWeibo
//
//  关注粉丝列表的父类

import UIKit
import MJRefresh

class BaseFollowController: UITableViewController {

    var uid:String?
    var list = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //去多余
        tableView.tableFooterView = UIView(frame: CGRectZero)
        //行高
        tableView.rowHeight = 96
        setupUpRefresh()
    }
    
    private func setupUpRefresh(){
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.loadFriends()
            })
        self.tableView.mj_header.beginRefreshing()
    }
    
    func loadFriends(){
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = FriendCell.cellWithTableView(tableView,delegate: self)
        cell.user = list[indexPath.row]
        return cell
    }


}


//MARK: - FriendCellDelegate

extension BaseFollowController:FriendCellDelegate{
    
    func friendCellDidFollowClick(user: User, btn: UIButton) {
        //ios8以上
        //取消按钮
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        
        //关注按钮
        if user.following! {
            let deletefollowAction = UIAlertAction(title: "取消关注", style: .Default, handler: { (action) in
                self.deleteFollowing(user,btn: btn)
            })
            actionSheet.addAction(deletefollowAction)
        } else{
            let followAction = UIAlertAction(title: "关注", style: .Default, handler: { (action) in
                self.following(user,btn: btn)
            })
            actionSheet.addAction(followAction)
        }
        
        actionSheet.addAction(cancelAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    //关注用户
    private func following(user:User,btn:UIButton){
        var param = [String:AnyObject]()
        param["access_token"] = AccountTool.account()?.access_token
        param["uid"] = user.idstr
        
        HttpTool.post(XLMess.User_Following_Url, params: param, success: { (dict) in
            if dict["error"] != nil{
                print(dict["error"])
                return
            }
            //设置用户关注状态
            user.following = true
            btn.selected = false
            MessageTool.showText("关注成功")
            }, failure: nil)
    }
    
    
    //取消关注
    private func deleteFollowing(user:User,btn:UIButton){
        var param = [String:AnyObject]()
        param["access_token"] = AccountTool.account()?.access_token
        param["uid"] = user.idstr
        
        HttpTool.post(XLMess.User_DeleteFollowing_Url, params: param, success: { (dict) in
            if dict["error"] != nil{
                print(dict["error"])
                return
            }
            //设置用户关注状态
            user.following = false
            btn.selected = true
            MessageTool.showText("取消关注成功")
            }, failure: nil)
    }
    
}

