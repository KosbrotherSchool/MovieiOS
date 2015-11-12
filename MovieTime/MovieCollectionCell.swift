//
//  MovieCollectionCell.swift
//  MovieTime
//
//  Created by Ko LiChung on 10/29/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import Cosmos

class MovieCollectionCell: UICollectionViewCell{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    
    
    func cancelRating(){
        cosmosView.settings.updateOnTouch = false
    }
    
    func update(rating: Double) {
        cosmosView.rating = rating
    }
    
    
}

