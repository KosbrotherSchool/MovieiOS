//
//  WriteMessageViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/30/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import SwiftyJSON
import JLToast

protocol WriteMessageProtocol
{
    func sendIsRefreshToPreviousVC(isRefresh:Bool)
}

class WriteMessageViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    var mDelegate:WriteMessageProtocol?
    var headIndex = Settings.getHeadIndex()
    var board_id: Int!
    var tag_string = ""
    var is_successed = false
    var is_sending = false

    
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var contentText: UITextView!
    @IBAction func sendMessage(sender: UIButton) {
        
        if is_sending {
            
            JLToast.makeText("正在上傳中...", duration: JLToastDelay.ShortDelay).show()
            
        }else{
            
            if !is_successed {
                if tag_string == ""{
                    JLToast.makeText("請選擇一個標籤", duration: JLToastDelay.ShortDelay).show()
                }else{
                    print(tag_string)
                    if (nameText.text! != "" && titleText.text! != "" && contentText.text! != ""){
                        JLToast.makeText("上傳中...", duration: JLToastDelay.ShortDelay).show()
                        self.sentMessageToServer(board_id, author: nameText.text!, title: titleText.text!, tag: tag_string, content: contentText.text, head_index: headIndex, link_url: linkText.text!)
                        mDelegate?.sendIsRefreshToPreviousVC(true)
                    }else{
                        JLToast.makeText("暱稱,標題,留言內容不可空白", duration: JLToastDelay.ShortDelay).show()
                    }
                }
            }else{
                JLToast.makeText("已經上傳成功", duration: JLToastDelay.ShortDelay).show()
            }
            
        }
        
    }
    @IBOutlet weak var linkText: UITextField!
    
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
        
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        
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
    
    
    // spacing between rows
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8.0
    }
    // spacing between items
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            var word_nums = 0
            switch board_id{
            case 0:
                word_nums = Settings.tagKeys.keyAnnouncement[indexPath.row].characters.count
            case 1:
                word_nums = Settings.tagKeys.keyMovie[indexPath.row].characters.count
            case 2:
                word_nums = Settings.tagKeys.keyDrama[indexPath.row].characters.count
            case 3:
                word_nums = Settings.tagKeys.keyLife[indexPath.row].characters.count
            default:
                word_nums = 2
            }
            if word_nums < 2{
                word_nums = 2
            }
            return CGSize(width: word_nums*25, height: 24)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }
    
    // Mark Collection Data
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch board_id{
        case 0:
            return Settings.tagKeys.keyAnnouncement.count
        case 1:
            return Settings.tagKeys.keyMovie.count
        case 2:
            return Settings.tagKeys.keyDrama.count
        case 3:
            return Settings.tagKeys.keyLife.count
        default:
            return Settings.tagKeys.keyAnnouncement.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TagCell", forIndexPath: indexPath) as! TagCell
        switch board_id{
        case 0:
            cell.tagLabel.text = Settings.tagKeys.keyAnnouncement[indexPath.row]
        case 1:
            cell.tagLabel.text = Settings.tagKeys.keyMovie[indexPath.row]
        case 2:
            cell.tagLabel.text = Settings.tagKeys.keyDrama[indexPath.row]
        case 3:
            cell.tagLabel.text = Settings.tagKeys.keyLife[indexPath.row]
        default:
            cell.tagLabel.text = Settings.tagKeys.keyAnnouncement[indexPath.row]
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        for cell in collectionView.visibleCells(){
            cell.backgroundColor = UIColor.whiteColor()
        }
        let cell = collectionView.cellForItemAtIndexPath(indexPath)! as! TagCell
        if let tag = cell.tagLabel.text{
            tag_string = tag
        }
        cell.backgroundColor = UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
    }
    
    func collectionView(collectionView: UICollectionView,willDisplayCell cell: UICollectionViewCell,forItemAtIndexPath indexPath: NSIndexPath){
        let tagCell = cell as! TagCell
        if(tagCell.tagLabel.text == tag_string){
            cell.backgroundColor = UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
        }else{
            cell.backgroundColor = UIColor.whiteColor()
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
    
    func sentMessageToServer(board_id: Int, author: String, title:String,tag:String, content:String, head_index:Int, link_url:String)
    {
        if !Reachability.isConnectedToNetwork(){
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        is_sending = true
        let request = NSMutableURLRequest(URL: NSURL(string: host + "/api2/movie/update_messages")!)
        request.HTTPMethod = "POST"
        let postString = "b="+String(board_id)+"&a="+author+"&t="+title+"&tag="+tag+"&c="+content+"&h="+String(head_index)+"&l="+link_url
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

