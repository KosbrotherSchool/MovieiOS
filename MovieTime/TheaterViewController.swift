//
//  TheaterViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/13/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class TheaterViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    var areas = [Area]()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        areas = Area.getAreas()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    // MARK Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AreaTheaterSegue" {
            let areaTheaterViewController = segue.destinationViewController as! AreaTheaterViewController
            if let selecteCell = sender as? AreaCell {
                let indexPath = collectionView.indexPathForCell(selecteCell)!
                let selectedArea = areas[indexPath.row]
                areaTheaterViewController.area_id = selectedArea.area_id!
            }
            
        }
    }
    
    
    // MARK spacing of collectionview
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let cell_width = (collectionView.frame.size.width-20)/3
            let cell_height = cell_width
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
        return areas.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AreaCell", forIndexPath: indexPath) as! AreaCell
        let area = areas[indexPath.row]
        cell.areaLabel.text = area.name
    
        return cell
    }
    
}
