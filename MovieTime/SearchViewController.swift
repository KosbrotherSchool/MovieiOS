//
//  SearchViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/23/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
import JLToast

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    var dataArray = [Movie]()
    var searchController: UISearchController!
    var mPage = 1
    var searchString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        configureSearchController()
    }
    
    // MARK Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
            let movieDetailViewController = segue.destinationViewController as! MovieDetailViewController
            
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? MovieSearchCell {
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMovie = dataArray[indexPath.row]
                movieDetailViewController.theMovie = selectedMovie
            }
        
    }

    
    // MARK: UITableView Delegate and Datasource functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieSearchCell", forIndexPath: indexPath) as! MovieSearchCell
        
        let movie = dataArray[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.titleEngLabel.text = movie.title_eng!
        cell.typeLabel.text = movie.movie_type!
        cell.classLabel.text = movie.movie_class!
        cell.pubDateLabel.text = movie.publish_date!
        let icon_image = UIImage(named: "app_icon")
        cell.movieImageView.kf_setImageWithURL(NSURL(string: movie.small_pic)!,placeholderImage: icon_image)
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == dataArray.count - 10{
            if mPage != -1{
                print("load more, page = \(mPage)")
                mPage = mPage + 1
                self.searchMovie(searchString, page: mPage)
            }
        }
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140.0
    }
    
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "輸入搜索片名"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
        
        // Place the search bar view to the tableview headerview.
        tableView.tableHeaderView = searchController.searchBar
    }
    
    // MARK: UISearchBarDelegate functions
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.mPage = 1
        self.dataArray.removeAll()
        self.tableView.reloadData()
        searchString = searchController.searchBar.text!
        if searchString != ""{
            self.searchMovie(searchString, page: 1)
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {

    }
    
    let host = "http://139.162.10.76"
    
    func searchMovie(query:String,page:Int)
    {
        if !Reachability.isConnectedToNetwork(){
            JLToast.makeText("沒有網路連線", duration: JLToastDelay.ShortDelay).show()
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = NSURL(string: host + "/api2/movie/search?query="+query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!+"&page="+String(page) )
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let req = NSURLRequest(URL: url!)
        
        //NSURLSessionDownloadTask is retured from session.dataTaskWithRequest
        let task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            
            print(NSDate())
            let jsonData = JSON(data: data!)
            
            if jsonData.count < 20{
                self.mPage = -1
            }
            
            if jsonData.count > 0{
                for movie in jsonData.arrayValue{
                    let id = movie["id"].int
                    let title = movie["title"].stringValue
                    let title_eng = movie["title_eng"].stringValue
                    let movie_class = movie["movie_class"].stringValue
                    let movie_type = movie["movie_type"].stringValue
                    let movie_length = movie["movie_length"].stringValue
                    let publish_date = movie["publish_date"].stringValue
                    let director = movie["director"].stringValue
                    let editors = movie["editors"].stringValue
                    let actors = movie["actors"].stringValue
                    let official = movie["official"].stringValue
                    let movie_info = movie["movie_info"].stringValue
                    let small_pic = movie["small_pic"].stringValue
                    let large_pic = movie["large_pic"].stringValue
                
                    let movie_round = 0
                    let photo_size = 0
                    let trailer_size = 0
                
                    let points = movie["point"].doubleValue
                
                    let review_size = 0
                
                    let imdb_point = movie["imdb_point"].stringValue
                    let imdb_link = movie["imdb_link"].stringValue
                    let potato_point = movie["potato_point"].stringValue
                    let potato_link = movie["potato_link"].stringValue
                
                    let newMovie = Movie.init(movie_id: id!, title: title, title_eng: title_eng, movie_class: movie_class, movie_type: movie_type, movie_length: movie_length, publish_date: publish_date, director: director, editors: editors, actors: actors, official: official, movie_info: movie_info, small_pic: small_pic, large_pic: large_pic, movie_round: movie_round, photo_size: photo_size, trailer_size: trailer_size, points: points, review_size: review_size, imdb_point: imdb_point, imdb_link: imdb_link, potato_point: potato_point, potato_link: potato_link)
                    self.dataArray.append(newMovie)
                    print(title)
                
                }
                // update UI
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    }
                }
            }
            
        })
        task.resume()
        print(NSDate())
    }
}
