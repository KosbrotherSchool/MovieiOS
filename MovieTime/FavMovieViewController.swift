//
//  FavMovieViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/23/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class FavMovieViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    var favMovies = [FavMovie]()
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        self.favMovies = FavMovie.getAll(moc)
        collectionView.reloadData()
    }
    
    // MARK Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let movieDetailViewController = segue.destinationViewController as! MovieDetailViewController
            
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? MovieFavCell {
                let indexPath = collectionView.indexPathForCell(selectedMealCell)!
                let selectedMovie = favMovies[indexPath.row]
                let movie = Movie.init(movie_id: Int(selectedMovie.movie_id!), title: selectedMovie.title!, small_pic: "", large_pic: selectedMovie.pic_link!, points: Double(selectedMovie.point!), review_size: 0)
                movieDetailViewController.theMovie = movie
            }
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
        return favMovies.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieFavCell", forIndexPath: indexPath) as! MovieFavCell
        
        let theMovie = self.favMovies[indexPath.row]
        cell.title.text = theMovie.title
        cell.image.kf_setImageWithURL(NSURL(string: theMovie.pic_link! )!)
        cell.cancelRating()
        cell.update(Double(theMovie.point!)/2.0)
        cell.point.text = String(format:"%.1f", Double(theMovie.point!)) + "分"
        
        return cell
    }

    
}
