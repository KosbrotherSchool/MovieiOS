//
//  BoardCollectionView.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/21/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class BoardCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var array = ["電影版","劇版","有好康","公告區","關於我們","投票區"]
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // how many cell in the collection view
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    // what look for every cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BoardCell", forIndexPath: indexPath) as! BoardCell
        print(indexPath.row)
        cell.label.text = array[indexPath.row]
        print("image\(indexPath.row+1)")
        cell.image.image = UIImage(named: "image\(indexPath.row+1)")
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 2.0
        let red = UIColor(red: 230.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        cell.layer.borderColor = red.CGColor
        return cell
    }
    
    // MARK delegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }
    
    // width and height of every cell
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let cell_width = (collectionView.frame.size.width-24)/2
            return CGSize(width: cell_width, height: 60)
            
            
    }

}
