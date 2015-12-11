import UIKit
import SwiftyJSON
import Kingfisher
import JLToast

class HallaViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {
    
    
    @IBOutlet weak var topCollectionVIewHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var bottomCollectionView: BoardCollectionView!
    var highlightMessages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomCollectionView.delegate = bottomCollectionView.self
        bottomCollectionView.dataSource = bottomCollectionView.self
        
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        topCollectionView.pagingEnabled = true
        
        pageControl.numberOfPages = 0
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        if screenSize.width < 375{
            topCollectionVIewHeightConstrain.constant = 150
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if Reachability.isConnectedToNetwork(){
            if Settings.isHighlightMessageNeedRefreshByThisDate() || highlightMessages.count == 0{
                highlightMessages.removeAll()
                topCollectionView.reloadData()
                self.getHightLightMessages()
                Settings.saveHighlightMessageUpdateDate()
            }
        }else{
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
        }

    }
    
    // MARK Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "WebSegue" {
            let webViewController = segue.destinationViewController as! WebViewController
            if let selectedCell = sender as? PromoteCell2{
                let indexPath = topCollectionView.indexPathForCell(selectedCell)!
                let message = highlightMessages[indexPath.row]
                webViewController.url = message.link_url
                webViewController.title = message.title
            }
            
        }else if segue.identifier == "MessageDetailSegue" {
            
            let talkViewController = segue.destinationViewController as! TalkDetailVIewController
            if let selectedCell = sender as? PromoteCell{
                let indexPath = topCollectionView.indexPathForCell(selectedCell)!
                talkViewController.theMessage = highlightMessages[indexPath.row]
            }
        
        }else{
            if let selectedCell = sender as? BoardCell {
                let talkViewController = segue.destinationViewController as! TalkVIewController
                let indexPath = bottomCollectionView.indexPathForCell(selectedCell)!
                switch indexPath.row{
                case 0:
                    talkViewController.board_id = 0
                case 1:
                    talkViewController.board_id = 1
                case 3:
                    talkViewController.board_id = 2
                case 5:
                    talkViewController.board_id = 3
                case 6:
                    talkViewController.board_id = 4
                default:
                    talkViewController.board_id = 0
                }
            }
        }
        
    }
    
    // how many section in the collection view, most 1
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // how many cell in the collection view
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return highlightMessages.count
    }
    
    // what look for every cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let board_id = highlightMessages[indexPath.row].board_id
        switch board_id {
        case -1:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PromoteCell2", forIndexPath: indexPath) as! PromoteCell2
            cell.label.text = highlightMessages[indexPath.row].title
            cell.image.kf_setImageWithURL(NSURL(string: highlightMessages[indexPath.row].pic_url )!)
            return cell
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PromoteCell", forIndexPath: indexPath) as! PromoteCell
            cell.label.text = highlightMessages[indexPath.row].title
            cell.image.kf_setImageWithURL(NSURL(string: highlightMessages[indexPath.row].pic_url )!)
            return cell
        }
        
        
    }
    
    // MARK delegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    // width and height of every cell
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let cell_width = collectionView.frame.size.width
            let cell_height = collectionView.frame.size.height
            return CGSize(width: cell_width, height: cell_height)
    }
    
    func collectionView(collectionView: UICollectionView,willDisplayCell cell: UICollectionViewCell,forItemAtIndexPath indexPath: NSIndexPath){
        // chage page control
        pageControl.currentPage = indexPath.row
    }

    
    let host = "http://139.162.10.76"
    
    func getHightLightMessages()
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = NSURL(string: host + "/api2/movie/highlight_messages")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            // Do Something after got data
            let jsonData = JSON(data: data!)
            
            for obj in jsonData.arrayValue{
                
                let message_id = obj["id"].int!
                let board_id = obj["board_id"].int!
                switch board_id {
                case -1:
                    let title = obj["title"].stringValue
                    let link_url = obj["link_url"].string!
                    let pic_url = obj["pic_link"].string!
                    let newMessage = Message.init(board_id: board_id,message_id: message_id, author: "", title: title, tag: "", content: "", pub_date: "", view_count: 0, like_count: 0, reply_size: 0, head_index: 0, is_head: false, link_url: link_url, pic_url: pic_url)
                    self.highlightMessages.append(newMessage)
                default:
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
                    let pic_url = obj["pic_link"].string!
                    
                    let newMessage = Message.init(board_id: board_id,message_id: message_id, author: author, title: title, tag: tag, content: content, pub_date: pub_date, view_count: view_count, like_count: like_count, reply_size: reply_size, head_index: head_index, is_head: is_head, link_url: link_url, pic_url: pic_url)
                    self.highlightMessages.append(newMessage)
                }
                
            }
            
            // update UI
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.topCollectionView.reloadData()
                    self.pageControl.numberOfPages = self.highlightMessages.count
                    self.pageControl.currentPage = 0
                }
                
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
        })
        
        task.resume()
        print(NSDate())
    }
    
    
}