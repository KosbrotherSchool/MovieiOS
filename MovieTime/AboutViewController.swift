//
//  AboutViewController.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/28/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
   
    @IBOutlet weak var aboutLabel: UILabel!
    
    override func viewDidLoad() {
        
        aboutLabel.text = "「電影即時通」由電影愛好者共同努力製作,我們盡力讓電影、電視劇的愛好者方便取的想要的資訊,有任何建議或合作, 請透過信箱與我們聯絡。\n\n內容如有不妥,也請告知我們,會儘速處理。好的空間需要大家一起來維持,感謝您！ ---- 電影即時通\n\nEmail: movietime@gmail.com"
        
        
    }
    
}
