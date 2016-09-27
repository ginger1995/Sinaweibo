//
//  LoadMoreFooter.swift
//  新浪微博
//
//

import UIKit

class LoadMoreFooter: UIView {

    class func footer() -> UILabel{
        let label = UILabel()
        label.text = "正在刷新..."
        label.textAlignment = .Center
        label.height = 30
        return label
    }
}
