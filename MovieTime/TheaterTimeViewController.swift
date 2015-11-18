//
//  TheaterTimeViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/15/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

class TheaterTimeViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var movieTimes = [MovieTime]()
    var theater_id:Int!
    var theater_name:String!
    var theater_address:String!
    
    @IBAction func searchLocation(sender: UIBarButtonItem) {
        let mapString = self.theater_address
        let escapedAddress = mapString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string: "comgooglemaps://?q="+escapedAddress )!)
        } else {
            let mapURL = NSURL(string: "http://maps.apple.com/?q="+escapedAddress)!
            UIApplication.sharedApplication().openURL(mapURL)
        }
        
        
    }
    
    
    override func viewDidLoad() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.title = theater_name
        // Mark get posts from net
        getMovieTimes(theater_id)
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
            
            let font = UIFont(name: "Verdana", size: 18)
            let title = movieTimes[indexPath.row].movie_title! + movieTimes[indexPath.row].remark!
            let title_height = self.heightForLabel(title, font: font!, width: cell_width - 136) + 16
            
            let num_for_one_rows: Int = Int((collectionView.frame.size.width - 166)/70) // count
            let movie_time = movieTimes[indexPath.row].movie_time!
            let time_array = movie_time.componentsSeparatedByString(",")
            var cell_height = 0
            if( time_array.count % num_for_one_rows ) > 0{
                cell_height = Int( time_array.count / num_for_one_rows + 1) * 40 + 10 + Int(title_height)
            }else{
                cell_height = Int( time_array.count / num_for_one_rows) * 40 + 10 + Int(title_height)
                
            }
            
            if cell_height <= 180 {
                cell_height = 180
            }
            
            return CGSize(width: cell_width, height: CGFloat(cell_height) )
            
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
        return movieTimes.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TheaterCell", forIndexPath: indexPath) as! TheaterCell
        let movieTime = self.movieTimes[indexPath.row]
        
        if movieTime.remark! != ""{
            cell.movieTitleLabel.text = movieTime.movie_title! + "("+movieTime.remark! + ")"
        }else{
            cell.movieTitleLabel.text = movieTime.movie_title!
        }
        
        let picURL = NSURL(string: movieTime.movie_photo! )!
        cell.imageView.kf_setImageWithURL(picURL)
        
        cell.times = movieTime.movie_time!.componentsSeparatedByString(",")
        cell.timeCollectionView.delegate = cell
        cell.timeCollectionView.dataSource = cell
        cell.timeCollectionView.userInteractionEnabled = false
        cell.timeCollectionView.reloadData()
        
        return cell
    }
    
    let host = "http://139.162.10.76"
    
    func getMovieTimes(theater_id: Int)
    {
        let url = NSURL(string: host + "/api/movie/movietimes?theater="+String(theater_id))
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            // Do Something after got data
            let jsonData = JSON(data: data!)
            
            for movie in jsonData.arrayValue{
                let remark = movie["remark"].stringValue
                let movie_title = movie["movie_title"].stringValue
                let movie_time = movie["movie_time"].stringValue
                let movie_id = movie["movie_id"].int!
                let theater_id = movie["theater_id"].int!
                let movie_photo = movie["movie_photo"].stringValue
                
                let newMovieTime = MovieTime.init(remark: remark, movie_title: movie_title, movie_time: movie_time, movie_id: movie_id, theater_id: theater_id, movie_photo: movie_photo)
                
                // add BlogPost to blogPosts
                self.movieTimes.append(newMovieTime)
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
