//
//  TheaterTimeCell.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/4/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class TheaterTimeCell: UICollectionViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource  {
    
    var times = [String]()
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var timeCollection: UICollectionView!
    
    
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
            
            let cell_width = 80
            let cell_height = 30
            
            return CGSize(width: CGFloat(cell_width), height: CGFloat(cell_height))
            
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
        return times.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("movieTimeCell", forIndexPath: indexPath) as! TimeCell
        cell.movieTime.text = self.times[indexPath.row]
        
        return cell
    }

    
    
}
