//
//  NewfeatureViewController.swift
//  新浪微博
//  新特性
//

import UIKit

class NewfeatureViewController: UIViewController,UIScrollViewDelegate {

    var pageControl:UIPageControl!
    var scrollView:UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //创建一个scrollView:显示所有的亲特性图片
        scrollView = UIScrollView()
        scrollView.frame = self.view.bounds
        self.view.addSubview(scrollView)
        
        //添加图片到scrollView中
        let scrollW = scrollView.width
        let scrollH = scrollView.height
        for i in 0 ..< NewFeature.Count{
            let imageView = UIImageView()
            imageView.width = scrollW
            imageView.height = scrollH
            imageView.y = 0
            imageView.x = CGFloat(i) * scrollW
            //显示图片
            let name = String(format: "new_feature_%d", arguments: [i+1])
            imageView.image = UIImage(named: name)
            scrollView.addSubview(imageView)
            //如果是最后一个imageView,就往解放里面添加其他内容
            if i == NewFeature.Count - 1{
                setupLastImageView(imageView)
            }
        }
        
//         默认情况下，scrollView一创建出来，它里面可能就存在一些子控件了
//         就算不主动添加子控件到scrollView中，scrollView内部还是可能会有一些子控件
        
        //设置scrollView的其他属性
        //如果想要某个方向上不能流动，那么这个方向对应的尺寸数值传0即可
        scrollView.contentSize = CGSizeMake(CGFloat(NewFeature.Count) * scrollW, 0)
        scrollView.bounces = false //去除弹簧效果
        scrollView.pagingEnabled = true//翻页
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        //添加pageControl分页
        pageControl = UIPageControl()
        
        pageControl.numberOfPages = NewFeature.Count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.color(253, 98, 42)
        pageControl.pageIndicatorTintColor = UIColor.color(189, 189, 189)
        pageControl.centerX = scrollW * 0.5
        pageControl.centerY = scrollH - 50
        
        self.view.addSubview(pageControl)
    }
    
    struct NewFeature {
        static let Count = 4//图片个数
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.width
        self.pageControl.currentPage = Int(page + 0.5)
    }
    
    func setupLastImageView(imageView:UIImageView){
        //开启交互功能
        imageView.userInteractionEnabled = true
        //分享给大家
        let shareBtn = UIButton()
        shareBtn.setImage(UIImage(named: "new_feature_share_false"), forState: UIControlState.Normal)
        shareBtn.setImage(UIImage(named: "new_feature_share_true"), forState: UIControlState.Selected)
        shareBtn.setTitle("分享给大家", forState: UIControlState.Normal)
        shareBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        //shareBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        shareBtn.width = 200
        shareBtn.height = 30
        shareBtn.centerX = imageView.width / 2
        shareBtn.centerY = imageView.height * 0.65
        shareBtn.addTarget(self, action: #selector(NewfeatureViewController.shareClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        imageView.addSubview(shareBtn)
        //    shareBtn.backgroundColor = [UIColor redColor];
        //    shareBtn.imageView.backgroundColor = [UIColor blueColor];
        //    shareBtn.titleLabel.backgroundColor = [UIColor yellowColor];
        
        // top left bottom right
        
        // EdgeInsets: 自切
        // contentEdgeInsets:会影响按钮内部的所有内容（里面的imageView和titleLabel）
        //    shareBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 100, 0, 0);
        
        // titleEdgeInsets:只影响按钮内部的titleLabel
        shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        // imageEdgeInsets:只影响按钮内部的imageView
        //    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 50);
        
        
        
        //    shareBtn.titleEdgeInsets
        //    shareBtn.imageEdgeInsets
        //    shareBtn.contentEdgeInsets
        
        //开始微博
        let startBtn = UIButton()
        startBtn.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        startBtn.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        startBtn.size = startBtn.currentBackgroundImage!.size
        startBtn.centerX = shareBtn.centerX
        startBtn.centerY = imageView.height * 0.75
        startBtn.setTitle("开始微博", forState: UIControlState.Normal)
        startBtn.addTarget(self, action: #selector(NewfeatureViewController.startClick), forControlEvents: UIControlEvents.TouchUpInside)
        imageView.addSubview(startBtn)
    }
    
    func shareClick(sender:UIButton){
        sender.selected = !sender.selected
    }
    
    func startClick(){
        // 切换到HWTabBarController
        /*
        切换控制器的手段
        1.push：依赖于UINavigationController，控制器的切换是可逆的，比如A切换到B，B又可以回到A
        2.modal：控制器的切换是可逆的，比如A切换到B，B又可以回到A
        3.切换window的rootViewController
        */
            // modal方式，不建议采取：新特性控制器不会销毁
        let window  = UIApplication.sharedApplication().keyWindow
        window?.rootViewController = TabBarViewController()
        
    }
    
    deinit{
        NSLog("销毁")
    }

}
