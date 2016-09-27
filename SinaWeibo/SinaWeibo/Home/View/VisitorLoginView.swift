//
//  VisitorLoginView.swift
//  SinaWeibo
//
//

import UIKit

protocol VisitorLoginViewDelegate:class {
    //协议方法
    //登录
    func visitorDidLogin()
    //注册
    func visitorDidRegister()
}

class VisitorLoginView: UIView {
    
    //声明代理属性
    weak var visitorDelegate: VisitorLoginViewDelegate?
    
    @objc func loginBtnDidClick (){
        //代理调用协议方法
        visitorDelegate?.visitorDidLogin()
    }
    
    @objc func registerBtnDidClick(){
        visitorDelegate?.visitorDidRegister()
    }

    //MARK :设置页面信息的方法
    private func setUIInfo(imageName:String?, title: String) {
        iconView.hidden = false
        tipLabel.text = title
        if imageName != nil{
            circleView.image = UIImage(named: imageName!)
            bringSubviewToFront(circleView)
            iconView.hidden = true
        }else{
            //让circleView动起来
            startAnimation()
        }
        
    }
    
    private func startAnimation(){
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.repeatCount = MAXFLOAT
        anim.toValue = 2 * M_PI
        anim.duration = 10
        anim.removedOnCompletion = false
        circleView.layer.addAnimation(anim, forKey: nil)
    }
    
    //MARK :重写构造方法
    init(){
        super.init(frame: CGRectZero)
        setupUI()
        setUIInfo(nil, title: "请登录您的账号，回这里看看有什么惊喜")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: 设置访客视图
    private func setupUI(){
        
        
        self.backgroundColor = UIColor.color(204, 204, 204)
        addSubview(circleView)
//        addSubview(backView)
        addSubview(iconView)
        addSubview(tipLabel)
        addSubview(loginBtn)
        addSubview(registerBtn)
        
        //设置frame布局失效
        for v in subviews{
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        //设置布局 VFL
        //圆圈的约束
        addConstraint(NSLayoutConstraint(item: circleView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: circleView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: -50))
        //大图标的约束
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .CenterX, relatedBy: .Equal, toItem: circleView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .CenterY, relatedBy: .Equal, toItem: circleView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        //设置提示文本的约束
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .CenterX, relatedBy: .Equal, toItem: circleView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .Top, relatedBy: .Equal, toItem: circleView, attribute: .Bottom, multiplier: 1.0, constant: 16))
        //设置文本宽度约束
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 224))
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 50))
        //设置登录按钮约束
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: .Left, relatedBy: .Equal, toItem: tipLabel, attribute: .Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: .Top, relatedBy: .Equal, toItem: tipLabel, attribute: .Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 35))
        //设置注册按钮约束
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: .Right, relatedBy: .Equal, toItem: tipLabel, attribute: .Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: .Top, relatedBy: .Equal, toItem: tipLabel, attribute: .Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 35))
        //设置背景视图的约束
//        addConstraint(NSLayoutConstraint(item: backView, attribute: .CenterX, relatedBy: .Equal, toItem: circleView, attribute: .CenterX, multiplier: 1.0, constant: 0))
//        addConstraint(NSLayoutConstraint(item: backView, attribute: .CenterY, relatedBy: .Equal, toItem: circleView, attribute: .CenterY, multiplier: 1.0, constant: 0))
   
//        addConstraints( NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[backView]-0-|", options: [], metrics: nil, views: ["backView":backView]))
//        
//        addConstraints( NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[backView]-(-45)-[registerBtn]", options: [], metrics: nil, views: ["backView":backView, "registerBtn":registerBtn]))
        //设置背景颜色
            backgroundColor = UIColor(white: 0.93, alpha: 1)
        
        //添加按钮的点击事件
        loginBtn.addTarget(self, action: #selector(VisitorLoginView.loginBtnDidClick), forControlEvents: .TouchUpInside)
        registerBtn.addTarget(self, action: #selector(VisitorLoginView.registerBtnDidClick), forControlEvents: .TouchUpInside)
    }

    //MARK: 懒加载所有的控件
    private lazy var circleView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    //提示文本
    private lazy var tipLabel: UILabel = {
       let l = UILabel()
        l.text = "关注一些人，回这里看看有什么惊喜关注一些人，回这里看看有什么惊喜"
        l.textAlignment = NSTextAlignment.Center
        l.font = UIFont.systemFontOfSize(14)
        l.textColor = UIColor.lightGrayColor()
        l.sizeToFit()
        l.numberOfLines = 0
        return l
    }()
    
    //登录注册按钮
    private lazy var loginBtn:UIButton = {
       let btn = UIButton()
       
        btn.setTitle("登录", forState: .Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: .Normal)
        btn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        return btn
    }()
    
    private lazy var registerBtn:UIButton = {
        let btn = UIButton()
        
        btn.setTitle("注册", forState: .Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: .Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        return btn
    }()
}