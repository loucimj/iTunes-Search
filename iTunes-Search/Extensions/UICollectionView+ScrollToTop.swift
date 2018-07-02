//
//  UICollectionView+ScrollToTop.swift
//  iTunes-Search
//
//  Created by Javier Loucim on 01/07/2018.
//  Copyright © 2018 Qeeptouch. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func scrollToTop(animated : Bool = true) {
        guard self.numberOfSections > 0 else {
            print("👀 Can't scroll up in collection view")
            return
        }
        
        let section = 0
        if self.numberOfItems(inSection: section) > 0 {
            let item = 0
            let lastIndexPath = IndexPath(item: item, section: section)
            self.scrollToItem(at: lastIndexPath, at: .top, animated: animated)
        }
    }
}
