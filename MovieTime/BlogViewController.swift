//
//  BlogViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/13/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
import JLToast

class BlogViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func segmentChange(sender: UISegmentedControl) {
        self.resetCollectionView()
    }
    
    func resetCollectionView(){
        if blogPosts.count > 0 && newses.count > 0{
            self.collectionView.reloadData()
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath.init(forItem: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Top, animated: true)
        }
    }
    
    var blogPosts = [BlogPost]()
    var newses = [MovieNews]()
    var refreshControl:UIRefreshControl!
    var isBlogLoadingMore = false
    var isNewsLoadingMore = false
    var blogCurrentPage = 1
    var newsCurrentPage = 1
    
    override func viewDidLoad() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl)
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
        swipeRight.direction = .Right
        self.collectionView.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
        swipeLeft.direction = .Left
        self.collectionView.addGestureRecognizer(swipeLeft)
    }
    
    func swipedRight(sender:UIGestureRecognizer){
        let currentIndex = segmentControl.selectedSegmentIndex
        if currentIndex > 0{
            segmentControl.selectedSegmentIndex = currentIndex - 1
        }
        self.resetCollectionView()
    }
    
    func swipedLeft(sender:UIGestureRecognizer){
        let currentIndex = segmentControl.selectedSegmentIndex
        if currentIndex < 1{
            segmentControl.selectedSegmentIndex = currentIndex + 1
        }
        self.resetCollectionView()

    }
    
    override func viewWillAppear(animated: Bool) {
        if Reachability.isConnectedToNetwork(){
            if Settings.isBlogPostNeedRefreshByThisDate() || blogPosts.count == 0{
                blogPosts.removeAll()
                newses.removeAll()
                collectionView.reloadData()
                blogCurrentPage = 1
                newsCurrentPage = 1
                getBlogPosts(1)
                getNewses(1)
                Settings.saveBlogPostUpdateDate()
            }
        }else{
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
        }
    }
    
    func refresh(sender:AnyObject)
    {
        self.refreshControl.endRefreshing()
    }
    
    // MARK Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PostWebSegue" {
            let webViewController = segue.destinationViewController as! WebViewController
            if let selecteCell = sender as? BlogPostCell {
                let indexPath = collectionView.indexPathForCell(selecteCell)!
                switch self.segmentControl.selectedSegmentIndex
                {
                case 0:
                    let selectedPost = blogPosts[indexPath.row]
                    webViewController.url = selectedPost.blogPost_link
                    webViewController.title = selectedPost.blogPost_title
                case 1:
                    let selectedNews = newses[indexPath.row]
                    webViewController.url = selectedNews.movienews_new_link
                    webViewController.title = selectedNews.movienews_title
                default:
                    break
                }
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
            let cell_width = collectionView.frame.size.width-16
            return CGSize(width: cell_width, height: 100)
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
        switch self.segmentControl.selectedSegmentIndex{
        case 0:
            return blogPosts.count
        case 1:
            return newses.count
        default:
            0
        }
        return blogPosts.count
    }
    
    func collectionView(collectionView: UICollectionView,willDisplayCell cell: UICollectionViewCell,forItemAtIndexPath indexPath: NSIndexPath){
        
        if Reachability.isConnectedToNetwork(){
            switch segmentControl.selectedSegmentIndex{
                case 0:
                    if indexPath.row == self.blogPosts.count-10 {
                        if !isBlogLoadingMore{
                            print("load more blogs")
                            blogCurrentPage++
                            getBlogPosts(blogCurrentPage)
                        }
                    }
                case 1:
                    if indexPath.row == self.newses.count-10{
                        if !isNewsLoadingMore{
                            print("load more news")
                            newsCurrentPage++
                            getNewses(newsCurrentPage)
                        }
                    }
                default:
                    break
            }
        }else{
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
        }
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BlogCell", forIndexPath: indexPath) as! BlogPostCell
        
        switch self.segmentControl.selectedSegmentIndex{
        case 0:
            let blogPost = self.blogPosts[indexPath.row]
            
            cell.postTitle.text = blogPost.blogPost_title
            cell.publishDate.text = blogPost.blogPost_pub_date
            
            let picURL = NSURL(string: blogPost.blogPost_pic_link )!
            cell.postImage.kf_setImageWithURL(picURL)
        case 1:
            let news = self.newses[indexPath.row]
            cell.postTitle.text = news.movienews_title
            cell.publishDate.text = news.movienews_publish_day
            let picURL = NSURL(string: news.movienews_pic_link )!
            cell.postImage.kf_setImageWithURL(picURL)
        default:
            break
        }
        
        return cell
    }
    
    let host = "http://139.162.10.76"
    
    func getBlogPosts(page: Int)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = NSURL(string: host + "/api2/movie/blog_posts?page="+String(page))
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            print(NSDate())
            // Do Something after got data
            let jsonData = JSON(data: data!)
            
            for blogPost in jsonData.arrayValue{
                let title = blogPost["title"].stringValue
                let blog_post_link = blogPost["link"].stringValue
                let blog_pub_date = blogPost["pub_date"].stringValue
                let blog_pic_link = blogPost["pic_link"].stringValue
                
                let newBlogPost = BlogPost.init(blogPost_title: title, blogPost_link: blog_post_link, blogPost_pic_link: blog_pic_link, blogPost_pub_date: blog_pub_date)
                
                // add BlogPost to blogPosts
                self.blogPosts.append(newBlogPost)
            }
            
            // update UI
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.collectionView.reloadData()
                }
                
            }
            
        })
        
        task.resume()
        print(NSDate())
    }
    
    func getNewses(page: Int)
    {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = NSURL(string: host + "/api2/movie/news?news_type=1&page="+String(page))
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            print(NSDate())
            // Do Something after got data
            let jsonData = JSON(data: data!)
            
            for theNews in jsonData.arrayValue{
                let movienews_title = theNews["title"].stringValue
                let movienews_info = theNews["info"].stringValue
                let movienews_new_link = theNews["news_link"].stringValue
                let movienews_publish_day = theNews["publish_day"].stringValue
                let movienews_pic_link = theNews["pic_link"].stringValue
                let movienews_news_type = 1
                let movienews_news_id = 0
                
                let newNews = MovieNews.init(movienews_title: movienews_title, movienews_info: movienews_info, movienews_new_link: movienews_new_link, movienews_publish_day: movienews_publish_day, movienews_pic_link: movienews_pic_link, movienews_news_type: movienews_news_type, movienews_news_id: movienews_news_id)
                
                // add BlogPost to blogPosts
                self.newses.append(newNews)
            }
            
            // update UI
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.collectionView.reloadData()
                }
                
            }
            
        })
        
        task.resume()
        print(NSDate())
    }

    
}
