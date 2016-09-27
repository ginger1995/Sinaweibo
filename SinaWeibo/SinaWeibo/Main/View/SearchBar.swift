//
//  SearchBar.swift
//  新浪微博
// 搜索框
//

import UIKit

class SearchBar: UITextField{

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont.systemFontOfSize(15)
        self.placeholder = "请输入搜索条件"
        self.background = UIImage(named: "searchbar_textfield_background")
        
        //通过init来创建初始化绝大部分控件,控件都是没有尺寸
        let searchIcon = UIImageView()
        searchIcon.image = UIImage(named: "searchbar_textfield_search_icon")
        searchIcon.width = 30
        searchIcon.height = 30
        searchIcon.contentMode = UIViewContentMode.Center
        self.leftView = searchIcon
        self.leftViewMode = UITextFieldViewMode.Always
    }
    
    class func searchBar() -> UITextField{
        return SearchBar()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
