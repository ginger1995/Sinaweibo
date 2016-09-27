//
//  OAuthViewController.swift
//  新浪微博
//
//  授权页面
//

protocol OAuthViewControllerDelegate:class {
    func oAuthViewDidLogin()
}

import UIKit

class OAuthViewController: UIViewController,UIWebViewDelegate {

    weak var delegate:OAuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftItem = UIBarButtonItem(title: "关闭", style: .Done, target: self, action: #selector(OAuthViewController.close))
        self.navigationItem.leftBarButtonItem = leftItem
       
        let webView = UIWebView()
        webView.frame = self.view.bounds
        webView.delegate = self
        self.view.addSubview(webView)
        
        //用webView加载登录页面(新浪提供)
        let url = NSURL(string: "https://api.weibo.com/oauth2/authorize?client_id=\(XLMess.Client_id)&redirect_uri=\(XLMess.Redirect_uri)")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    internal func close(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - UIWebViewDelegate
    func webViewDidFinishLoad(webView: UIWebView) {
        MessageTool.dissm()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        MessageTool.showLoad()
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        MessageTool.dissm()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //获得url
        let url = request.URL?.absoluteString
        //判断是否为回调地址
        if let range = url?.rangeOfString("code="){
            //截取code=后面的参数值
            let fromIndex = range.endIndex
            let code = url?.substringFromIndex(fromIndex)
            //利用code换取一个accessToken
            accessToken(code!)
            return false //禁止加载回调地址
        }
        return true
    }
    
    func accessToken(code:String){
        /*
        URL：https://api.weibo.com/oauth2/access_token
        
        请求参数：
        client_id：申请应用时分配的AppKey
        client_secret：申请应用时分配的AppSecret
        grant_type：使用authorization_code
        redirect_uri：授权成功后的回调地址
        code：授权成功后返回的code
        */
        var params = [String:String]()
        params["client_id"] = XLMess.Client_id;
        params["client_secret"] = XLMess.Client_secret;
        params["grant_type"] = XLMess.Qrant_type;
        params["redirect_uri"] = XLMess.Redirect_uri;
        params["code"] = code;
        
        
        let url = XLMess.OAuthUrl
        HttpTool.post(url, params: params, success: { (dict) in
            
            let account = Account.account(dict)
            // 存储账号信息
            AccountTool.saveAccount(account)
            
            self.delegate?.oAuthViewDidLogin()
            
            self.dismissViewControllerAnimated(true, completion: nil)
            //切换窗口的根控制器
            //let window  = UIApplication.sharedApplication().keyWindow
            //window?.switchRootViewController()

            
            }) { (error) in
                print(error)
        }
        
    }
    
    deinit{
        NSLog("销毁")
    }

}
