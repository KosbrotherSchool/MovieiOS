//
//  BloggerViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/14/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
import JLToast

class BloggerViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var bloggers = [Blogger]()
    
    override func viewDidLoad() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        getBloggers()
        
    }
    
    // MARK Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "BloggerWebSegue" {
            let webViewController = segue.destinationViewController as! WebViewController
            if let selecteCell = sender as? BlogCell {
                let indexPath = collectionView.indexPathForCell(selecteCell)!
                let selectedBlogger = bloggers[indexPath.row]
                webViewController.url = selectedBlogger.blogger_url
                webViewController.title = selectedBlogger.blogger_name
            }
        }
        
    }
    
    
    // MARK spacing of collectionview
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let cell_width = (collectionView.frame.size.width-32)/3
            
            let font = UIFont(name: "Verdana", size: 18)
            let label_height = self.heightForLabel("Label", font: font!, width: cell_width)
            let cell_height = cell_width + label_height + 8
            return CGSize(width: cell_width, height: cell_height)
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
        return bloggers.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BloggerCell", forIndexPath: indexPath) as! BlogCell
        
        let blogger = self.bloggers[indexPath.row]
        cell.label.text = blogger.blogger_name
        let picURL = NSURL(string: blogger.pic_link )!
        cell.imageView.kf_setImageWithURL(picURL)
        
        return cell
    }
    
    let host = "http://139.162.10.76"
    
    func getBloggers()
    {
        if !Reachability.isConnectedToNetwork(){
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
            return
        }
        
        let url = NSURL(string: host + "/api/movie/blogs")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            // Do Something after got data
            let jsonData = JSON(data: data!)
            
            for blogger in jsonData.arrayValue{
                
                let title = blogger["title"].stringValue
                let link = blogger["link"].stringValue
                let pic_link = blogger["pic_link"].stringValue
                
                let newBlogger = Blogger.init(blogger_name: title, blogger_url: link, blogger_icon_id: 0, pic_link: pic_link)
                
                // add BlogPost to blogPosts
                self.bloggers.append(newBlogger)
            }
            
            // update UI
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.collectionView.reloadData()
                }
                
            }
            
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

