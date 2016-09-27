//
//  DiscoverViewController.swift
//  新浪微博
//
//  发现
//

import UIKit
import CoreLocation
import MJRefresh

class DiscoverViewController: StatusViewController,CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var lat:Float?
    private var long:Float?
    private var page = 1
    
    /**
     *  地理编码对象
     */
    lazy var geocoder:CLGeocoder = {
        let geo = CLGeocoder()
        return geo
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 集成下拉刷新控件
        setupDownRefresh()
        //集成上拉刷新控件
        setUpUpRefresh()

        locationManager.delegate=self
        //设置定位进度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //发送授权申请
        locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            //允许使用定位服务的话，开启定位服务更新
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (CLLocationManager.locationServicesEnabled())
        {
            //允许使用定位服务的话，开启定位服务更新
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
    }
    // 集成下拉刷新控件
    override func setupDownRefresh(){
        //        //添加控件
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
                if (CLLocationManager.locationServicesEnabled())
                {
                    //允许使用定位服务的话，开启定位服务更新
                    self.locationManager.startUpdatingLocation()
                    print("定位开始")
                }
            })
        self.tableView.mj_header.beginRefreshing()
    }
    
    //设置搜索
    private func setSearch(){
        let searchBar = SearchBar.searchBar()
        searchBar.width = 300
        searchBar.height = 30
        self.navigationItem.titleView = searchBar
    }
    
    
    //加载最新微博
    private func loadNewStatus(lat:Float,long:Float) {
        var params = [String:AnyObject]()
        
        guard let account = AccountTool.account() else{
            self.tableView.mj_header.endRefreshing()
            return
        }
        
        params["access_token"] = account.access_token
        params["lat"] = lat
        params["long"] = long
        
        HttpTool.get(XLMess.Discover_PlaceStatus_Url, params: params, success: { (dict) in
            if dict["error"] != nil{
                print(dict["error"])
                self.tableView.mj_header.endRefreshing()
                return
            }
            guard let array = dict["statuses"] as? [AnyObject] else{
                self.tableView.mj_header.endRefreshing()
                return
            }
        
            // 将 "微博字典"数组 转为 "微博模型"数组
            let newStatuses = Status.statusWithArr(array)
            let newFrames = StatusFrame.statusFramesWithStatuses(newStatuses)
            
            self.list = newFrames
            self.page = 1
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            }) { (error) in
                 self.tableView.mj_header.endRefreshing()
        }
    }
    
    //上拉加载更多微博数据
    override func loadMoreStatus(){
        
        guard let account = AccountTool.account() else{
            
            self.tableView.mj_footer.endRefreshing()
            return
        }
        
        self.page += 1
        guard lat != nil && long != nil else{
            self.tableView.mj_footer.endRefreshing()
            return
        }
        //拼接请求参数
        var params = [String:AnyObject]()
        params["access_token"] = account.access_token
        params["lat"] = lat
        params["long"] = long
        //取出最后面的微博
        params["page"] = page
        
        let url = XLMess.Discover_PlaceStatus_Url
        HttpTool.get(url, params: params, success: { (dict) in
            if dict["error"] != nil{
                print(dict["error"])
                self.page -= 1
                self.tableView.mj_footer.endRefreshing()
                return
            }
            
            //数据转模型
            guard let array = dict["statuses"] as? [AnyObject] else{
                self.tableView.mj_footer.endRefreshing()
                self.page -= 1
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
    
    //MARK: - CLLocationManagerDelegate
    
    //地理定位
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation=locations[locations.count-1]
        
        if (location.horizontalAccuracy>0){
            self.lat = NSNumber(double: location.coordinate.latitude).floatValue
            self.long = NSNumber(double: location.coordinate.longitude).floatValue
            print(lat)
            print(long)
            loadNewStatus(lat!, long: long!)
            
            let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            //根据CLLocation对象获取对应的地标信息
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
                
                if placemarks == nil || error != nil{
                    print(placemarks)
                    return
                }
                
                //placemark.name, placemark.addressDictionary
                let placemark = placemarks!.first
                
                let dict = placemark!.addressDictionary
                print(dict)
                
                MessageTool.showText(placemark?.name)
//                let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default){
//                    (action: UIAlertAction!) -> Void in
//                    print("you choose ok")
//                }
//                
//                let alertController = UIAlertController(title: "你现在的位置", message: placemark?.name, preferredStyle: .Alert)
//                alertController.addAction(okAction)
//                self.presentViewController(alertController, animated: true, completion: nil)

                
            }
            
            locationManager.stopUpdatingLocation()//结束定位
        }
    }

    //打印地理定位出错
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        //println(1111)
        self.tableView.mj_header.endRefreshing()
        print(error)
        
    }

}
