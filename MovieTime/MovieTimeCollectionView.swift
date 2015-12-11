//
//  MovieTimeCollectionView.swift
//  MovieTime
//
//  Created by Ko LiChung on 12/2/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class MovieTimeCollectionView: UICollectionView,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    var movieTheaterTimes = [MovieTime]()
    
    func setMovieTheaterTimes(times: [MovieTime]){
        self.movieTheaterTimes = times
        self.reloadData()
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
            
            let num_for_one_rows: Int = Int((collectionView.frame.size.width - 46)/90) // count
            let movie_time = movieTheaterTimes[indexPath.row].movie_time!
            let time_array = movie_time.componentsSeparatedByString(",")
            var cell_height = 0
            if( time_array.count % num_for_one_rows ) > 0{
                cell_height = Int( time_array.count / num_for_one_rows + 1) * 40 + 10 + 45
            }else{
                cell_height = Int( time_array.count / num_for_one_rows) * 40 + 10 + 45
                
            }
            
            return CGSize(width: cell_width, height: CGFloat(cell_height))
            
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
        return movieTheaterTimes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("theaterCell", forIndexPath: indexPath) as! TheaterTimeCell
        if let theater = Theater.getTheaterByID(movieTheaterTimes[indexPath.row].theater_id!){
            cell.title.text = theater.name! + " "+movieTheaterTimes[indexPath.row].remark!
        }else{
            cell.title.text = "此戲院為新增戲院,更新App即可看到"
        }
        
        cell.times = movieTheaterTimes[indexPath.row].movie_time!.componentsSeparatedByString(",")
        cell.timeCollection.delegate = cell
        cell.timeCollection.dataSource = cell
        cell.timeCollection.reloadData()
        
        return cell
    }

}
