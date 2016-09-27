//
//  FriendsViewController.swift
//  SinaWeibo
//
//  关注界面
//

import UIKit
import MJRefresh

class FriendsViewController: BaseFollowController {

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setupUpRefresh(){
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.loadFriends()
        })
        self.tableView.mj_header.beginRefreshing()
    }
    
    //加载关注用户
    override func loadFriends(){
        let account = AccountTool.account()
        var params = [String:AnyObject]()
        params["access_token"] = account?.access_token
        params["uid"] = uid
        params["count"] = 50
        
        HttpTool.get(XLMess.User_Friends_Url, params: params, success: { (dict) in
            if dict["error"] != nil{
                print(dict)
                return
            }
            let arr = dict["users"] as? [AnyObject]
            print(arr?.count)
            self.list = User.userWithArray(arr!)
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            }) { (error) in
                self.tableView.mj_header.endRefreshing()
        }
    }

}
