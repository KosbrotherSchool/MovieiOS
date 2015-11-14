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

class BlogViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var blogPosts = [BlogPost]()
    
    override func viewDidLoad() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Mark get posts from net
        getBlogPosts(1)
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
        return blogPosts.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BlogCell", forIndexPath: indexPath) as! BlogPostCell
        
        let blogPost = self.blogPosts[indexPath.row]
        
        cell.postTitle.text = blogPost.blogPost_title
        cell.publishDate.text = blogPost.blogPost_pub_date
        
        let picURL = NSURL(string: blogPost.blogPost_pic_link )!
        cell.postImage.kf_setImageWithURL(picURL)
        
        return cell
    }
    
    let host = "http://139.162.10.76"
    
    func getBlogPosts(page: Int)
    {
        let url = NSURL(string: host + "/api/movie/blog_posts?page="+String(page))
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
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
                    self.collectionView.reloadData()
                }
                
            }
            
        })
        
        task.resume()
        print(NSDate())
    }

    
}
