//
//  ReviewViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/12/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import SwiftyJSON
import JLToast

class ReviewViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,MyProtocol {
    
    var movie_id: Int!
    var reviews = [Review]()
    @IBOutlet weak var collectionView: UICollectionView!
    var mPage = 1
    var is_refresh = false
    
    override func viewDidLoad() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        getMovieReviews(movie_id, page: 1)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let wrieteReviewViewController = segue.destinationViewController as! WriteReviewViewController
        wrieteReviewViewController.mDelegate = self
        wrieteReviewViewController.movie_id = self.movie_id
            
    }
    
    override func viewWillAppear(animated: Bool) {
        if (is_refresh){
            reviews.removeAll()
            collectionView.reloadData()
            mPage = 1
            getMovieReviews(movie_id, page: 1)
            is_refresh = false
        }
    }
    
    func sendIsRefreshToPreviousVC(is_refresh:Bool){
        self.is_refresh = true
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
    
    // todo later
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let cell_width = collectionView.frame.size.width-20
            
            let font = UIFont(name: "Helvetica", size: 17)
            let cell_height = self.heightForLabel(self.reviews[indexPath.row].content , font: font!, width: cell_width-16) + 80
            
            return CGSize(width: cell_width, height: cell_height)
            
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
        return reviews.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("reviewCell", forIndexPath: indexPath) as! ReviewCell
        
        switch self.reviews[indexPath.row].head_index {
        case 1:
            cell.headImage.image = UIImage(named: "head_captain")
        case 2:
            cell.headImage.image = UIImage(named: "head_iron_man")
        case 3:
            cell.headImage.image = UIImage(named: "head_black_widow")
        case 4:
            cell.headImage.image = UIImage(named: "head_thor")
        case 5:
            cell.headImage.image = UIImage(named: "head_hulk")
        case 6:
            cell.headImage.image = UIImage(named: "head_hawkeye")
        default:
        break
        }
        cell.authorLabel.text = self.reviews[indexPath.row].author
        cell.publish_date_label.text = self.reviews[indexPath.row].publish_date
        cell.point_label.text = String(self.reviews[indexPath.row].point)+"分"
        cell.content_label.text = self.reviews[indexPath.row].content
        cell.updateRating(self.reviews[indexPath.row].point/2)
       
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,willDisplayCell cell: UICollectionViewCell,forItemAtIndexPath indexPath: NSIndexPath){
        
            if self.reviews.count >= 20 && indexPath.row == self.reviews.count-10 {
                if mPage != -1{
                    print("load more \(mPage)")
                    mPage = mPage + 1
                    getMovieReviews(movie_id, page: mPage)
                }
            }
        
    }
    
    let host = "http://139.162.10.76"
    
    func getMovieReviews(movie_id: Int, page: Int)
    {
        if !Reachability.isConnectedToNetwork(){
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = NSURL(string: host + "/api2/movie/reviews?movie_id="+String(movie_id)+"&page="+String(page))
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            // handle data
            print(NSDate())
            let jsonData = JSON(data: data!)
            if jsonData.count < 20{
                self.mPage = -1 //no need load more
            }
            
            if jsonData.count > 0{
                for review in jsonData.arrayValue{
                    let review_id = review["id"].int
                    let author = review["author"].stringValue
                    let title = review["title"].stringValue
                    let content = review["content"].stringValue
                    let publish_date = review["publish_date"].stringValue
                    let point = review["point"].doubleValue
                    let head_index = review["head_index"].int
                
                    let newReview = Review.init(review_id: review_id!, author: author, title: title, content: content, publish_date: publish_date, point: point, head_index: head_index!)
                    self.reviews.append(newReview)
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
