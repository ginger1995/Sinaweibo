//
//  StatusPhotosView.swift
//  新浪微博
//
//

import UIKit

class StatusPhotosView: UIView {
    
    var status:Status?{
        didSet{
            setPhotots()
        }
    }
    
    struct StatusPhoto {
        static let PhotoWH:CGFloat = 70
        static let Margin:CGFloat = 10
        
        static func maxCol(count:Int) -> Int{
            return count == 4 ? 2 : 3
        }
    }
    
    func setPhotots(){
        
        guard let photos = status?.pic_urls else{return}
        
        // 创建足够数量的图片控件
        // 这里的self.subviews.count不要单独赋值给其他变量
        let photosCount = photos.count
        while(self.subviews.count < photosCount){
            let photoView = StatusPhotoView(frame: CGRectZero)
            self.addSubview(photoView)
        }
        //遍历所有的图片擦伤，设置图片
        for i in 0 ..< self.subviews.count {
            let photoView = self.subviews[i] as! StatusPhotoView
            
            if i < photosCount { // 显示
                photoView.index = i
                photoView.status = status
                photoView.hidden = false
            }else{ //隐藏
                photoView.hidden = true
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let photos = status?.pic_urls
        //设置图片的尺寸和位置
        if let photosCount = photos?.count {
            let maxCol = StatusPhoto.maxCol(photosCount)
            
            for i in 0 ..< photosCount {
                let photoView = self.subviews[i] as! StatusPhotoView
                
                let col = i % maxCol
                photoView.x = CGFloat(col) * (StatusPhoto.PhotoWH + StatusPhoto.Margin)
                
                let row = i / maxCol
                photoView.y = CGFloat(row) * (StatusPhoto.PhotoWH + StatusPhoto.Margin)
                photoView.width = StatusPhoto.PhotoWH
                photoView.height = StatusPhoto.PhotoWH
            }
            
        }
    }
    
    
    
    /**
    *  根据图片个数计算相册的尺寸
    */
    class func sizeWithCount(count:Int) -> CGSize{
        //最大列数(一行最多有多少列)
        let maxCols = StatusPhoto.maxCol(count)
        
        let cols = count >= maxCols ? maxCols : count
        let photosW = CGFloat(cols) * StatusPhoto.PhotoWH + CGFloat(cols - 1) * StatusPhoto.Margin
        //行数
        let rows = (count + maxCols - 1) / maxCols
        let photosH = CGFloat(rows) * StatusPhoto.PhotoWH + CGFloat(rows - 1) * StatusPhoto.Margin
        
        return CGSizeMake(photosW, photosH)
    }
    
}
