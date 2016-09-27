//
//  PhotoScrollView.swift
//  SinaWeibo
//
//

import UIKit

class PhotoScrollView: UIView,UIScrollViewDelegate{
    
    var pageImage:String?{
        didSet{
            updateUI()
        }
    }

    private var imageView:UIImageView!
    
    private var scrollView:UIScrollView!
  
    
    private func updateUI(){
        guard let url = NSURL(string: pageImage!) else{return}
        imageView.kf_setImageWithURL(url, placeholderImage: UIImage(named: "timeline_image_placeholder"),completionHandler: {(image, error, cacheType, imageURL) -> () in
            guard image != nil else{return}
            
            //重新绘制
            self.setNeedsLayout()
        })
        
    }
    
    //布局最好写在 layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        print("layoutSubviews")
        
        guard let imageSize = imageView.image?.size else{return}
        
        let SW = self.bounds.size.width
        let SH = self.bounds.size.height
        
        let imageViewH = SW / imageSize.width * imageSize.height
        
        self.imageView.frame.size = CGSizeMake(SW, imageViewH)
        
        if imageViewH >= SH{
            imageView.contentMode = .ScaleAspectFill
            self.imageView.frame.origin = CGPointMake(0, 0)
            scrollView.contentSize = CGSizeMake(SW, imageViewH)
        }else{
            
            imageView.contentMode = .ScaleAspectFit
            self.imageView.frame = self.bounds
            scrollView.contentSize = CGSizeZero
        }
        
    }

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.blackColor()
        //取消弹簧效果
        scrollView.bounces = false
        scrollView.bouncesZoom = true
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 1.0 //最小比例
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.scrollsToTop = true //主要用于点击设备的状态栏时，是scrollsToTop == true的控件滚动返回至顶部
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["scrollView":scrollView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["scrollView":scrollView]))
        
        
        imageView = UIImageView()
        self.imageView.userInteractionEnabled = true
        scrollView.addSubview(imageView)
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UIScrollViewDelegate
    //scroll view处理缩放和平移手势，必须需要实现委托下面两个方法,另外 maximumZoomScale和minimumZoomScale两个属性要不一样
    //1.返回要缩放的图片
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
//    func scrollViewDidZoom(scrollView: UIScrollView) {
//        
//        let scale = scrollView.zoomScale
//        let imageHeight = imageView.width * scale / imageView.image!.size.width * imageView.image!.size.height
//        
//        scrollView.contentSize = CGSizeMake(imageView.width * scale, imageHeight)
//        
//        let contentSize = scrollView.contentSize
//        var centerPoint = CGPointMake(contentSize.width / 2, contentSize.height / 2)
//        if imageView.width <= scrollView.width{
//            centerPoint.x = scrollView.width / 2
//        }
//        if imageView.height<=scrollView.height {
//            centerPoint.y = scrollView.height / 2
//        }
//        imageView.center = centerPoint
//    }
//    
  
}
