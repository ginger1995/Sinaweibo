//
//  StatusPhotoView.swift
//  新浪微博
//
//  状态图片
//

import UIKit

class StatusPhotoView: UIImageView {

    var index:Int = 0
    var status:Status?{
        didSet{
            setPhoto()
        }
    }
    
    private lazy var gifView:UIImageView = {
        let image = UIImage(named: "timeline_image_gif")
        let imageView = UIImageView(image: image!)
        self.addSubview(imageView)
        return imageView
    }()
    
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        //内容模式
        self.contentMode = .ScaleAspectFill
        //超出边框的内容裁剪
        self.clipsToBounds = true
        
        //手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(StatusPhotoView.handleTapGesture))
        tapGesture.numberOfTapsRequired = 1//单击
        self.addGestureRecognizer(tapGesture)
        
        //启用交互
        self.userInteractionEnabled = true
    }
    
    internal func handleTapGesture(){
        guard status != nil else {return}
        
        
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.StatusDidPhotoClickNotification, object: nil, userInfo: [Notification.StatusPhotos:status!,Notification.StatusPhotosIndex:index])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gifView.x = self.width - self.gifView.width
        gifView.y = self.height - self.gifView.height
    }
    
    func setPhoto(){
         guard let photos = status?.pic_urls else {return}
        
        let photo = photos[index]
        let url = NSURL(string: photo.thumbnail_pic!)
        self.kf_setImageWithURL(url!, placeholderImage: UIImage(named: "timeline_image_placeholder"))
        self.gifView.hidden = !photo.thumbnail_pic!.lowercaseString.hasSuffix("gif")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
