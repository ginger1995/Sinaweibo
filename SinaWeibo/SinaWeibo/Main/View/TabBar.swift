//
//  TabBar.swift
//  新浪微博
//
//  TabController中间加号
//

import UIKit

protocol TabBarDelegate:UITabBarDelegate{
    func tabBarDidClickPlusButton(tabBar:TabBar)
}

//因为HWTabBar继承自UITabBar，所以称为HWTabBar的代理，也必须实现UITabBar的代理协议
class TabBar: UITabBar{
 
    var plusBtn:UIButton!
    weak var tabDelegate:TabBarDelegate?
    
    override init(frame:CGRect){
        super.init(frame:frame)
        
        //添加一个按钮到tabbar中
        plusBtn = UIButton()
        
        //背景背景
        plusBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        plusBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        //设置图片
        plusBtn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        plusBtn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        //等于当前背景图片尺寸
        plusBtn.size = plusBtn.currentBackgroundImage!.size
        plusBtn.addTarget(self, action: #selector(TabBar.plusClick), forControlEvents: .TouchUpInside)
        self.addSubview(plusBtn)
    }
    /**
    *  加号按钮点击
    */
    func plusClick(){
        //通知代理
        tabDelegate?.tabBarDidClickPlusButton(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //1.设置加号位置
        self.plusBtn.centerX = self.width * 0.5
        self.plusBtn.centerY = self.height * 0.5
        
        //2.设置其他tabbarButton的位置和尺寸
        let tabBarButtonW = self.width / 5
        var tabBarButtonIndex:Int = 0
        
        //设置当前系统默认的UITabBarButton
        for child in self.subviews{
            let clazz:AnyClass = NSClassFromString("UITabBarButton")!
            if child.isKindOfClass(clazz){
                child.width = tabBarButtonW
                child.x = CGFloat(tabBarButtonIndex) * tabBarButtonW
                tabBarButtonIndex += 1 //增加索引
                if tabBarButtonIndex == 2{
                    tabBarButtonIndex += 1
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}
