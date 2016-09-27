//
//  PresentationController.swift
//  SinaWeibo
//
//

import UIKit

class PresentationController: UIPresentationController {
    
    //控制器大小
    /// override func frameOfPresentedViewInContainerView() -> CGRect {
    ////    return CGRectMake(0, 50, self.containerView.frame.size.width, self.containerView.frame.size.height - 100);
    //    return CGRectInset(self.containerView.bounds, 0, 100);
    //}
    override func presentationTransitionWillBegin() {
        self.presentedView()?.frame = self.containerView!.bounds
        self.presentedView()?.backgroundColor = UIColor.blackColor()
        self.containerView?.addSubview(self.presentedView()!)
        
    }
    
    override func presentationTransitionDidEnd(completed: Bool) {
        NSLog("presentationTransitionDidEnd");
    }
    
    override func dismissalTransitionWillBegin() {
        NSLog("dismissalTransitionWillBegin")
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
        self.presentedView()?.removeFromSuperview()
    }
    
}
