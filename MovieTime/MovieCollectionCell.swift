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
    @IBOutlet weak var rankLabel: UILabel!
    
    
    func cancelRating(){
        cosmosView.settings.fillMode = .Half
        cosmosView.settings.updateOnTouch = false
    }
    
    func update(rating: Double) {
        cosmosView.rating = rating
    }
    
    func updateRatingSize(size:Double){
        cosmosView.settings.starSize = size
    }
    
}

