//
//  WriteReplyViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 12/1/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import JLToast

protocol WriteReplyProtocol
{
    func sendIsRefreshToPreviousVC(isRefresh:Bool)
}

class WriteReplyViewController: UIViewController {
    
    var headIndex = Settings.getHeadIndex()
    var message_id: Int!
    var is_successed = false
    var is_sending = false
    var mDelegate:WriteReplyProtocol?
    
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var contentText: UITextView!
    @IBAction func sendMessage(sender: UIButton) {
        
        
        if is_sending {
            
            JLToast.makeText("正在上傳中...", duration: JLToastDelay.ShortDelay).show()
            
        }else{
            
            if !is_successed {
                
                if (nameText.text! != "" && contentText.text! != ""){
                    JLToast.makeText("上傳中...", duration: JLToastDelay.ShortDelay).show()
                    self.sentMessageToServer(message_id, author: nameText.text!, content: contentText.text, head_index: headIndex)
                    mDelegate?.sendIsRefreshToPreviousVC(true)
                }else{
                    JLToast.makeText("暱稱,留言內容不可空白", duration: JLToastDelay.ShortDelay).show()
                }
                
            }else{
                JLToast.makeText("已經上傳成功", duration: JLToastDelay.ShortDelay).show()
            }
            
        }

        
    }
    
    
    
    override func viewDidLoad() {
        imageView.image = Settings.getHeadImage()
        if let nickName = Settings.getNickName(){
            nameText.text = nickName
        }
        
        if headIndex == 0{
            headIndex = 1
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Save Settings
        if headIndex != 0{
            Settings.saveHeadImage(headIndex)
        }
        if let nick_name  = nameText.text{
            Settings.saveNickName(nick_name)
        }
    }
    
    func imageTapped(img: AnyObject)
    {
        if headIndex == 6{
            headIndex = 1
        }else{
            headIndex++
        }
        var headImage:UIImage!
        switch headIndex{
        case 1:
            headImage = UIImage(named: "head_captain")
        case 2:
            headImage = UIImage(named: "head_iron_man")
        case 3:
            headImage = UIImage(named: "head_black_widow")
        case 4:
            headImage = UIImage(named: "head_thor")
        case 5:
            headImage = UIImage(named: "head_hulk")
        case 6:
            headImage = UIImage(named: "head_hawkeye")
        default:
            headImage = UIImage(named: "head_captain")
        }
        imageView.image = headImage
    }
    
    let host = "http://139.162.10.76"
    
    func sentMessageToServer(message_id: Int, author: String, content:String, head_index:Int)
    {
        if !Reachability.isConnectedToNetwork(){
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
            return
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        is_sending = true
        let request = NSMutableURLRequest(URL: NSURL(string: host + "/api2/movie/update_replies")!)
        request.HTTPMethod = "POST"
        let postString = "m_id="+String(message_id)+"&a="+author+"&c="+content+"&h="+String(headIndex)
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                JLToast.makeText("上傳失敗", duration: JLToastDelay.ShortDelay).show()
                return
            }
            
            if let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding){
                if responseString == "ok"{
                    JLToast.makeText("上傳成功", duration: JLToastDelay.ShortDelay).show()
                    self.is_successed = true
                }else{
                    JLToast.makeText("上傳失敗", duration: JLToastDelay.ShortDelay).show()
                }
            }
            self.is_sending = false
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        task.resume()
    }
    
}
