//
//  MovieDetailViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 10/31/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController, UINavigationControllerDelegate {
    
    var theMovie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = theMovie!.title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
