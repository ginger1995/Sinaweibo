//
//  UIView+Extension.swift
//  新浪微博
//
//

import UIKit

extension UIView {
    var x:CGFloat{
        get{return self.frame.origin.x}
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    var y:CGFloat{
        get{return self.frame.origin.y}
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    var centerX:CGFloat{
        get{return self.center.x}
        set{
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }
    var centerY:CGFloat{
        get{return self.center.y}
        set{
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }
    var width:CGFloat{
        get{return self.frame.size.width}
        set{
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    var height:CGFloat{
        get{return self.frame.size.height}
        set{
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    var size:CGSize{
        get{return self.frame.size}
        set{
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    var origin:CGPoint{
        get{return  self.frame.origin}
        set{
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
}
