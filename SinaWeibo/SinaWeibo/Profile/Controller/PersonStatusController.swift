//
//  PersonStatusController.swift
//  SinaWeibo
//
//  个人最近发布的微博
//

import UIKit

class PersonStatusController: StatusViewController {
    
    var uid:String?
    
    private var user:User?
    private var headerView:PersonView!
    private let kTableHeaderHeight:CGFloat = 200.0 //头高度
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        //不是当前登录用户
//        if uid != AccountTool.account()?.uid{
//            //设置表头
//            setHeaderView()
//        }
//
        // 集成下拉刷新控件
        setupDownRefresh()
        //集成上拉刷新控件
        setUpUpRefresh()
        
        loadNewStatus()
    }
    
//    //设置表头
//    private func setHeaderView(){
//        headerView = NSBundle.mainBundle().loadNibNamed("PersonView", owner: nil, options: nil).first! as! PersonView
//        
//        self.tableView.addSubview(headerView)
//        //内边距
//        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
//        //内容偏移
//        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
//        updateHeaderView()
//        
//    }
//    
//    private func updateHeaderView(){
//        
//        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
//        if tableView.contentOffset.y < -kTableHeaderHeight {
//            headerRect.origin.y = tableView.contentOffset.y
//            headerRect.size.height = -tableView.contentOffset.y
//        }
//        
//        headerView.frame = headerRect
//
//    }
    
    override func loadNewStatus() {
        let account = AccountTool.account()
        var params = [String:AnyObject]()
        params["access_token"] = account?.access_token
        params["uid"] = uid
        //取出最前面的微博（最新的微博,ID最大的微博）
        if let first = list.first as? StatusFrame{
            let status = first.status
            // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
            params["since_id"] = status!.idstr
        }
        
        HttpTool.get(XLMess.Person_Status_Url, params: params, success: { (dict) in
            if dict["error"] != nil{
                print(dict)
               // self.tableView.mj_header.endRefreshing()
                return
            }
            guard let statusesArr = dict["statuses"] as? [AnyObject] else{
                //self.tableView.mj_header.endRefreshing()
                return
            }
            // 将 "微博字典"数组 转为 "微博模型"数组
            let newStatuses = Status.statusWithArr(statusesArr)
            let newFrames = StatusFrame.statusFramesWithStatuses(newStatuses)
            // 将最新的微博数据，添加到总数组的最前面
            self.list = newFrames + self.list
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            
            }, failure: { (error) in
                print(error)
                self.tableView.mj_header.endRefreshing()
        })
    }
    
    //上拉加载更多微博数据
    override func loadMoreStatus(){
        //拼接请求参数
        let account = AccountTool.account()
        var params = [String:AnyObject]()
        params["access_token"] = account?.access_token
        params["uid"] = uid
        //取出最后面的微博（最新的微博ID最大的微博）
        if let lastStatusF = self.list.last as? StatusFrame {
            
            let lastStatus = lastStatusF.status
            // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
            // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
            let maxId = (lastStatus!.idstr! as NSString).longLongValue - 1
            params["max_id"] = NSNumber(longLong: maxId)
        }
        
       
        
        HttpTool.get(XLMess.Person_Status_Url, params: params, success: { (dict) in
            //数据转模型
            guard let array = dict["statuses"] as? [AnyObject] else{
                self.tableView.mj_footer.endRefreshing()
                return
            }
            let newStatuses = Status.statusWithArr(array)
            let newFrames = StatusFrame.statusFramesWithStatuses(newStatuses)
            self.list += newFrames as [AnyObject]
            //刷新表格
            self.tableView.reloadData()
            self.tableView.mj_footer.endRefreshing()
            
            }, failure: { (error) in
                self.tableView.mj_footer.endRefreshing()
        })
        
    }
    
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        
//        updateHeaderView()
//    }
//    
    
}
