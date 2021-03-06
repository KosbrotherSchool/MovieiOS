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
import JLToast

class TheaterTimeViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var movieTimes = [MovieTime]()
    var theater_id:Int!
    var theater_name:String!
    var theater_address:String!
    var is_loved = false
    var theFavTheater:FavTheater!
    
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
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var loveButton: UIBarButtonItem!
    @IBAction func checkLove(sender: UIBarButtonItem) {
        
        switch is_loved{
        case true:
            is_loved = false
            FavTheater.deleteTheFavTheater(moc, theTheater: theFavTheater)
            loveButton.image = UIImage(named: "love")
        case false:
            is_loved = true
            let theater = Theater.getTheaterByID(theater_id)!
            theFavTheater = FavTheater.add(moc, name: theater.name!, phone: theater.phone!, address: theater.address!, theater_id: theater_id)!
            loveButton.image = UIImage(named: "icon_love_white_full")
        }
        
    }
    
    
    override func viewDidLoad() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.title = theater_name
        // Mark get posts from net
        getMovieTimes(theater_id)
        
        if let favTheater = FavTheater.queryByTheaterID(moc, theater_id: theater_id){
            is_loved = true
            theFavTheater = favTheater
            loveButton.image = UIImage(named: "icon_love_white_full")
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
            
            let font = UIFont.systemFontOfSize(17)
            let title = movieTimes[indexPath.row].movie_title! + movieTimes[indexPath.row].remark!
            let title_height = self.heightForLabel(title, font: font, width: cell_width - 136) + 16
            
            let num_for_one_rows: Int = Int((collectionView.frame.size.width - 166)/70) // count
            let movie_time = movieTimes[indexPath.row].movie_time!
            let time_array = movie_time.componentsSeparatedByString(",")
            var cell_height = 0
            if( time_array.count % num_for_one_rows ) > 0{
                cell_height = Int( time_array.count / num_for_one_rows + 1) * 40 + Int(title_height)-8
            }else{
                cell_height = Int( time_array.count / num_for_one_rows) * 40 + Int(title_height)-8
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
        let icon_image = UIImage(named: "app_icon")
        cell.imageView.kf_setImageWithURL(picURL, placeholderImage: icon_image)
        
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
        if !Reachability.isConnectedToNetwork(){
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
            return
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
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
