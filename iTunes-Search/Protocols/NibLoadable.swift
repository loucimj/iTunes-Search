//
//  NibLoadable.swift
//
//  Created by Javier Loucim on 10/15/16.
//  Copyright © 2016 Javier Loucim. All rights reserved.
//

import Foundation
import UIKit

protocol NibLoadable: class {
}

extension NibLoadable where Self: UIView {
    
    static var nibName: String {
        // notice the new describing here
        // now only one place to refactor if describing is removed in the future
        return String(describing: self)
    }
    
    
    static func initFromNib() -> Self {
        
        return Bundle.main.loadNibNamed(self.nibName, owner: self, options: nil)?.first as! Self
        
    }
}
