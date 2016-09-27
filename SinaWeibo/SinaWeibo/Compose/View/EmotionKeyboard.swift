//
//  EmotionKeyboard.swift
//  新浪微博
//
//

import UIKit

class EmotionKeyboard: UIView {

    /** 保存正在显示listView */
    private var showingListView:EmotionListView?
    /** 表情内容 */
    private lazy var recentListView:EmotionListView = {
        let view = EmotionListView()
        //加载沙盒中的数据
        view.emotions = EmotionTool.recentEmotions
        return view
    }()
    
    private lazy var defaultListView:EmotionListView = {
        let view = EmotionListView()
        view.emotions = EmotionTool.defaultEmotions
        return view
    }()
    
    private lazy var emojiListView:EmotionListView = {
        let view = EmotionListView()
        view.emotions = EmotionTool.emoji
        return view
    }()
    
    private lazy var lxhListView:EmotionListView = {
        let view = EmotionListView()
        view.emotions = EmotionTool.lxh
        return view
    }()
    /** tabbar */
    private var tabBar:EmotionTabBar!
    
    private var notificationCenter:NSNotificationCenter{
        get{return NSNotificationCenter.defaultCenter()}
    }
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tabBar = EmotionTabBar()
        tabBar.delegate = self
        self.addSubview(tabBar)
        
        //表情选中的通知
        notificationCenter.addObserver(self, selector: #selector(EmotionKeyboard.emotionDidSelect), name: Notification.EmotionDidSelectNotification, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func emotionDidSelect(){
        print("选中")
        recentListView.emotions = EmotionTool.recentEmotions
    }
    
    deinit{
        notificationCenter.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //1.tabbar
        tabBar.width = self.width
        tabBar.height = 37
        tabBar.x = 0
        tabBar.y = self.height - self.tabBar.height
        
        //表情内容
        showingListView?.x = 0
        showingListView?.y = 0
        showingListView?.width = self.width
        showingListView?.height = tabBar.y
    }

}

//MARK: - EmotionTabBarDelegate
extension EmotionKeyboard:EmotionTabBarDelegate{
    
    func emotionTabBar(tabBar: EmotionTabBar, buttonType: EmotionTabBarButtonType) {
        //移除正在显示的listView控件
        showingListView?.removeFromSuperview()
        
        //根据按钮类型，切换键盘上面的listview
        switch buttonType{
        case.Recent: //最近
            self.addSubview(recentListView)
            break
        case .Default: //默认
            self.addSubview(defaultListView)
            break
        case .Emoji: //Emoji
            self.addSubview(emojiListView)
            break
        case .Lxh: //浪小花
            self.addSubview(lxhListView)
            break
        }
        
        //设置正在显示的listView
        self.showingListView = self.subviews.last as? EmotionListView
        
        //设置frame
        self.setNeedsLayout()
    }
}
