//
//  MovieFavCell.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/23/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import Cosmos

class MovieFavCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var rating: CosmosView!
    
    func cancelRating(){
        self.rating.settings.updateOnTouch = false
    }
    
    func update(rating: Double) {
        self.rating.rating = rating
    }
    
}
