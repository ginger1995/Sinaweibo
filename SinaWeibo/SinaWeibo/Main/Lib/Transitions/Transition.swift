//
//  Transition.swift
//  SinaWeibo
//
//

import UIKit

class Transition: NSObject,UIViewControllerTransitioningDelegate {

    class var sharedInstance:Transition{
        struct Static {
            static var onceToke:dispatch_once_t = 0
            static var instance:Transition? = nil
        }
        dispatch_once(&Static.onceToke){
            Static.instance = Transition()
        }
        return Static.instance!
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented,presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let anim = AnimatedTransitioning()
        anim.presented = true
        return anim
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let anim = AnimatedTransitioning()
        anim.presented = false
        return anim
    }
    
    
}
