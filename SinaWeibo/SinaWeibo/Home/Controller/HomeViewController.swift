//
//  HomeViewController.swift
//  新浪微博
//
//  首页
//

import UIKit


class HomeViewController: StatusViewController {
    
    /**
    *  微博数组（里面放的都是Status模型，一个Status对象就代表一条微博）
    */
    private var visitorLoginView:VisitorLoginView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AccountTool.account() == nil{
            loadVisitorView()
            //延时一秒
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                self.visitorDidLogin()
            }
        }else{
            reloadView()
        }
    }
    
    private func reloadView(){
        self.tableView = UITableView(frame: self.view.bounds, style: .Plain)
        self.tableView.backgroundColor = UIColor.color(211, 211,211)
        self.tableView.separatorStyle = .None
        //设置导航内容
        setUpNav()
        //获得用户信息(昵称)
        setUpUserInfo()

        // 集成下拉刷新控件
        setupDownRefresh()
        //集成上拉刷新控件
        setUpUpRefresh()

        //获得未读数
        let timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(HomeViewController.setUpUnreadCount), userInfo: nil, repeats: true)
        // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    private func loadVisitorView(){
        visitorLoginView = VisitorLoginView()
        //设置代理
        visitorLoginView?.visitorDelegate = self
        view = visitorLoginView
        //设置顶部导航栏的左右按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: #selector(HomeViewController.visitorWillRegister))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "登录", style: .Plain, target: self, action: #selector(HomeViewController.visitorWillLogin))
        //UINavigationBar.appearance().tintColor = themeColor
    }
    
    //注册
    internal func visitorWillRegister(){
        visitorDidRegister()
    }
    
    //登录
    internal func visitorWillLogin(){
        visitorDidLogin()
    }
    
    //刷新
    func refresh() {
        if self.tabBarItem.badgeValue != nil{
            self.tableView.mj_header.beginRefreshing()
        }
    }
    
    /**
    *  获得未读数
    */
    func setUpUnreadCount(){
        //拼接请求参数
        let account = AccountTool.account()
        var params = [String:AnyObject]()
        params["access_token"] = account?.access_token
        params["uid"] = account?.uid
        
        let url = XLMess.Home_Unread_Url
        
        HttpTool.get(url, params: params, success: { (dict) in
            // 设置提醒数字(微博的未读数)
            let status = dict["status"] as! Int
            if status == 0 { // 如果是0，得清空数字
                
                self.tabBarItem.badgeValue = nil
                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            }else{//非0
                self.tabBarItem.badgeValue = "\(status)"
                UIApplication.sharedApplication().applicationIconBadgeNumber = status
            }
            }) { (error) in
                //self.tableView.mj_header.endRefreshing()
                print(error)
        }
        
        
    }
    
       //加载数据
    override func loadNewStatus(){
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
//            let data = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("fakeStatus", ofType: "plist")!)! as Dictionary
//            let newStatuses = Status.statusWithArr(data["statuses"] as! NSArray)
//            let newFrames = StatusFrame.statusFramesWithStatuses(newStatuses)
//            
//            // 将最新的微博数据，添加到总数组的最前面
//            let range = NSMakeRange(0, newStatuses.count)
//            let set = NSIndexSet(indexesInRange: range)
//            self.statusFrames.insertObjects(newFrames as [AnyObject], atIndexes: set)
//            self.tableView.reloadData()
//            control.endRefreshing()
//            self.showNewStatusCount(newStatuses.count)
//        }
//        return
        
        //定义一个闭包处理返回的字典数据
        let dealingResult:(arr:[AnyObject]) -> Void = { arr in
            // 将 "微博字典"数组 转为 "微博模型"数组
            let newStatuses = Status.statusWithArr(arr)
            let newFrames = StatusFrame.statusFramesWithStatuses(newStatuses)
            // 将最新的微博数据，添加到总数组的最前面
            self.list = newFrames + self.list
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.showNewStatusCount(newStatuses.count)
        }
        
        //拼接参数
        let account = AccountTool.account()
        var parmas = [String:AnyObject]()
        parmas["access_token"] = account?.access_token
        let url = XLMess.Home_Friends_Timeline_Url
        //取出最前面的微博（最新的微博,ID最大的微博）
        if let first = list.first as? StatusFrame {
            let status = first.status
            // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
            parmas["since_id"] = status!.idstr
        }
        // 先尝试从数据库中加载微博数据
       StatusTool.statuesWithParams(parmas) { (statuses) -> Void in
            if statuses.count > 0{
                dealingResult(arr: statuses)
            }else{
                HttpTool.get(url, params: parmas, success: { (dict) in
                    
                    if dict["error"] != nil{
                        print(dict)
                        self.tableView.mj_header.endRefreshing()
                        return
                    }
                    guard let statusesArr = dict["statuses"] as? [AnyObject] else{
                        self.tableView.mj_header.endRefreshing()
                        return
                    }
                    StatusTool.saveStatues(statusesArr)
                    // 将 "微博字典"数组 转为 "微博模型"数组
                    dealingResult(arr: statusesArr)

                    }, failure: { (error) in
                        print(error)
                        self.tableView.mj_header.endRefreshing()
                })
                
            }
        }
        
        
    }
    
    /**
    *  显示最新微博的数量
    *
    *  param count 最新微博的数量
    */
    func showNewStatusCount(count:Int){
        //刷新成功(清空图标数字)
        self.tabBarItem.badgeValue = nil
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0;
        
        //创建label
        let label = UILabel()
        //label.backgroundColor = UIColor(patternImage: UIImage(named: "timeline_new_status_background")!)
        label.backgroundColor = UIColor.grayColor()
        label.width = UIScreen.mainScreen().bounds.size.width
        label.height = 35
        
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        
        //设置其他属性
        if count == 0{
            label.text = "没有新的微博数据，稍后再试"
        }else{
            label.text = String(format: "共有%zd条新微博数据", arguments: [count])
        }
        
        //添加label
        label.y = 64 - label.height
        //将label添加到导航控制器的view中，并且是盖在导航栏下边
        self.navigationController!.view.insertSubview(label, belowSubview: self.navigationController!.navigationBar)
        
        //动画
        let duration = 1.0 //动画时间
        UIView.animateWithDuration(duration, animations: { () -> Void in
            label.transform = CGAffineTransformMakeTranslation(0, label.height)
            }) { (finished) -> Void in
                let delay = 1.0 //延迟1秒
                // CurveLinear:匀速
                UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    label.transform = CGAffineTransformIdentity
                    }, completion: { (finished) -> Void in
                        label.removeFromSuperview()
                })
        }
    }

    
    //获得用户信息(昵称)
    func setUpUserInfo(){
        //拼接请求参数
        let account = AccountTool.account()
        if account == nil{return}
        
        var params = [String:AnyObject]()
        params["access_token"] = account!.access_token
        params["uid"] = account!.uid
        //发送请求
        let url = XLMess.Home_Show_Url
        
        HttpTool.get(url, params: params, success: { (dict) in
            //标题按钮
            let titleButton = self.navigationItem.titleView as! UIButton
            //设置名字
            if let name = User(dict: dict).name {
                titleButton.setTitle(name, forState: UIControlState.Normal)
                //存储昵称到沙盒中
                account?.name = name
                AccountTool.saveAccount(account!)
            }
            }) { (error) in
                print(error)
        }
        
    }
    
    //设置导航内容
    func setUpNav(){
        //设置导航左右按钮
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.item(self, action: #selector(HomeViewController.friendSearch), image: "navigationbar_friendsearch", highImage: "navigationbar_friendsearch_highlighted")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.item(self, action: #selector(HomeViewController.pop), image: "navigationbar_pop", highImage: "navigationbar_pop_highlighted")
        //中间按钮
        let titleButton = TitleButton()
        //设置文字
        titleButton.setTitle("首页", forState: UIControlState.Normal)
        titleButton.addTarget(self, action: #selector(HomeViewController.titleClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
    }
    
    func titleClick(sender:UIButton){
        //创建下拉菜单
        let menuView = DropDownMenu.menu()
        menuView.delegate = self
        //设置内容
        let vc = TitleMenuViewController()
        vc.view.height = 150
        vc.view.width = 150
        menuView.contentController = vc
        //显示
        menuView.showFrom(sender)
    }
    
    func friendSearch(){
        print("friendSearch")
    }
    
    func pop(){
        print("pop")
    }
    
    //上拉加载更多微博数据
    override func loadMoreStatus(){
        //拼接请求参数
        let account = AccountTool.account()
        var params = [String:AnyObject]()
        params["access_token"] = account?.access_token
        
        //取出最后面的微博（最新的微博ID最大的微博）
        
        if let lastStatusF = self.list.last as? StatusFrame {
            let lastStatus = lastStatusF.status
            // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
            // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
            let maxId = (lastStatus!.idstr! as NSString).longLongValue - 1
            params["max_id"] = NSNumber(longLong: maxId)
        }
        
        let dealingResult:(statuses:[AnyObject]) -> Void = { statuses in
            let newStatuses = Status.statusWithArr(statuses)
            let newFrames = StatusFrame.statusFramesWithStatuses(newStatuses)
            self.list += newFrames as [AnyObject]
            //刷新表格
            self.tableView.reloadData()
            self.tableView.mj_footer.endRefreshing()
        }
        
        let url = XLMess.Home_Friends_Timeline_Url
        HttpTool.get(url, params: params, success: { (dict) in
            
            //数据转模型
            let array = dict["statuses"] as! [AnyObject]
            StatusTool.saveStatues(array)
            dealingResult(statuses: array)
            
            }, failure: { (error) in
                StatusTool.statuesWithParams(params) { (statuses) -> Void in
                    if statuses.count > 0{
                        dealingResult(statuses: statuses)
                    }else{
                        self.tableView.mj_footer.endRefreshing()
                    }
                }
                
        })
        
        
        
    }
    
    //MARK: - UITableViewDelegate
    
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        //    scrollView == self.tableView == self.view
//        // 如果tableView还没有数据，就直接返回
//        if self.list.count == 0 || self.tableView.tableFooterView?.hidden == false{
//            return
//        }
//        
//        let offsetY = scrollView.contentOffset.y
//        //当最后一个cell完全显示
//        let judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - tableView.tableFooterView!.height
//        if offsetY >= judgeOffsetY{ //最后一个cell完全显示
//            tableView.tableFooterView?.hidden = false
//            loadMoreStatus()
//        }
//    }
    
   
    
}

//MARK: - DropDownMenuDelegate
extension HomeViewController:DropdownMenuDelegate{
    /**
    *  下拉菜单被销毁了
    */
    func dropDownMenuDidDismiss(menu: DropDownMenu) {
        let titleButton = self.navigationItem.titleView as! UIButton
        titleButton.selected = true
    }
    
    /**
    *  下拉菜单显示了
    */
    func dropDownMenuDidShow(menu: DropDownMenu) {
        let titleButton = self.navigationItem.titleView as! UIButton
        titleButton.selected = false
    }
}

//MARK: - VisitorLoginViewDelegate

extension HomeViewController: VisitorLoginViewDelegate{
    
    func visitorDidLogin() {
        print("visitorDidLogin")
        let oAuth = OAuthViewController()
        oAuth.delegate = self
        self.presentViewController(UINavigationController(rootViewController: oAuth), animated: true, completion: nil)
    }
    
    func visitorDidRegister() {
        
    }
}

//MARK: - OAuthViewControllerDelegate

extension HomeViewController: OAuthViewControllerDelegate {
    func oAuthViewDidLogin() {
        visitorLoginView?.removeFromSuperview()
        reloadView()
    }
}