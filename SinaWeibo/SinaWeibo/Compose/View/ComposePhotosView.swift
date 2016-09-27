//
//  ComposePhotosView.swift
//  新浪微博
//
//

import UIKit

class ComposePhotosView: UIView {

    var photos:NSMutableArray?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        photos = NSMutableArray()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addPhoto(photo:UIImage){
        let photoView = UIImageView()
        photoView.image = photo
        self.addSubview(photoView)
        self.photos?.addObject(photo)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //设置图片的尺寸和位置
        let count = self.subviews.count
        let maxCol = 4
        let imageWH:CGFloat = 70
        let imageMargin:CGFloat = 10
        
        for i in 0 ..< count {
            
            let photoView = self.subviews[i] as! UIImageView
            
            let col = i % maxCol
            photoView.x = CGFloat(col) * (imageWH + imageMargin) + imageMargin
            
            let row = i / maxCol
            photoView.y = CGFloat(row) * (imageWH + imageMargin)
            photoView.width = imageWH
            photoView.height = imageWH
            
        }
    }

}
