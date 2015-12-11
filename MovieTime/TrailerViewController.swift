//
//  TrailerTableViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/10/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
import JLToast

class TrailerViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var movie_id :Int?
    var trailers = [Trailer]()
    
    override func viewDidLoad() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //MARK get the trailer
        print(movie_id!)
        getMovieTrailer(movie_id!)

    }
    
    // MARK Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TrailerWebView" {
            let webViewController = segue.destinationViewController as! WebViewController
            if let selecteCell = sender as? TrailerCell {
                let indexPath = collectionView.indexPathForCell(selecteCell)!
                let selectedTrailer = trailers[indexPath.row]
                webViewController.url = selectedTrailer.youtube_link
            }

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
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let cell_width = collectionView.frame.size.width-20
            return CGSize(width: cell_width, height: 100)
            
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
        return trailers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("trailerCell", forIndexPath: indexPath) as! TrailerCell
        let icon_image = UIImage(named: "app_icon")
        cell.imageView.kf_setImageWithURL(NSURL(string: self.trailers[indexPath.row].getPicLink())!,placeholderImage: icon_image)
        cell.titleLabel.text = self.trailers[indexPath.row].title
        return cell
    }
    
    let host = "http://139.162.10.76"
    
    func getMovieTrailer(movie_id: Int)
    {
        if !Reachability.isConnectedToNetwork(){
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
            return
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = NSURL(string: host + "/api/movie/trailers?movie_id="+String(movie_id))
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            print(NSDate())
            let jsonData = JSON(data: data!)
            for trailer in jsonData.arrayValue{
                let title = trailer["title"].stringValue
                let youtube_id = trailer["youtube_id"].stringValue
                let youtube_link = trailer["youtube_link"].stringValue
                let movie_id = trailer["movie_id"].int
                let trailer_id = trailer["id"].int
                
                let newTrailer = Trailer.init(title: title, youtube_id: youtube_id, youtube_link: youtube_link, movie_id: movie_id!, trailer_id: trailer_id!)
                self.trailers.append(newTrailer)
                print(title)
                
            }
            // update UI
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.collectionView.reloadData()
                }
                
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
        task.resume()
        print(NSDate())
    }
    
    
    
}
