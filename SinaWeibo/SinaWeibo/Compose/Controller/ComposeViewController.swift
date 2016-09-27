//
//  ComposeViewController.swift
//  新浪微博
//
//  发布微博
//

import UIKit

class ComposeViewController: TextViewController {
    
   
    /** 相册控件 */
    private var photosView:ComposePhotosView!
   
    override func viewDidLoad() {
        prefix = "发表微博"
        super.viewDidLoad()
        textView.placeholder = "分享新鲜事..."
        //添加相册
        setupPhotosView()
    }
    

    //MARK: - AddChildView
    /**
    * 添加相册
    */
    private func setupPhotosView(){
        photosView = ComposePhotosView()
        photosView.y = 100
        photosView.width = self.view.width
        //随便写
        photosView.height = self.view.height
        textView.addSubview(photosView)
    }
    
    //重写
    override func textDidChange(){
        super.textDidChange()
        
        let maxSize = CGSizeMake(self.textView.width, CGFloat(MAXFLOAT))
        let newSize = textView.sizeThatFits(maxSize)
        let tempY = newSize.height + textView.y + 10
        if tempY > photosView.y{
            if photosView.y > self.textView.height{
                self.textView.height += photosView.y - self.textView.height
            }
            
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.photosView.y += tempY - self.photosView.y
            })
        }
    }
    
    
    override func send(){
        super.send()
        
//        let limitCount = 140
//        if !RegexHelper.limitChar(textView.fullText, count: limitCount) {
//            MessageTool.showText("不超过\(limitCount)个汉字")
//            return
//        }
        
        if photosView.photos!.count > 0{
            sendWithImage()
        }else{
            sendWithoutImage()
        }
    }
    
    
    /**
    * 发布带有图片的微博
    */
    private func sendWithImage(){
        // URL: https://upload.api.weibo.com/2/statuses/upload.json
        // 参数:
        /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
        /**	access_token true string*/
        /**	pic true binary 微博的配图。*/
        
        //拼接请求参数
        let url = XLMess.Compose_Update_Image_Url
        var params = [String:AnyObject]()
        params["access_token"] = AccountTool.account()!.access_token!
        params["status"] = self.textView.fullText
        
        //拼接文件数据
//        let image = self.photosView.photos!.firstObject as! UIImage
//        let data = UIImageJPEGRepresentation(image, 1.0)
//        params["pic"] = NetData(data: data!, mimeType: MimeType.ImageJpeg, filename: "text.jpg")
        
        //上传一个图片，参数必须是pic，不能改变会出错
        for i in 0..<self.photosView.photos!.count{
            let image = self.photosView.photos!.firstObject as! UIImage
            let data = UIImageJPEGRepresentation(UIImage.imageWithImageSimple(image, scaledToSize: CGSizeMake(640, 640)), 1.0)
            params["pic"] = NetData(data: data!, mimeType: MimeType.ImageJpeg, filename: "text\(i).jpg")
        }
        
        MessageTool.showLoadWithText("正在上传...")
        
        let request = HttpTool.urlRequestWithComponents(url, parameters: params)
        
        HttpTool.upload(request, progress: { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                print(totalBytesWritten)
            }, success: { (dict) in
                if let error = dict["error"] as? String{
                    print(error)
                    MessageTool.dissm()
                }else{
                    MessageTool.showText("操作成功")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }) { (error) in
                MessageTool.dissm()
        }
    }
    

    private func sendWithoutImage(){
        // URL: https://api.weibo.com/2/statuses/update.json
        // 参数:
        /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
        /**	access_token true string*/
        
        let url = XLMess.Compose_Update_Url
        //拼接请求参数
        var params = [String:AnyObject]()
        params["access_token"] = AccountTool.account()?.access_token
        params["status"] = self.textView.fullText
        //发送请求
        HttpTool.post(url, params: params, success: { (dict) in
            if let error = dict["error"] as? String{
                print(error)
                MessageTool.dissm()
            }else{
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            }) { (error) in
                print(error)
        }
        
    }
    
    /**
     * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
     */
    override func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        //info中就饮食了选择的图片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //添加图片到photosView中
        self.photosView.addPhoto(image)
    }
    
}




