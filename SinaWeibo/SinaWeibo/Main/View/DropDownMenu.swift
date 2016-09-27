
//
//  DropDownMenu.swift
//  新浪微博
//
//  下拉框
//

import UIKit

protocol DropdownMenuDelegate:class {
    func dropDownMenuDidDismiss(menu:DropDownMenu)
    func dropDownMenuDidShow(menu:DropDownMenu)
}

class DropDownMenu: UIView {

    weak var delegate:DropdownMenuDelegate?
    
    private lazy var containerView:UIImageView = {
        let _containerView = UIImageView()
        _containerView.image = UIImage(named: "popover_background")
        _containerView.userInteractionEnabled = true
        self.addSubview(_containerView)
        return _containerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //清除颜色
        self.backgroundColor = UIColor.clearColor()
    }
    
    
    class func menu() -> DropDownMenu{
        return DropDownMenu()
    }
    
    
    /**
    *  内容
    */
    private var content:UIView?{
        didSet{
            //调整内容的位置
            content?.x = 10
            content?.y = 15
            //设置灰色的高度
            self.containerView.height = CGRectGetMaxY(content!.frame) + 11
            //设置灰色的宽度
            self.containerView.width = CGRectGetMaxX(content!.frame) + 10
            self.containerView.addSubview(content!)
        }
    }
    /**
    *  内容控制器
    */
    var contentController:UIViewController?{
        didSet{
            self.content = contentController!.view
        }
    }
    
    //显示
    func showFrom(from:UIView){
        //获得最上面的窗口
        let window = UIApplication.sharedApplication().windows.last
        //添加自己到窗口上
        window?.addSubview(self)
        //设置尺寸
        self.frame = window!.bounds
        // 默认情况下，frame是以父控件左上角为坐标原点
        // 转换坐标系
        let newFrame = from.convertRect(from.bounds, toView: window)
        containerView.centerX = CGRectGetMidX(newFrame)
        containerView.y = CGRectGetMaxY(newFrame)
        //通知外界，自己显示
        delegate?.dropDownMenuDidShow(self)
    }
    
    func dismiss(){
        self.removeFromSuperview()
        //通知外界，自己被销毁了
        delegate?.dropDownMenuDidDismiss(self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dismiss()
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
