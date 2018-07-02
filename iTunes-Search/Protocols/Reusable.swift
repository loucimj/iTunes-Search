//
//  ReusableView.swift
//
//  Created by Javier Loucim on 10/15/16.
//  Copyright © 2016 Javier Loucim. All rights reserved.
//

import Foundation
import UIKit

protocol Reusable {
    
}

extension Reusable where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}

extension UITableViewCell: Reusable {
    
}

extension UICollectionViewCell: Reusable {
    
}
