//
//  TextViewController.swift
//  SinaWeibo
//
//  富文本输入控制器，供子类继承
//

import UIKit

class TextViewController: ViewController {

    /** 是否正在切换键盘 */
    var switchingKeyboard = false
    /** 输入控件 */
    var textView:EmotionTextView!
    /** 键盘顶部的工具条 */
    var toolbar:ComposeToolbar!
    /** 表情键盘 */
    private lazy var emotionKeyboard:EmotionKeyboard = {
        let _emotionkeyboard = EmotionKeyboard()
        //键盘高宽
        _emotionkeyboard.width = self.view.width
        _emotionkeyboard.height = 216
        return _emotionkeyboard
    }()
    
    var prefix:String = ""
   
    //通知中心
    private var notificationCter:NSNotificationCenter{
        get{return NSNotificationCenter.defaultCenter()}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        // 设置导航栏内容
        setupNav()
        //添加输入控件
        setupTextView()
        //添加工具条
        setupTooBar()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 成为第一响应者（能输入文本的控件一旦成为第一响应者，就会叫出相应的键盘）
        textView.becomeFirstResponder()
    }
    
    deinit{
        //移除通知中心
        notificationCter.removeObserver(self)
    }
    
    //MARK: - AddChildView
    /**
     * 添加工具条
     */
    func setupTooBar(){
        toolbar = ComposeToolbar()
        toolbar.width = self.view.width
        toolbar.height = 44
        toolbar.delegate = self
        toolbar.y = self.view.height - toolbar.height
        //toobar.delegate = self
        self.view.addSubview(toolbar)
    }
    
    /**
     * 设置导航栏内容
     */
    private func setupNav(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .Done, target: self, action: #selector(ComposeViewController.cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .Done, target: self, action: #selector(ComposeViewController.send))
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        let name = AccountTool.account()?.name
        
        if name != nil{
            let titleLabel = UILabel()
            titleLabel.width = 200
            titleLabel.height = 100
            titleLabel.textAlignment = .Center
            //自动换行
            titleLabel.numberOfLines = 0
            titleLabel.y = 50
            
            let str = "\(prefix)\n\(name!)"
            //创建一个带有属性的字符串（比如颜色属性、字体属性等文字属性）
            let attrStr = NSMutableAttributedString(string: str)
            //添加属性
            attrStr.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(16), range: (str as NSString).rangeOfString(prefix))
            attrStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12), range: (str as NSString).rangeOfString(name!))
            titleLabel.attributedText = attrStr
            self.navigationItem.titleView = titleLabel
        }else{
            self.title = prefix
        }
    }
    
    /**
     * 添加输入控件
     */
    private func setupTextView(){
        
        // 在这个控制器中，textView的contentInset.top默认会等于64
        textView = EmotionTextView()
        // 垂直方向上永远可以拖拽（有弹簧效果）
        textView.alwaysBounceVertical = true
        textView.frame = self.view.bounds
        textView.font = UIFont.systemFontOfSize(20)
        self.view.addSubview(textView)
        
        //文字改变的通知
        notificationCter.addObserver(self, selector: #selector(ComposeViewController.textDidChange), name: UITextViewTextDidChangeNotification, object: textView)
        // 键盘通知
        // 键盘的frame发生改变时发出的通知（位置和尺寸）
        notificationCter.addObserver(self, selector: #selector(ComposeViewController.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        //表情选中的通知
        notificationCter.addObserver(self, selector: #selector(ComposeViewController.emotionDidSelect(_:)), name: Notification.EmotionDidSelectNotification, object: nil)
        
        //删除文字的通知
        notificationCter.addObserver(self, selector: #selector(ComposeViewController.emotionDidDelete), name: Notification.EmotionDidDeleteNotification, object: nil)
    }
    
    //MARK: - 监听通知
    
    /**
     *  表情被选中了
     */
    func emotionDidSelect(notification:NSNotification){
        let emotion = notification.userInfo![Notification.SelectEmotionKey] as! Emotion
        textView.insertEmotion(emotion)
    }
    
    /**
     *  删除文字
     */
    func emotionDidDelete(){
        textView.deleteBackward()
    }
    
    func textDidChange(){
        self.navigationItem.rightBarButtonItem?.enabled = self.textView.hasText()
    }
    
    /**
     * 键盘的frame发生改变时调用（显示、隐藏等）
     */
    func keyboardWillChangeFrame(notification:NSNotification){
        // 如果正在切换键盘，就不要执行后面的代码
        if self.switchingKeyboard
        {return}
        
        //动画持续时间
        let userInfo = notification.userInfo! as NSDictionary
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        //键盘的frame
        let keyboardFrame = (userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue).CGRectValue()
        //执行动画
        UIView.animateWithDuration(duration) { () -> Void in
            // 工具条的Y值 == 键盘的Y值 - 工具条的高度
            if keyboardFrame.origin.y > self.view.height{// 键盘的Y值已经远远超过了控制器view的高度
                self.toolbar.y = self.view.height - self.toolbar.height
            }else{
                self.toolbar.y = keyboardFrame.origin.y - self.toolbar.height
            }
        }
    }
    
    
    func cancel(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func send(){
        textView.becomeFirstResponder()
        
       
    }


}


//MARK: - ComposeToolbarDelegate
extension TextViewController:ComposeToolbarDelegate{
    
    func composeToolbar(toolbar: ComposeToolbar, buttonType: ComposeToolBarButtonType) {
        switch buttonType {
        case .Camera:
            openCamera()
            break
        case .Picture:
            openAlbum()
            break
        case .Mention:
            NSLog("----@")
            break
        case .Trend:
            NSLog("-----#")
            break
        case .Emotion:
            switchKeyboard()
            break
        }
    }
    
    //MARK: - OtherFun
    /**
     *  拍照
     */
    func openCamera(){
        openImagePickerController(.Camera)
    }
    
    /**
     * 相册
     */
    func openAlbum(){
        openImagePickerController(.PhotoLibrary)
    }
    
    /**
     *  切换键盘
     */
    func switchKeyboard(){
        // self.textView.inputView == nil : 使用的是系统自带的键盘
        if self.textView.inputView == nil{ // 切换为自定义的表情键盘
            self.textView.inputView = self.emotionKeyboard
            //显示键盘按钮
            self.toolbar.showKeyboardButton = true
        }else{// 切换为系统自带的键盘
            self.textView.inputView = nil
            
            //显示表情按钮
            self.toolbar.showKeyboardButton = false
        }
        //开始切换键盘
        self.switchingKeyboard = true
        //退出键盘
        textView.endEditing(true)
        //结束键盘
        self.switchingKeyboard = false
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))),dispatch_get_main_queue()) { () -> Void in
            //弹出键盘
            self.textView.becomeFirstResponder()
        }
    }
    
    func openImagePickerController(type:UIImagePickerControllerSourceType){
        if !UIImagePickerController.isSourceTypeAvailable(type){
            return
        }
        
        let ipc = UIImagePickerController()
        ipc.sourceType = type
        ipc.delegate = self
        self.presentViewController(ipc, animated: true, completion: nil)
    }
    
}

//MARK: - UIImagePickerControllerDelegate
extension TextViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    /**
     * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
       
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true,completion: nil)
    }
    
}
