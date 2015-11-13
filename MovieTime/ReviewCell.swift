//
//  ReviewCell.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/12/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import Cosmos

class ReviewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publish_date_label: UILabel!
    @IBOutlet weak var point_label: UILabel!
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var content_label: UILabel!
    
    func cancelRating(){
        ratingBar.settings.updateOnTouch = false
    }
    
    func updateRating(rating: Double) {
        ratingBar.rating = rating
    }
    
}
