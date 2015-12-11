//
//  MovieDetailViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 10/31/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import SwiftyJSON
import Cosmos
import Kingfisher
import JLToast

extension String {
    var html2AttributedString: NSAttributedString? {
        guard
            let data = dataUsingEncoding(NSUTF8StringEncoding)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

class MovieDetailViewController: UIViewController, UINavigationControllerDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    @IBOutlet weak var areaCollectionView: UICollectionView!
    
    @IBOutlet weak var theaterTimeCollectionView: MovieTimeCollectionView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieClassLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieTitleEngLabel: UILabel!
    @IBOutlet weak var movieLengthLabel: UILabel!
    @IBOutlet weak var moviePublishLabel: UILabel!
    @IBOutlet weak var moviePointLabel: UILabel!
    @IBOutlet weak var movieRatting: CosmosView!
    
    @IBOutlet weak var trailerView: UIView!
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var trailerLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var photoLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBAction func readMoreInfo(sender: UIButton) {
        
        let alert = UIAlertController(title: "電影簡介", message: self.theMovie!.movie_info!.html2String, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var officialLabel: UILabel!
    
    
    @IBOutlet weak var imdbButton: UIButton!
    @IBAction func goImdb(sender: UIButton) {
    }
    @IBOutlet weak var rottenTomatoButton: UIButton!
    @IBAction func goRottenTomato(sender: UIButton) {
    }
    
    
    @IBAction func changeSegment(sender: UISegmentedControl) {
        self.resetViewBySegmentControl()
    }
    
    func resetViewBySegmentControl(){
        if Reachability.isConnectedToNetwork(){
            switch segmentControl.selectedSegmentIndex
            {
            case 0:
                scrollView.hidden = false
                timeView.hidden = true
                break;
            case 1:
                scrollView.hidden = true
                timeView.hidden = false
                break;
            default:
                break;
            }
        }else{
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
        }
    }
    
    var theMovie: Movie!
    var movieAreas = [Area]()
    var movieTheaterTimes = [MovieTime]()
    var selected_area_id = 0
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var is_loved = false
    var theFavMovie:FavMovie!
    @IBOutlet weak var loveButton: UIBarButtonItem!
    @IBAction func checkLove(sender: UIBarButtonItem) {
        
        switch is_loved{
        case true:
            is_loved = false
            FavMovie.deleteTheFavTheater(moc, theMovie: theFavMovie)
            loveButton.image = UIImage(named: "love")
        case false:
            is_loved = true
            theFavMovie = FavMovie.add(moc, title: theMovie!.title, pic_link: theMovie!.large_pic, point: theMovie!.points, movie_id: theMovie!.movie_id)
            loveButton.image = UIImage(named: "icon_love_white_full")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = theMovie.title
        timeView.hidden = true
        scrollView.hidden = true
        
        theaterTimeCollectionView.delegate = theaterTimeCollectionView.self
        theaterTimeCollectionView.dataSource = theaterTimeCollectionView.self
        
        areaCollectionView.delegate = self
        areaCollectionView.dataSource = self
        
        // MARK get movie area and theaters and movie time
        getMovieAreasByMovieID((theMovie?.movie_id)!)
        
        // Mark get movie info
        getMovieInfo((theMovie?.movie_id)!)
        
        trailerView.layer.cornerRadius = 3
        reviewView.layer.cornerRadius = 3
        photoView.layer.cornerRadius = 3
        
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        
        if let favMovie = FavMovie.queryByMovieID(moc, movie_id: theMovie!.movie_id){
            is_loved = true
            theFavMovie = favMovie
            loveButton.image = UIImage(named: "icon_love_white_full")
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
        swipeRight.direction = .Right
        self.timeView.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
        swipeLeft.direction = .Left
        self.scrollView.addGestureRecognizer(swipeLeft)
        
    }
    
    func swipedRight(sender:UIGestureRecognizer){
        let currentIndex = segmentControl.selectedSegmentIndex
        if currentIndex > 0{
            segmentControl.selectedSegmentIndex = currentIndex - 1
        }
        self.resetViewBySegmentControl()
    }
    
    func swipedLeft(sender:UIGestureRecognizer){
        let currentIndex = segmentControl.selectedSegmentIndex
        if currentIndex < 1{
            segmentControl.selectedSegmentIndex = currentIndex + 1
        }
        self.resetViewBySegmentControl()
    }

    
    // MARK Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TrailerDetail" {
            let trailerDetailViewController = segue.destinationViewController as! TrailerViewController
            trailerDetailViewController.movie_id = self.theMovie!.movie_id
        }
        if segue.identifier == "PhotoDetail" {
            let photoViewController = segue.destinationViewController as! PhotoViewController
            photoViewController.movie_id = self.theMovie!.movie_id
        }
        if segue.identifier == "ReviewDetail" {
            let reviewViewController = segue.destinationViewController as! ReviewViewController
            reviewViewController.movie_id = self.theMovie!.movie_id
        }

    }
    
    
    
    
    // MARK MovieAPI
    let host = "http://139.162.10.76"
    
    func getMovieInfo(movie_id: Int)
    {
        if !Reachability.isConnectedToNetwork(){
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
            return
        }
        
        let url = NSURL(string: host + "/api/movie/movies?movie_id=" + String(movie_id) )
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            print(NSDate())
            let jsonData = JSON(data: data!)
            let id = jsonData["id"].int
            let title = jsonData["title"].stringValue
            let title_eng = jsonData["title_eng"].stringValue
            let movie_class = jsonData["movie_class"].stringValue
            let movie_type = jsonData["movie_type"].stringValue
            let movie_length = jsonData["movie_length"].stringValue
            let publish_date = jsonData["publish_date"].stringValue
            let director = jsonData["director"].stringValue
            let editors = jsonData["editors"].stringValue
            let actors = jsonData["actors"].stringValue
            let official = jsonData["official"].stringValue
            let movie_info = jsonData["movie_info"].stringValue
            let small_pic = jsonData["small_pic"].stringValue
            let large_pic = jsonData["large_pic"].stringValue
            let movie_round = jsonData["movie_round"].int
            let photo_size = jsonData["photo_size"].int
            let trailer_size = jsonData["trailer_size"].int
            let points = jsonData["point"].doubleValue
            let review_size = jsonData["review_size"].int
            let imdb_point = jsonData["imdb_point"].stringValue
            let imdb_link = jsonData["imdb_link"].stringValue
            let potato_point = jsonData["potato_point"].stringValue
            let potato_link = jsonData["potato_link"].stringValue
            
            let newMovie = Movie.init(movie_id: id!, title: title, title_eng: title_eng, movie_class: movie_class, movie_type: movie_type, movie_length: movie_length, publish_date: publish_date, director: director, editors: editors, actors: actors, official: official, movie_info: movie_info, small_pic: small_pic, large_pic: large_pic, movie_round: movie_round!, photo_size: photo_size!, trailer_size: trailer_size!, points: points, review_size: review_size!, imdb_point: imdb_point, imdb_link: imdb_link, potato_point: potato_point, potato_link: potato_link)
            self.theMovie = newMovie
            
            // update UI
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {

                dispatch_async(dispatch_get_main_queue()) {
                    // set movie info here
                    let icon_image = UIImage(named: "app_icon")
                    self.movieImage.kf_setImageWithURL(NSURL(string: self.theMovie!.large_pic )!, placeholderImage: icon_image)
                    self.movieClassLabel.text = self.theMovie!.movie_class!
                    self.movieTitleLabel.text = self.theMovie!.title
                    self.movieTitleEngLabel.text = self.theMovie!.title_eng!
                    self.movieLengthLabel.text = "片長：" + self.theMovie!.movie_length!
                    self.moviePublishLabel.text = self.theMovie!.publish_date!
                    self.moviePointLabel.text = String(self.theMovie!.points) + "分"
                    self.movieRatting.rating = self.theMovie!.points / 2
                    self.movieRatting.settings.updateOnTouch = false
                    self.movieRatting.settings.fillMode = .Half
                    
                    self.infoLabel.text = self.theMovie!.movie_info?.html2String
                    
                    self.typeLabel.text = self.theMovie!.movie_type!
                    self.directorLabel.text = self.theMovie!.director!
                    self.actorsLabel.text = self.theMovie!.actors!
                    self.officialLabel.text = self.theMovie!.official!
                    
                    self.trailerLabel.text = "影片("+String(self.theMovie!.trailer_size!)+")"
                    self.messageLabel.text = "留言("+String(self.theMovie!.review_size)+")"
                    self.photoLabel.text = "圖集("+String(self.theMovie!.photo_size!)+")"
                    
                    self.imdbButton.titleLabel!.text = "IMDB "+self.theMovie!.imdb_point!+"分"
                    self.rottenTomatoButton.titleLabel!.text = "爛番茄 "+self.theMovie!.potato_point!+"%"
                    let font = UIFont(name: "Verdana", size: 14)
                    
                    self.scrollView.contentSize = CGSizeMake(
                        self.scrollView.contentSize.width,
                        self.scrollView.contentSize.height
                            - self.heightForLabel("label", font: font!, width: self.actorsLabel.frame.width)*5
                            + self.heightForLabel(self.theMovie!.actors!, font: font!, width: self.actorsLabel.frame.width)
                            + self.heightForLabel(self.theMovie!.director!, font: font!, width: self.actorsLabel.frame.width)
                            + self.heightForLabel(self.theMovie!.movie_type!, font: font!, width: self.actorsLabel.frame.width)
                            + self.heightForLabel(self.theMovie!.official!, font: font!, width: self.actorsLabel.frame.width)
                            + self.heightForLabel("label", font: font!, width: self.actorsLabel.frame.width)*2 // for info label
                    );
                    
                    self.indicator.stopAnimating()
                    
                    switch self.segmentControl.selectedSegmentIndex
                    {
                    case 0:
                        self.scrollView.hidden = false
                        self.timeView.hidden = true
                        break;
                    case 1:
                        self.scrollView.hidden = true
                        self.timeView.hidden = false
                        break;
                    default:
                        break;
                    }
                }
                
            }
            
        })
        task.resume()
        print(NSDate())
    
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
            
            return CGSize(width: 80, height: 34)
            
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
        return movieAreas.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TimeAreaCell", forIndexPath: indexPath) as! TimeAreaCell
        let area = movieAreas[indexPath.row]
        cell.label.text = area.name
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        for cell in collectionView.visibleCells(){
            cell.backgroundColor = UIColor.whiteColor()
        }
        let cell = collectionView.cellForItemAtIndexPath(indexPath)! as! TimeAreaCell
        cell.backgroundColor = UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
        selected_area_id = movieAreas[indexPath.row].area_id!
        
        self.movieTheaterTimes.removeAll()
        self.theaterTimeCollectionView.setMovieTheaterTimes(self.movieTheaterTimes)
        getAreaMovieTimes(theMovie.movie_id, area_id: selected_area_id)
    }
    
    func collectionView(collectionView: UICollectionView,willDisplayCell cell: UICollectionViewCell,forItemAtIndexPath indexPath: NSIndexPath){
        if(selected_area_id == movieAreas[indexPath.row].area_id!){
            cell.backgroundColor = UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
        }else{
            cell.backgroundColor = UIColor.whiteColor()
        }
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
    
    func getMovieAreasByMovieID(movie_id: Int)
    {
        if !Reachability.isConnectedToNetwork(){
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = NSURL(string: host + "/api/movie/areas?movie_id=" + String(movie_id) ) //小王子
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            print(NSDate())
            let jsonData = JSON(data: data!)
            for area in jsonData.arrayValue{
                let area_id = area["id"].int
                let name = area["name"].stringValue
                let newArea = Area.init(name: name, area_id: area_id!)
                self.movieAreas.append(newArea)
                print(name)
                
            }
            // update UI
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    // set areas here
                    if self.movieAreas.count > 0{
                        self.selected_area_id = self.movieAreas[0].area_id!
                        self.areaCollectionView.reloadData()
                        self.getAreaMovieTimes(movie_id, area_id: (self.movieAreas.first?.area_id)! )
                    }else{
                        // show no publishing theater
                    }
                }
                
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
        task.resume()
        print(NSDate())
    }
    
    func getAreaMovieTimes(movie_id: Int, area_id: Int)
    {
        if !Reachability.isConnectedToNetwork(){
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = NSURL(string: host + "/api/movie/movietimes?movie="+String(movie_id)+"&area="+String(area_id) ) //小王子
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            print(NSDate())
            let jsonData = JSON(data: data!)
            for movieTime in jsonData.arrayValue{
                
                var remark = "";
                var movie_title = "";
                var movie_time = "";
                var movie_id = 0;
                var theater_id = 0;
                var movie_photo="";
                
                remark = movieTime["remark"].stringValue
                movie_title = movieTime["movie_title"].stringValue
                movie_time = movieTime["movie_time"].stringValue
                movie_id = movieTime["movie_id"].int!
                theater_id = movieTime["theater_id"].int!
                do {
                  movie_photo = movieTime["movie_photo"].stringValue
                }
                let newMovieTime = MovieTime.init(remark: remark, movie_title: movie_title, movie_time: movie_time, movie_id: movie_id, theater_id: theater_id, movie_photo: movie_photo)
                self.movieTheaterTimes.append(newMovieTime)
                print(movie_time)
            }
            // update UI
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    // set areas here
                    self.theaterTimeCollectionView.setMovieTheaterTimes(self.movieTheaterTimes)
                }
                
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
        })
        task.resume()
        print(NSDate())
    }
    
}
