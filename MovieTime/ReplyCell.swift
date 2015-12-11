//
//  ReplyCell.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/30/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit
import DOFavoriteButton

class ReplyCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var pub_date: UILabel!
    @IBOutlet weak var likeButton: DOFavoriteButton!
    @IBOutlet weak var likeNum: UILabel!
    @IBOutlet weak var content: UILabel!
    
    
}
