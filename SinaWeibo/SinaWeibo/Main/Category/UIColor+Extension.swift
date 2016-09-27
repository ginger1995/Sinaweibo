//
//  UIColor+Extension.swift
//  新浪微博
//
//

import UIKit

extension UIColor {
    
    class func color(red:CGFloat,_ green:CGFloat,_ blue:CGFloat) -> UIColor{
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
    class func color(red:CGFloat, _ green:CGFloat,_ blue:CGFloat,_ alpha:CGFloat) -> UIColor{
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}
