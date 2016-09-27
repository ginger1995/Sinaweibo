//
//  PersonInfoController.swift
//  SinaWeibo
//

import UIKit

class PersonInfoController: StatusViewController {

    var uid:String?
    private var headerView:PersonView!
    private let kTableHeaderHeight:CGFloat = 200.0 //头高度
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置表头
        setHeaderView()
        
         //加载用户信息
        loadUserInfo()
    }
    
    //加载用户信息
    private func loadUserInfo(){
        var params = [String:AnyObject]()
        params["access_token"] = AccountTool.account()?.access_token
        params["uid"] = uid
        HttpTool.get(XLMess.User_Show_Url, params: params, success: { (dict) in
            if dict["error"] != nil{
                print(dict["error"])
                return
            }
            let user = User(dict: dict)
            self.headerView.user = user
            
//            if let status = user.status{
//            
//                let statusFrame = StatusFrame()
//                statusFrame.status = status
//                
//                
//                self.list.removeAll()
//                self.list.append(statusFrame)
//                self.tableView.reloadData()
//            }
            }, failure: nil)
    }
    
    
    //设置表头
    private func setHeaderView(){
        headerView = NSBundle.mainBundle().loadNibNamed("PersonView", owner: nil, options: nil).first! as! PersonView
        
        self.tableView.addSubview(headerView)
        //内边距
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        //内容偏移
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        updateHeaderView()
        
    }
    
    private func updateHeaderView(){
        
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        
        headerView.frame = headerRect
    }
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    
    

}
