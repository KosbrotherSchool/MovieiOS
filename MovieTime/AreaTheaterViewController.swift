//
//  AreaTheaterViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/15/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class AreaTheaterViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var theaters = [Theater]()
    var area_id:Int!
    
    override func viewDidLoad() {
        
        // Mark get posts from net
        theaters = Theater.getTheaters(area_id)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    
    // MARK Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TheaterTimeSegue" {
            let theaterTimeViewController = segue.destinationViewController as! TheaterTimeViewController
            if let selecteCell = sender as? AreaTheaterCell {
                let indexPath = collectionView.indexPathForCell(selecteCell)!
                let theater = theaters[indexPath.row]
                theaterTimeViewController.theater_id = theater.theater_id!
                theaterTimeViewController.theater_name = theater.name!
                theaterTimeViewController.theater_address = theater.address!
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
            let cell_width = collectionView.frame.size.width-16
            
            let font = UIFont(name: "Verdana", size: 25)
            let name_height = self.heightForLabel(self.theaters[indexPath.row].name!, font: font!, width: cell_width)
            
            let font2 = UIFont(name: "Verdana", size: 18)
            let address_height = self.heightForLabel(self.theaters[indexPath.row].address!, font: font2!, width: cell_width)
            let phone_height = self.heightForLabel("label", font: font2!, width: cell_width)
            
            let cell_height = name_height + address_height + phone_height + 32
            
            return CGSize(width: cell_width, height: cell_height)
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
        return theaters.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AreaTheaterCell", forIndexPath: indexPath) as! AreaTheaterCell
        
        let theater = self.theaters[indexPath.row]
        
        cell.nameLabel.text = theater.name!
        cell.addressLabel.text = theater.address!
        cell.phoneLabel.text = theater.phone!
        
        return cell
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

    
}
