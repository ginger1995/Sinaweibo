//
//  ProfileViewController.swift
//  新浪微博
//
//  我
//

import UIKit
import Kingfisher

class ProfileViewController: UITableViewController {
    
    @IBOutlet weak var iconView: IconView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var statusCountLabel: UILabel!
    @IBOutlet weak var hotCountLabel: UILabel!
    @IBOutlet weak var funCountLabel: UILabel!
    @IBOutlet weak var verufuedView: UIImageView!
    @IBOutlet weak var collectLabel: UILabel!
    @IBOutlet weak var clearLabel: UILabel!
    
    let cache = KingfisherManager.sharedManager.cache
    
    private var user:User?{
        didSet{
            setValues()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadCount()
    }
    
    private func setUI(){
        self.tableView.backgroundView = UIView()
        //self.tableView.backgroundView?.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        //self.tableView.backgroundView?.backgroundColor = UIColor.brownColor()
        self.tableView.backgroundView?.backgroundColor = UIColor(patternImage: UIImage(named: "logobackground")!)
        cache.calculateDiskCacheSizeWithCompletionHandler { (size) -> () in
            let mSize = Float(size) / 1024 / 1024
            let mStr = String(format: "%.1f", arguments: [mSize])
            self.clearLabel.text = "清理缓存(\(mStr)M)"
        }
    }
    
    private func setValues(){
        iconView.user = user
        /** 会员图标 */
        if user!.vip {
            verufuedView?.hidden = false
            
            let vipName = String(format: "common_icon_membership_level%d", arguments: [user!.mbrank!])
            verufuedView?.image = UIImage(named: vipName)
            nameLabel?.textColor = UIColor.orangeColor()
        }else{
            nameLabel?.textColor = UIColor.blueColor()
            verufuedView?.hidden = true
        }
        nameLabel.text = user?.name
        aboutLabel.text = user?.descriptionStr
        statusCountLabel.text = "\(user!.statuses_count!)"
        hotCountLabel.text = "\(user!.friends_count!)"
        funCountLabel.text = "\(user!.followers_count!)"
        
        collectLabel.text = "我的收藏(\(user!.favourites_count!))"
        
    }
    
    //批量获取用户的粉丝数、关注数、微博数
    private func loadCount(){
        let account = AccountTool.account()
        var params = [String:AnyObject]()
        params["access_token"] = account?.access_token
        params["screen_name"] = account?.name
        
        HttpTool.get(XLMess.User_Show_Url, params: params, success: { (dict) in
            if dict["error"] != nil{
                print(dict)
            }else{
                self.user = User(dict: dict)
            }
            }, failure: nil)
    }
    
    //MARK: - 监听事件
    
    @IBAction func statusClick(sender: UIButton) {
        let vc = PersonStatusController()
        vc.uid = AccountTool.account()?.uid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func hotClick(sender: UIButton) {
        let friendsVC = FriendsViewController()
        friendsVC.uid = AccountTool.account()?.uid
        self.navigationController?.pushViewController(friendsVC, animated: true)
    }
    
    @IBAction func fanClick(sender: UIButton) {
        let vc = FollowerController()
        vc.uid = AccountTool.account()?.uid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - 清除缓存
    
    func clearCache(){
        let circle = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        circle.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: circle)
        
        //cache.clearMemoryCache()
        //cache.clearDiskCache()
        //cache.cleanExpiredDiskCache()
        fileOperation()
        self.clearLabel.text = "清理缓存(\(0)M)"
    }
    
    private func fileOperation(){
        let mgr = NSFileManager.defaultManager()
        let caches = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        do{
            try mgr.removeItemAtPath(caches!)
        }catch{}
        NSLog("%d", (caches?.fileSize())!)
    }
    
    
    //MARK: - TableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1{
            let favortiesVC = FavoritesController()
            self.navigationController?.pushViewController(favortiesVC, animated: true)
        }else if indexPath.section == 2{
            clearCache()
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    //去掉tableview分割线左边边距
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // Remove seperator inset
        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        // Explictly set your cell's layout margins
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
}


