//
//  TutorialPhotosPageController.swift
//  SinaWeibo
//
//  图片浏览器辅助页
//

import UIKit
import Kingfisher

class TutorialPhotosPageController: UIViewController {

   
    private var photoView:PhotoScrollView!
    
    //页码
    var pageIndex:Int!
    //图片地址
    var pageImage:String?{
        didSet{
            photoView.pageImage = pageImage
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        photoView = PhotoScrollView()
        photoView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(photoView)
        //水平撑两边
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["scrollView":photoView]))
        //垂直撑两边
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["scrollView":photoView]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        
    }
    
}
