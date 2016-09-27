//
//  TabBarViewController.swift
//  新浪微博
//
//  自定义TabBarConroller
//

import UIKit



class TabBarViewController: UITabBarController,TabBarDelegate,UITabBarControllerDelegate{

    private var homeVC:HomeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        //1.初始化子控制器
        
        //首页
        homeVC = HomeViewController()
        addChildVC(homeVC, title: "首页", image: "tabbar_home", selectedImage: "tabbar_home_selected")
        
        //消息
        let messageCenterVC = MessageCenterViewController()
        addChildVC(messageCenterVC, title: "消息", image: "tabbar_message_center", selectedImage: "tabbar_message_center_selected")
        //发现
        let discoverVC = DiscoverViewController()
        addChildVC(discoverVC, title: "发现", image: "tabbar_discover", selectedImage: "tabbar_discover_selected")
        //个人
        let profileVC = UIStoryboard(name: "Prefile", bundle: NSBundle.mainBundle()).instantiateInitialViewController()
        addChildVC(profileVC!, title: "我", image: "tabbar_profile", selectedImage: "tabbar_profile_selected")
        //更换系统自带的tabbar
        let tabBar = TabBar()
        tabBar.tabDelegate = self
        self.setValue(tabBar, forKey: "tabBar")
        
    }

  
    /**
    *  添加一个子控制器
    *
    *  param childVc       子控制器
    *  param title         标题
    *  param image         图片
    *  param selectedImage 选中的图片
    */
    func addChildVC(childVC:UIViewController,title:String,image:String,selectedImage:String){
        //设置子控制器的文字
        childVC.title = title // 同时设置tabbar和navigationBar的文字
        childVC.view.backgroundColor = UIColor.whiteColor()
        //设置子控制器的图片
        childVC.tabBarItem.image = UIImage(named: image)
        childVC.tabBarItem.selectedImage = UIImage(named: selectedImage)?.imageWithRenderingMode(.AlwaysOriginal)
        //设置文字的样式
        var textAttrs = [String:AnyObject]()
        textAttrs[NSForegroundColorAttributeName] = UIColor.blueColor()//颜色
        var selectTextAtters = [String:AnyObject]()
        selectTextAtters[NSForegroundColorAttributeName] = UIColor.orangeColor()
        childVC.tabBarItem.setTitleTextAttributes(textAttrs, forState: .Normal)//正常状态
        childVC.tabBarItem.setTitleTextAttributes(selectTextAtters, forState: .Selected)//选中状态
        //先给外面传进来的小控制器包装一个导航控制器
        let nav = NavigationViewController(rootViewController: childVC)
        //添加子控制器
        self.addChildViewController(nav)
    }
    
    func tabBarDidClickPlusButton(tabBar: TabBar) {
        let composeVC = ComposeViewController()
        let nav = NavigationViewController(rootViewController:composeVC)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    
    //MARK: - UITabBarControllerDelegate
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        let index = tabBarController.selectedIndex
        switch index {
        case 0:
            homeVC.refresh()
            break
        default:
            break
        }
    }
    
}
