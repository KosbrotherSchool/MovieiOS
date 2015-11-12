//
//  PhotoViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/11/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class PhotoViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indexLabel: UILabel!
    
    var movie_id :Int?
    var photos = [String]()
    
    override func viewDidLoad() {
        
        //MARK get the trailer
        print(movie_id!)
        getMovieTrailer(movie_id!)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.pagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
    }
    
    
    // MARK spacing of collectionview
    // spacing between rows
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    // spacing between items
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let cell_width = collectionView.frame.size.width
            let cell_height = collectionView.frame.size.height
            
            return CGSize(width: cell_width, height: cell_height )
            
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    // Mark Collection Data
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! PhotoCell
        cell.imageView.kf_setImageWithURL(NSURL(string: photos[indexPath.row] )!)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,willDisplayCell cell: UICollectionViewCell,forItemAtIndexPath indexPath: NSIndexPath){
        self.indexLabel.text = "\(indexPath.row+1) / \(self.photos.count)"
    }
    
    
    let host = "http://139.162.10.76"
    
    func getMovieTrailer(movie_id: Int)
    {
        let url = NSURL(string: host + "/api/movie/photos?movie_id="+String(movie_id))
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            print(NSDate())
            let jsonData = JSON(data: data!)
            for photo in jsonData.arrayValue{
                let photo_link = photo["photo_link"].stringValue
                self.photos.append(photo_link)
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
