//
//  CollectionController.swift
//  SinaWeibo
//
//  收藏
//

import UIKit

class FavoritesController: StatusViewController {
    
    private lazy var ids = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收藏"
        //设置导航
        setupNav()
        // 集成下拉刷新控件
        setupDownRefresh()
//        //集成上拉刷新控件
//        setUpUpRefresh()
    }
    
    //设置导航确定按钮
    private func setupNav(){
        let rightItem = UIBarButtonItem(title: "确定", style: .Done, target: self, action: #selector(FavoritesController.okClick))
        self.navigationItem.rightBarButtonItem = rightItem
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    //点击确定 发送批量删除收藏
    internal func okClick(){
        let account = AccountTool.account()
        
        let idsStr = ids.joinWithSeparator(",")
        
        var params = [String:AnyObject]()
        params["access_token"] = account?.access_token
        params["ids"] = idsStr
        
        HttpTool.post(XLMess.User_DeleteFavorites_Url, params: params, success: { (dict) in
            if let result =  dict["result"] as? Bool{
                if result{
                    self.ids.removeAll()
                    MessageTool.showText("操作成功!")
                    self.tableView.mj_header.beginRefreshing()
                }
            }else{
                MessageTool.showText("操作失败，稍后再试")
            }
            
            }) { (error) in
                self.tableView.mj_header.endRefreshing()
            
        }
    }
    
   
    //加载收藏
    override func loadNewStatus() {
        
        let account = AccountTool.account()
        var params = [String:AnyObject]()
        params["access_token"] = account?.access_token
        let url = XLMess.User_Favorites_Url
        
        HttpTool.get(url, params: params, success: { (dict) in
            if dict["error"] != nil{
                print(dict)
                self.tableView.mj_header.endRefreshing()
                return
            }
            guard let favoritesArr = dict["favorites"] as? [AnyObject] else{
                self.tableView.mj_header.endRefreshing()
                return
            }
            self.list = Favorite.favoriteWithArr(favoritesArr)
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            
            }, failure: { (error) in
                print(error)
                self.tableView.mj_header.endRefreshing()
        })

        
    }
    
    //MARK: - UITableViewSource
   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let favorite = list[indexPath.row]
        
        let cell = StatusCell.cellWithTableView(tableView,delegate: self)
        cell.object = favorite
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let favorite = list[indexPath.row] as! Favorite
        return favorite.statusFrame!.cellHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let favorite = list[indexPath.row] as? Favorite
        let vc = SingleStatusController()
        vc.statusFrame = favorite?.statusFrame
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - 收藏点击
    override func statusCellDidFavorityClick(favorite:Favorite, selected: Bool) {
        let id = favorite.statusFrame?.status?.idstr
        if !selected{//添加不要收藏的id
            var flag = true
            for item in ids{
                if item == "\(id!)"{
                    flag = false
                    break
                }
            }
            if flag{
                ids.append("\(id!)")
            }
            
        }else{
            //过滤要收藏的id
            ids = ids.filter({ (item) -> Bool in
                return item != "\(id!)"
            })
        }
        
        if ids.count > 0{//确定按钮可用
            self.navigationItem.rightBarButtonItem?.enabled = true
        }else{
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
        
    }

}


