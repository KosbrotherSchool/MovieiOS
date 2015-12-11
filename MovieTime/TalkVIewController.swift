//
//  TalkVIewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/26/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import DOFavoriteButton
import SwiftyJSON
import JLToast

class TalkVIewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,WriteMessageProtocol {
    
    @IBOutlet weak var messageButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    var board_id:Int!
    var messages = [Message]()
    var favMessages = [FavMessage]()
    var mPage = 1
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var is_refresh = false
    
    override func viewDidLoad() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        switch board_id {
        case 0:
            self.title = "公告區"
        case 1:
            self.title = "電影版"
        case 2:
            self.title = "劇版"
        case 3:
            self.title = "生活版"
        case 4:
            self.title = "最近按讚"
        default:
            self.title = "公告區"
        }
        
        if board_id == 4{
            messageButton.enabled = false
            self.favMessages = FavMessage.getAll(moc).reverse()
            // get fav messages
        }else{
            self.getMessages(board_id, page: mPage)
        }
    }
    
    func sendIsRefreshToPreviousVC(is_refresh:Bool){
        print("protocal work")
        self.is_refresh = true
    }
    
    override func viewWillAppear(animated: Bool) {
        if (is_refresh){
            messages.removeAll()
            collectionView.reloadData()
            self.getMessages(board_id, page: 1)
            is_refresh = false
            mPage = 1
        }else{
            collectionView.reloadData()
        }
    }
    
    // MARK Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "messageDetailSegue" {
            if let selectedCell = sender as? TalkCell {
                let detailViewController = segue.destinationViewController as! TalkDetailVIewController
                let indexPath = collectionView.indexPathForCell(selectedCell)!
                if board_id != 4{
                    detailViewController.theMessage = self.messages[indexPath.row]
                }else{
                    let favMessage = self.favMessages[indexPath.row]
                    let message = Message.init(board_id: board_id, message_id: Int(favMessage.message_id!), author: favMessage.author!, title: favMessage.title!, tag: favMessage.tag!, content: favMessage.content!, pub_date: favMessage.pub_date!, view_count: Int(favMessage.view_count!), like_count: Int(favMessage.like_count!), reply_size: Int(favMessage.reply_size!), head_index: Int(favMessage.head_index!), is_head: false, link_url: favMessage.link_url!, pic_url: "")
                     detailViewController.theMessage = message
                }
                detailViewController.title = self.title
            }
        }else if segue.identifier == "writeMessageSegue"{
            let detailViewController = segue.destinationViewController as! WriteMessageViewController
            detailViewController.board_id = self.board_id
            detailViewController.mDelegate = self
        }
        
    }
    
    // MARK spacing of collectionview
    // spacing between rows
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    // spacing between items
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            switch board_id{
            case 4:
                let cell_width = collectionView.frame.size.width-20
                let font = UIFont.systemFontOfSize(19)
                let cell_height = self.heightForLabel(self.favMessages[indexPath.row].title! , font: font, width: cell_width-150) + 43
                return CGSize(width: cell_width, height: cell_height)
            default:
                let cell_width = collectionView.frame.size.width-20
                let font = UIFont.systemFontOfSize(19)
                let cell_height = self.heightForLabel(self.messages[indexPath.row].title , font: font, width: cell_width-150) + 43
                return CGSize(width: cell_width, height: cell_height)
            }
            
            
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }
    
    // Mark Collection Data
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch board_id{
        case 4:
            return favMessages.count
        default:
            return messages.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TalkCell", forIndexPath: indexPath) as! TalkCell
        
        cell.likeButton.imageColorOn = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        cell.likeButton.circleColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        cell.likeButton.lineColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0)
        cell.likeButton.addTarget(self, action: Selector("tappedButton:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        switch board_id{
        case 4:
            let theMessage = self.favMessages[indexPath.row]
            cell.title.text = theMessage.title
            cell.author.text = theMessage.author
            cell.pub_date.text = theMessage.pub_date
            cell.likeNum.text = String(theMessage.like_count!)
            cell.tagLabel.text = theMessage.tag
            cell.likeButton.tag = indexPath.row
            cell.likeButton.selected = true
        default:
            let theMessage = self.messages[indexPath.row]
            cell.title.text = theMessage.title
            cell.author.text = theMessage.author
            cell.pub_date.text = theMessage.pub_date
            cell.likeNum.text = String(theMessage.like_count)
            cell.tagLabel.text = theMessage.tag
            cell.likeButton.tag = indexPath.row
            
            if let favMessage = FavMessage.queryByMessageID(moc, mssage_id: theMessage.message_id){
                cell.likeButton.selected = true
            }else{
                cell.likeButton.selected = false
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,willDisplayCell cell: UICollectionViewCell,forItemAtIndexPath indexPath: NSIndexPath){
        
        if self.messages.count >= 20 && indexPath.row == self.messages.count-10 {
            if mPage != -1{
                print("load more \(mPage)")
                mPage = mPage + 1
                self.getMessages(board_id, page: mPage)
            }
        }
        
    }
    
    func tappedButton(sender: DOFavoriteButton) {
        if sender.selected {
            //            sender.deselect()
        } else {
            sender.select()
            let index = sender.tag
            self.messages[index].like_count = self.messages[index].like_count + 1
            let message = self.messages[index]
            
            FavMessage.add(moc, message_id: message.message_id, author: message.author, title: message.title, tag: message.tag, content: message.content, pub_date: message.pub_date, view_count: message.view_count, reply_size: message.reply_size, head_index: message.head_index, like_count: message.like_count, is_head: message.is_head, link_url: message.link_url)
            
            getMessagePlus(message.message_id)
            
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath.init(forItem: index, inSection: 0)) as! TalkCell
            cell.likeNum.text = String(message.like_count)
        }
    }
    
    let host = "http://139.162.10.76"
    
    func getMessagePlus(message_id:Int)
    {
        if !Reachability.isConnectedToNetwork(){
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
            return
        }
        
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
    
    func getMessages(board_id:Int, page:Int)
    {
        if !Reachability.isConnectedToNetwork(){
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = NSURL(string: host + "/api2/movie/message?board_id="+String(board_id)+"&page="+String(page))
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
                
                    let message_id = obj["id"].int!
                    let author = obj["author"].stringValue
                    let title = obj["title"].stringValue
                    let tag = obj["tag"].stringValue
                    let content = obj["content"].stringValue
                    let pub_date = obj["pub_date"].stringValue
                    let view_count = obj["view_count"].int!
                    let like_count = obj["like_count"].int!
                    let reply_size = obj["reply_size"].int!
                    let is_head = obj["is_head"].boolValue
                    let head_index = obj["head_index"].int!
                    let link_url = obj["link_url"].string!
                    let pic_url = ""
                
                    let newMessage = Message.init(board_id: self.board_id, message_id: message_id, author: author, title: title, tag: tag, content: content, pub_date: pub_date, view_count: view_count, like_count: like_count, reply_size: reply_size, head_index: head_index, is_head: is_head, link_url: link_url, pic_url: pic_url)
                    self.messages.append(newMessage)
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
    
}
