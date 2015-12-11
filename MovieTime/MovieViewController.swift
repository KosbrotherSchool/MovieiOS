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
import CoreData
import JLToast

class MovieViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    let sectionInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    var rankMovies = [Movie]()
    var thisWeekMovies = [Movie]()
    var secondMovies = [Movie]()
    var upGoingMovies = [Movie]()
    var is_update_star = false
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func segmentChange(sender: UISegmentedControl) {
        self.resetCollectionView()
    }
    
    func resetCollectionView(){
        if rankMovies.count > 0 && thisWeekMovies.count > 0 && secondMovies.count > 0 &&  upGoingMovies.count > 0{
            self.collectionView.reloadData()
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath.init(forItem: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Top, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.delegate = self
        collectionView.dataSource = self
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        if screenSize.width < 375{
            is_update_star = true
        }
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
        if currentIndex < 3{
            segmentControl.selectedSegmentIndex = currentIndex + 1
        }
        self.resetCollectionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        if Reachability.isConnectedToNetwork(){
            if Settings.isMovieNeedRefreshByThisDate() || rankMovies.count == 0{
                rankMovies.removeAll()
                thisWeekMovies.removeAll()
                secondMovies.removeAll()
                upGoingMovies.removeAll()
                collectionView.reloadData()
                getMovieTaipeiRanks()
                getMovieThisWeek()
                getSecondMovies()
                getUpGoingMovies()
                Settings.saveMovieUpdateDate()
            }
        }else{
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
        }
    }
    
    // MARK Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let movieDetailViewController = segue.destinationViewController as! MovieDetailViewController
            if let selectedMealCell = sender as? MovieCollectionCell {
                let indexPath = collectionView.indexPathForCell(selectedMealCell)!
                
                switch segmentControl.selectedSegmentIndex{
                case 0:
                    let selectedMovie = rankMovies[indexPath.row]
                    movieDetailViewController.theMovie = selectedMovie
                case 1:
                    let selectedMovie = thisWeekMovies[indexPath.row]
                    movieDetailViewController.theMovie = selectedMovie
                case 2:
                    let selectedMovie = secondMovies[indexPath.row]
                    movieDetailViewController.theMovie = selectedMovie
                default:
                    let selectedMovie = rankMovies[indexPath.row]
                    movieDetailViewController.theMovie = selectedMovie
                }
            }
        }
        if segue.identifier == "UpGoingDetail" {
            let movieDetailViewController = segue.destinationViewController as! MovieDetailViewController
            if let selectedMealCell = sender as? MovieUpGoingCell {
                let indexPath = collectionView.indexPathForCell(selectedMealCell)!
                let selectedMovie = upGoingMovies[indexPath.row]
                movieDetailViewController.theMovie = selectedMovie
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
            switch segmentControl.selectedSegmentIndex{
            case 3:
                let cell_width = (collectionView.frame.size.width-24)/2
                let cell_height = (cell_width - 16) * 37/26 + 55
                return CGSize(width: cell_width, height: cell_height)
            default:
                let cell_width = (collectionView.frame.size.width-24)/2
                let cell_height = (cell_width - 16) * 37/26 + 80
                return CGSize(width: cell_width, height: cell_height)
            }
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
            return secondMovies.count
        case 3:
            return upGoingMovies.count
        default:
            break;
        }
        return rankMovies.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch self.segmentControl.selectedSegmentIndex{
        case 3:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieUpGoingCell", forIndexPath: indexPath) as! MovieUpGoingCell
            let theMovie = self.upGoingMovies[indexPath.row]
            cell.image.kf_setImageWithURL(NSURL(string: theMovie.large_pic )!)
            cell.title.text = theMovie.title
            cell.pub_date.text = "上映:"+theMovie.publish_date!
            return cell
        case 0:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collCell", forIndexPath: indexPath) as! MovieCollectionCell
            let theMovie = self.rankMovies[indexPath.row]
            if (indexPath.row < 20){
                cell.rankLabel.text = String(indexPath.row + 1)
                cell.rankLabel.hidden = false
                cell.rankLabel.clipsToBounds = true
                cell.rankLabel.layer.cornerRadius = 15
            }else{
                cell.rankLabel.hidden = true
            }
            cell.title.text = theMovie.title
            cell.image.kf_setImageWithURL(NSURL(string: theMovie.large_pic )!)
            cell.cancelRating()
            if is_update_star{
                cell.updateRatingSize(15)
            }
            cell.update(theMovie.points/2.0)
            cell.pointLabel.text = String(format:"%.1f", theMovie.points) + "分"
            cell.messageLabel.text = String(theMovie.review_size) + "人留言"
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collCell", forIndexPath: indexPath) as! MovieCollectionCell
            let theMovie = self.thisWeekMovies[indexPath.row]
            cell.rankLabel.hidden = true
            cell.title.text = theMovie.title
            cell.image.kf_setImageWithURL(NSURL(string: theMovie.large_pic )!)
            cell.cancelRating()
            cell.update(theMovie.points/2.0)
            cell.pointLabel.text = String(format:"%.1f", theMovie.points) + "分"
            cell.messageLabel.text = String(theMovie.review_size) + "人留言"
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collCell", forIndexPath: indexPath) as! MovieCollectionCell
            let theMovie = self.secondMovies[indexPath.row]
            cell.rankLabel.hidden = true
            cell.title.text = theMovie.title
            cell.image.kf_setImageWithURL(NSURL(string: theMovie.large_pic )!)
            cell.cancelRating()
            cell.update(theMovie.points/2.0)
            cell.pointLabel.text = String(format:"%.1f", theMovie.points) + "分"
            cell.messageLabel.text = String(theMovie.review_size) + "人留言"
            return cell
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collCell", forIndexPath: indexPath) as! MovieCollectionCell
            return cell
        }
        
    }
    
    // MARK MovieAPI
    
    let host = "http://139.162.10.76"
    
    func getMovieTaipeiRanks()
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = NSURL(string: host + "/api2/movie/pub_movies")
        let session = NSURLSession.sharedSession()
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
                let newMovie = Movie.init(movie_id: id!, title: title, small_pic: small_pic, large_pic: large_pic, points: point, review_size: review_size!,publish_date: "")
                self.rankMovies.append(newMovie)
                print(title)

            }
            // update UI
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    if self.segmentControl.selectedSegmentIndex == 0{
                        self.collectionView.reloadData()
                    }
                }
                
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
        task.resume()
        print(NSDate())
    }
    
    func getMovieThisWeek()
    {
        let url = NSURL(string: host + "/api2/movie/movies?movie_round=4")
        let session = NSURLSession.sharedSession()
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
                let newMovie = Movie.init(movie_id: id!, title: title, small_pic: small_pic, large_pic: large_pic, points: point, review_size: review_size!,publish_date: "")
                self.thisWeekMovies.append(newMovie)
                print(title)
                
            }
            // update UI
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    if self.segmentControl.selectedSegmentIndex == 1{
                        self.collectionView.reloadData()
                    }
                }
                
            }
            
        })
        task.resume()
        print(NSDate())
    }
    
    func getSecondMovies()
    {
        let url = NSURL(string: host + "/api2/movie/second_movies")
        let session = NSURLSession.sharedSession()
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
                let newMovie = Movie.init(movie_id: id!, title: title, small_pic: small_pic, large_pic: large_pic, points: point, review_size: review_size!, publish_date: "")
                self.secondMovies.append(newMovie)
                print(title)
                
            }
            // update UI
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    if self.segmentControl.selectedSegmentIndex == 2{
                        self.collectionView.reloadData()
                    }
                }
                
            }
            
        })
        task.resume()
        print(NSDate())
    }
    
    func getUpGoingMovies()
    {
        let url = NSURL(string: host + "/api2/movie/up_going_movies")
        let session = NSURLSession.sharedSession()
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
                let point = 0.0
                let review_size = 0
                let publish_date = movie["publish_date"].stringValue
                let newMovie = Movie.init(movie_id: id!, title: title, small_pic: small_pic, large_pic: large_pic, points: point, review_size: review_size, publish_date: publish_date)
                self.upGoingMovies.append(newMovie)
                print(title)
                
            }
            // update UI
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    if self.segmentControl.selectedSegmentIndex == 3{
                        self.collectionView.reloadData()
                    }
                }
                
            }
            
        })
        task.resume()
        print(NSDate())
    }
    
    

}

