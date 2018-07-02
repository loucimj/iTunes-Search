//
//  UIView+Gesture.swift
//  Loqator-qa
//
//  Created by Javier Loucim on 25/03/2018.
//  Copyright © 2018 Qeeptouch. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    func respondToSelectorOnTap(target: Any, selector: Selector) {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: target, action: selector))
    }
    func respondToSelectorOnSwipeLeft(target: Any, selector: Selector) {
        self.isUserInteractionEnabled = true
        let gesture = UISwipeGestureRecognizer(target: target, action: selector)
        gesture.direction = .left
        self.addGestureRecognizer(gesture)
    }
    func respondToSelectorOnSwipeRight(target: Any, selector: Selector) {
        self.isUserInteractionEnabled = true
        let gesture = UISwipeGestureRecognizer(target: target, action: selector)
        gesture.direction = .right
        self.addGestureRecognizer(gesture)
    }
}
