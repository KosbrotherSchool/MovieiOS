//
//  FirstViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 10/28/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import Cosmos



class FirstViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    var rankMovies = [Movie]()
    var thisWeekMovies = [Movie]()
    var publishingMovies = [Movie]()
    var upGoingMovies = [Movie]()
    let reuseIdentifier = "collCell"
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func segmentChange(sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex
        {
            case 0:
                if(rankMovies.count==0){
                    getMovieTaipeiRanks()
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        self.collectionView.reloadData()
                    }
                }
                break;
            case 1:
                if(thisWeekMovies.count==0){
                    getMovieThisWeek()
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        self.collectionView.reloadData()
                    }
                }
                break;
            case 2:
                if(publishingMovies.count==0){
                    getMoviePublishing()
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        self.collectionView.reloadData()
                    }
                }
                break;
            case 3:
                if(upGoingMovies.count == 0){
                    getMovieUpGoing()
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        self.collectionView.reloadData()
                    }
                }
                break;
            default:
                break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.delegate = self
        collectionView.dataSource = self
        getMovieTaipeiRanks()
//        getMovieThisWeek()
//        getMoviePublishing()
//        getMovieUpGoing()
        
    }
    
    
    // MARK Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let movieDetailViewController = segue.destinationViewController as! MovieDetailViewController
            
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? MovieCollectionCell {
                let indexPath = collectionView.indexPathForCell(selectedMealCell)!
                let selectedMovie = rankMovies[indexPath.row]
                movieDetailViewController.theMovie = selectedMovie
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new meal.")
        }
    }

    
    // MARK spacing of collectionview
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 6.0
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

            let cell_width = (collectionView.frame.size.width/2)-8
            let cell_height = cell_width * 1.68
            return CGSize(width: cell_width, height: cell_height)
            
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    
    // Mark Collection Data
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.segmentControl.selectedSegmentIndex
        {
        case 0:
            return rankMovies.count
        case 1:
            return thisWeekMovies.count
        case 2:
            return publishingMovies.count
        case 3:
            return upGoingMovies.count
        default:
            break;
        }
        return rankMovies.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MovieCollectionCell
        
        var theMovie = Movie?()
        switch self.segmentControl.selectedSegmentIndex
        {
        case 0:
            theMovie = self.rankMovies[indexPath.row]
            break;
        case 1:
            theMovie = self.thisWeekMovies[indexPath.row]
            break;
        case 2:
            theMovie = self.publishingMovies[indexPath.row]
            break;
        case 3:
            theMovie = self.upGoingMovies[indexPath.row]
            break;
        default:
            theMovie = self.rankMovies[indexPath.row]
            break;
        }
        
        cell.title.text = theMovie!.title
        cell.image.kf_setImageWithURL(NSURL(string: theMovie!.large_pic )!)
        cell.cancelRating()
        cell.update(theMovie!.points/2.0)
        cell.pointLabel.text = String(format:"%.1f", theMovie!.points) + "分"
        cell.messageLabel.text = String(theMovie!.review_size) + "人留言"
        
        return cell
    }
    
    // MARK MovieAPI
    
    let host = "http://139.162.10.76"
    
    func getMovieTaipeiRanks()
    {
        let url = NSURL(string: host + "/api2/movie/rank_movies?page=1")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            print(NSDate())
            let jsonData = JSON(data: data!)
            for movie in jsonData.arrayValue{
                let id = movie["id"].int
                let title = movie["title"].stringValue
                let small_pic = movie["small_pic"].stringValue
                let large_pic = movie["large_pic"].stringValue
                let point = movie["point"].doubleValue
                let review_size = movie["review_size"].int
                let newMovie = Movie.init(movie_id: id!, title: title, small_pic: small_pic, large_pic: large_pic, points: point, review_size: review_size!)
                self.rankMovies.append(newMovie)
                print(title)

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
    
    func getMovieThisWeek()
    {
        let url = NSURL(string: host + "/api2/movie/movies?movie_round=4")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            print(NSDate())
            let jsonData = JSON(data: data!)
            for movie in jsonData.arrayValue{
                let id = movie["id"].int
                let title = movie["title"].stringValue
                let small_pic = movie["small_pic"].stringValue
                let large_pic = movie["large_pic"].stringValue
                let point = movie["point"].doubleValue
                let review_size = movie["review_size"].int
                let newMovie = Movie.init(movie_id: id!, title: title, small_pic: small_pic, large_pic: large_pic, points: point, review_size: review_size!)
                self.thisWeekMovies.append(newMovie)
                print(title)
                
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
    
    func getMoviePublishing()
    {
        let url = NSURL(string: host + "/api2/movie/movies?movie_round=1&page=1")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            print(NSDate())
            let jsonData = JSON(data: data!)
            for movie in jsonData.arrayValue{
                let id = movie["id"].int
                let title = movie["title"].stringValue
                let small_pic = movie["small_pic"].stringValue
                let large_pic = movie["large_pic"].stringValue
                let point = movie["point"].doubleValue
                let review_size = movie["review_size"].int
                let newMovie = Movie.init(movie_id: id!, title: title, small_pic: small_pic, large_pic: large_pic, points: point, review_size: review_size!)
                self.publishingMovies.append(newMovie)
                print(title)
                
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
    
    func getMovieUpGoing()
    {
        let url = NSURL(string: host + "/api2/movie/movies?movie_round=3&page=1")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            print(NSDate())
            let jsonData = JSON(data: data!)
            for movie in jsonData.arrayValue{
                let id = movie["id"].int
                let title = movie["title"].stringValue
                let small_pic = movie["small_pic"].stringValue
                let large_pic = movie["large_pic"].stringValue
                let point = movie["point"].doubleValue
                let review_size = movie["review_size"].int
                let newMovie = Movie.init(movie_id: id!, title: title, small_pic: small_pic, large_pic: large_pic, points: point, review_size: review_size!)
                self.upGoingMovies.append(newMovie)
                print(title)
                
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

