//
//  UIImage+Extension.swift
//  SinaWeibo
//
//

import UIKit

extension UIImage {
    
    //图片等比例压缩
    class func imageWithImageSimple(image:UIImage,scaledToSize newSize:CGSize)->UIImage
    {
        var width:CGFloat!
        var height:CGFloat!
        //等比例缩放
        if image.size.width/newSize.width >= image.size.height / newSize.height{
            width = newSize.width
            height = image.size.height / (image.size.width/newSize.width)
        }else{
            height = newSize.height
            width = image.size.width / (image.size.height/newSize.height)
        }
        let sizeImageSmall = CGSizeMake(width, height)
        //end
        print(sizeImageSmall)
        
        UIGraphicsBeginImageContext(sizeImageSmall);
        image.drawInRect(CGRectMake(0,0,sizeImageSmall.width,sizeImageSmall.height))
        let newImage:UIImage=UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
    //保持比例
    var aspectRatio: CGFloat{
        return size.height != 0 ? size.width / size.height: 0 //返回宽除以高 如果为0直接返回
    }

}
