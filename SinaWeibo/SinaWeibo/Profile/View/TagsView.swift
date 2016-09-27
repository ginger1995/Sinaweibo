//
//  TagView.swift
//  SinaWeibo
//
//  标签集View
//

import UIKit

class TagsView: UIView {

    var tags:[Tag]?{
        didSet{
            updateUI()
        }
    }
    
    
    private func updateUI(){
        
    }
    
}
