//
//  ReviewViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/12/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    
    
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
            return CGSize(width: cell_width, height: 100)
            
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
        return trailers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("trailerCell", forIndexPath: indexPath) as! TrailerCell
        cell.imageView.kf_setImageWithURL(NSURL(string: self.trailers[indexPath.row].getPicLink())!)
        cell.titleLabel.text = self.trailers[indexPath.row].title
        return cell
    }
    
    
}
