//
//  TalkDetailVIewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/29/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import DOFavoriteButton
import SwiftyJSON
import WebKit
import JLToast

class TalkDetailVIewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,WriteReplyProtocol {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isLarge = false
    var webView: WKWebView!
    
    var theMessage:Message!
    var mPage = 1
    
    var progress_y:CGFloat!
//    var expandButton:UIButton!
//    var toolBar:UIToolbar!
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var replies = [MessageReply]()
    var is_refresh = false
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        getReplies(theMessage.message_id, page: 1)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ReplySegue" {
            let writeReplyViewController = segue.destinationViewController as! WriteReplyViewController
            writeReplyViewController.message_id = theMessage.message_id
            writeReplyViewController.mDelegate = self
        }
    }
    
    func sendIsRefreshToPreviousVC(isRefresh:Bool){
        print("protocal work")
        self.is_refresh = true
    }
    
    override func viewWillAppear(animated: Bool) {
        if (is_refresh){
            replies.removeAll()
            collectionView.reloadData()
            mPage = 1
            self.getReplies(theMessage.message_id, page: mPage)
            is_refresh = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    // MARK spacing of collectionview
    // spacing between rows
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8.0
    }
    // spacing between items
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            switch indexPath.row{
            case 0:
                let cell_width = collectionView.frame.size.width-16
                let font18 = UIFont.systemFontOfSize(18)
                let titleHeight = self.heightForLabel(self.theMessage.title, font: font18, width: cell_width-16)
                let font15 = UIFont.systemFontOfSize(15)
                let contentHeight = self.heightForLabel(self.theMessage.content, font: font15, width: cell_width-16)
                switch self.theMessage.link_url{
                case "":
                    return CGSize(width: cell_width, height: 84+titleHeight+contentHeight)
                default:
                    progress_y = 84+titleHeight+contentHeight
                    return CGSize(width: cell_width, height: 286+titleHeight+contentHeight+8+48)
                }
            default:
                // reply cell height
                let cell_width = collectionView.frame.size.width-16
                let font15 = UIFont.systemFontOfSize(15)
                let contentHeight = self.heightForLabel(self.theMessage.content, font: font15, width: cell_width-16)
                return CGSize(width: cell_width, height: 74+contentHeight)
            }
            
            
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
        return replies.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch indexPath.row{
        case 0:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TalkDetailCell", forIndexPath: indexPath) as! TalkDetailCell
            cell.likeButton.imageColorOn = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
            cell.likeButton.circleColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
            cell.likeButton.lineColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0)
            cell.likeButton.addTarget(self, action: Selector("tappedMessageButton:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.title.text = theMessage.title
            cell.author.text = theMessage.author
            cell.pub_date.text = theMessage.pub_date
            cell.likeNum.text = String(theMessage.like_count)
            cell.image.image = Settings.getHeadImage(theMessage.head_index)
            cell.content.text = theMessage.content
            
            if let favMessage = FavMessage.queryByMessageID(moc, mssage_id: theMessage.message_id){
                cell.likeButton.selected = true
            }else{
                cell.likeButton.selected = false
            }
            
            if theMessage.link_url != ""{
                cell.addWebView(theMessage.link_url, cell_width: view.frame.size.width-16, progress_y: progress_y)
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ReplyCell", forIndexPath: indexPath) as! ReplyCell
            cell.likeButton.imageColorOn = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
            cell.likeButton.circleColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
            cell.likeButton.lineColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0)
            cell.likeButton.addTarget(self, action: Selector("tappedReplyButton:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.content.text = replies[indexPath.row-1].content
            cell.author.text = replies[indexPath.row-1].author
            cell.pub_date.text = replies[indexPath.row-1].pub_date
            cell.likeNum.text = String(replies[indexPath.row-1].like_count)
            cell.image.image = Settings.getHeadImage(replies[indexPath.row-1].head_index)
            cell.likeButton.tag = indexPath.row-1
            
            if let favReply = FavReply.queryByReplyID(moc, reply_id: replies[indexPath.row-1].reply_id){
                cell.likeButton.selected = true
            }else{
                cell.likeButton.selected = false
            }

            
            return cell
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView,willDisplayCell cell: UICollectionViewCell,forItemAtIndexPath indexPath: NSIndexPath){
        
        if self.replies.count >= 20 && indexPath.row == self.replies.count-10 {
            if mPage != -1{
                print("load more \(mPage)")
                mPage = mPage + 1
                self.getReplies(theMessage.message_id, page: mPage)
            }
        }
        
    }
    
    func tappedMessageButton(sender: DOFavoriteButton) {
        if sender.selected {
            //            sender.deselect()
        } else {
            sender.select()
            theMessage.like_count = theMessage.like_count + 1
            FavMessage.add(moc, message_id: theMessage.message_id, author: theMessage.author, title: theMessage.title, tag: theMessage.tag, content: theMessage.content, pub_date: theMessage.pub_date, view_count: theMessage.view_count, reply_size: theMessage.reply_size, head_index: theMessage.head_index, like_count: theMessage.like_count, is_head: theMessage.is_head, link_url: theMessage.link_url)
            getMessagePlus(theMessage.message_id)
            
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath.init(forItem: 0, inSection: 0)) as! TalkDetailCell
            cell.likeNum.text = String(theMessage.like_count)
        }
    }
    
    func tappedReplyButton(sender: DOFavoriteButton) {
        if sender.selected {
            //            sender.deselect()
        } else {
            sender.select()
            let index = sender.tag
            self.replies[index].like_count = self.replies[index].like_count + 1
            let reply = self.replies[index]
            FavReply.add(moc, reply_id: reply.reply_id, message_id: reply.message_id, author: reply.author, content: reply.content, pub_date: reply.pub_date, head_index: reply.head_index, like_count: reply.like_count)
            getReplyPlus(reply.reply_id)
            
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath.init(forItem: index+1, inSection: 0)) as! ReplyCell
            cell.likeNum.text = String(reply.like_count)
        }
    }
    
    
    let host = "http://139.162.10.76"
    
    func getReplies(message_id:Int, page:Int)
    {
        if !Reachability.isConnectedToNetwork(){
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = NSURL(string: host + "/api2/movie/reply?message_id="+String(message_id)+"&page="+String(page))
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            // Do Something after got data
            let jsonData = JSON(data: data!)
            if jsonData.count < 20 {
                self.mPage = -1
            }
            
            if jsonData.count > 0{
                
                for obj in jsonData.arrayValue{
                    let reply_id = obj["id"].int!
                    let message_id = obj["ios_message_id"].int!
                    let author = obj["author"].stringValue
                    let content = obj["content"].stringValue
                    let pub_date = obj["pub_date"].stringValue
                    let head_index = obj["head_index"].int!
                    let like_count = obj["like_count"].int!
                
                    let newReply = MessageReply.init(reply_id: reply_id,message_id: message_id, author: author, content: content, pub_date: pub_date, head_index: head_index, like_count: like_count)
                
                    // add BlogPost to blogPosts
                    self.replies.append(newReply)
                }
            
                // update UI
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                    dispatch_async(dispatch_get_main_queue()) {
                        self.collectionView.reloadData()
                    }
                
                }
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
        
        task.resume()
        print(NSDate())
    }
    
    
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
        
    }
    
    func getMessagePlus(message_id:Int)
    {
        let url = NSURL(string: host + "/api2/movie/update_message_like?message_id="+String(message_id))
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
        })
        
        task.resume()
        print(NSDate())
    }
    
    func getReplyPlus(reply_id:Int)
    {
        let url = NSURL(string: host + "/api2/movie/update_reply_like?reply_id="+String(reply_id))
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
        })
        
        task.resume()
        print(NSDate())
    }
    
}
