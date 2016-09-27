//
//  EmotionListView.swift
//  新浪微博
//
//

import UIKit

struct EmotionList {
    static let EmotionMaxRows = 3 // 一页中最多3行
    static let EmotionMaxCols = 7 // 一行中最多7列
    // 每一页的表情个数
    static func emotionPageSize() -> Int{
        return EmotionMaxRows * EmotionMaxCols - 1
    }
    
}

class EmotionListView: UIView {
    
    private var scrollView:UIScrollView!
    private var pageControl:UIPageControl!
    /** 表情(里面存放的HWEmotion模型) */
    var emotions:NSArray?{
        didSet{
            //删除之前的控件
            for item in scrollView.subviews{
                item.removeFromSuperview()
            }
            
            let count = (emotions!.count + EmotionList.emotionPageSize() - 1) / EmotionList.emotionPageSize()
            //设置页数
            self.pageControl.numberOfPages = count
            
            //创建用来显示第一页表情的控件
            for i in 0 ..< count {
                let pageView = EmotionPageView()
                //计算这一页的表情范围
                let startIndex = i * EmotionList.emotionPageSize()
                //left:剩余的表情个数
                let leftCount = emotions!.count - startIndex
                var endIndex = 0
                if leftCount >= EmotionList.emotionPageSize(){//这一页足够20个
                    endIndex = EmotionList.emotionPageSize()
                }else{
                    endIndex = leftCount
                }
                //设置这一页的表情
                let range = NSMakeRange(startIndex, endIndex)
                pageView.emotions = emotions!.subarrayWithRange(range)
                self.scrollView.addSubview(pageView)
            }
            
            self.setNeedsLayout()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //UIScollView
        self.backgroundColor = UIColor.whiteColor()
        scrollView = UIScrollView()
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        //去水平滚动条
        scrollView.showsHorizontalScrollIndicator = false
        //去垂直滚动条
        scrollView.showsVerticalScrollIndicator = false
        self.addSubview(scrollView)
        
        //pageControl
        pageControl = UIPageControl()
        //只有1页时，自动隐藏pageControl
        pageControl.hidesForSinglePage = true
        pageControl.userInteractionEnabled = false
        //设置内部的圆点图片
        pageControl.setValue(UIImage(named: "compose_keyboard_dot_normal"), forKeyPath: "pageImage")
        pageControl.setValue(UIImage(named: "compose_keyboard_dot_selected"), forKeyPath: "currentPageImage")
        self.addSubview(pageControl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //pageControl
        pageControl.width = self.width
        pageControl.height = 25
        pageControl.x = 0
        pageControl.y = self.height - self.pageControl.height
        
        //scrollView
        scrollView.width = self.width
        scrollView.height = self.height
        scrollView.x = 0
        scrollView.y = 0
        
        //设置scrollView内部每一页的尺寸
        let count = self.scrollView.subviews.count
        for i in 0 ..< count {
            let pageView = scrollView.subviews[i] as! EmotionPageView
            pageView.height = scrollView.height
            pageView.width = scrollView.width
            pageView.x = pageView.width * CGFloat(i)
            pageView.y = 0
        }
        
        //设置scrollView的contentSize
        scrollView.contentSize = CGSizeMake(CGFloat(count) * scrollView.width, 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UIScrollViewDelegate
extension EmotionListView:UIScrollViewDelegate{
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageNum = scrollView.contentOffset.x / scrollView.width
        self.pageControl.currentPage = Int(pageNum + 0.5)
    }
}
