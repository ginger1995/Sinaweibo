//
//  FolloerController.swift
//  SinaWeibo
//
//  粉丝
//

import UIKit
import MJRefresh

class FollowerController: BaseFollowController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    

    override func loadFriends(){
        let account = AccountTool.account()
        var params = [String:AnyObject]()
        params["access_token"] = account?.access_token
        params["uid"] = uid
        params["count"] = 50
        
        HttpTool.get(XLMess.Person_Follower_Url, params: params, success: { (dict) in
            if dict["error"] != nil{
                print(dict)
                return
            }
        
            let arr = dict["users"] as? [AnyObject]
            self.list = User.userWithArray(arr!)
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    
    
  
}
