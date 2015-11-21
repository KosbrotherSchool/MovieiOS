//
//  NoCursorTextField.swift
//  MovieTime
//
//  Created by Ko LiChung on 11/21/15.
//  Copyright © 2015 Ko LiChung. All rights reserved.
//

import UIKit

class NoCursorTextField: UITextField {
    
    override func caretRectForPosition(position: UITextPosition) -> CGRect {
        return CGRectZero
    }
    
}
