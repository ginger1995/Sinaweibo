//
//  AnimatedTransitioning.swift
//  SinaWeibo
//
//

import UIKit

class AnimatedTransitioning: NSObject,UIViewControllerAnimatedTransitioning {

    var presented:Bool = true
    private let duration:NSTimeInterval = 0.3
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if self.presented {
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
            // toView!.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI_2), 1, 1, 0);
            //        toView.y = -toView.height;
            //toView.y = -toView.height;
            toView?.alpha = 0
            UIView.animateWithDuration(duration, animations: { () -> Void in
                //toView.y = 0;
                toView?.alpha = 1
                }, completion: { (finished) -> Void in
                    transitionContext.completeTransition(true) //告诉transitionContext动画已经结束
            })
        }else{
            UIView.animateWithDuration(duration, animations: { () -> Void in
                let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
                fromView?.alpha = 0
                }, completion: { (finished) -> Void in
                    transitionContext.completeTransition(true)
            })
        }
    }

}
