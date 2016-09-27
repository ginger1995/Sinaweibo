//
//  PhotosPageController.swift
//  SinaWeibo
//
//  图片浏览器
//

import UIKit

class PhotosPageController: UIViewController, UIPageViewControllerDataSource ,UIViewControllerTransitioningDelegate{

    //图片集
    var status:Status!
    //当前页码
    var index:Int?
    
    private var pageViewController:UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //水平滚动
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController.dataSource = self
        //self.pageViewController.set
        
        //设置辅助控制器
        let initialContentViewController = pageTutorialAtIndex(index!)
        //设置始起页
        self.pageViewController.setViewControllers([initialContentViewController], direction: .Forward, animated: true, completion: nil)
        
        
        //向视图控制器容器中添加子视图控制器
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["view":self.pageViewController.view]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["view":self.pageViewController.view]))
        
        //添加手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotosPageController.handleTapGesture))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    internal func handleTapGesture(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    private func pageTutorialAtIndex(index:Int) -> TutorialPhotosPageController{
        let pageContentViewController = TutorialPhotosPageController()
        pageContentViewController.pageIndex = index
        
        let pageImages = status.pic_urls!
        let thumbnail_pic = pageImages[index].thumbnail_pic!
        
        let bmiddle_pic = status.bmiddle_pic!
        
        let lastStr = thumbnail_pic.substringFromIndex(thumbnail_pic.rangeOfString("thumbnail")!.endIndex)
        let startStr = bmiddle_pic.substringToIndex(bmiddle_pic.rangeOfString("bmiddle")!.endIndex)
        
        //合拼字符
        let newUrl = startStr + lastStr
        
        pageContentViewController.pageImage = newUrl
        return pageContentViewController
    }
    
    //MARK:- UIPageViewControllerDataSource
    
    //向上一页
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let viewController = viewController as! TutorialPhotosPageController
        var index = viewController.pageIndex as Int
        
        if index == 0 || index == NSNotFound {return nil}
        index -= 1
        
        return self.pageTutorialAtIndex(index)
    }
    
    //向后一页
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let viewController = viewController as! TutorialPhotosPageController
        var index = viewController.pageIndex as Int
        
        if(index == NSNotFound){return nil}
        
        index += 1
        let pageImages = status.pic_urls
        if(index == pageImages!.count){return nil}
        
        return self.pageTutorialAtIndex(index)
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        let pageImages = status.pic_urls
        return pageImages!.count
    }
    
    //设置当前页
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return index == nil ? 0 : index!
    }
    
}
