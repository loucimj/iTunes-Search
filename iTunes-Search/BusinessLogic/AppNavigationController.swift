//
//  AppNavigationController.swift
//  iTunes-Search
//
//  Created by Javier Loucim on 01/07/2018.
//  Copyright © 2018 Qeeptouch. All rights reserved.
//

import Foundation
import UIKit

protocol AppNavigationController {
    
}

extension AppNavigationController where Self: UIViewController {
    func navigateToMediaPlayback(type:MediaTypeSelection, media:Media) {
        switch type {
        case .music,.movies,.tvShows:
            let viewController = PlaybackViewController.initFromStoryboard()
            viewController.media = media
            viewController.type = type
            viewController.providesPresentationContextTransitionStyle = true
            viewController.definesPresentationContext = true
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: false, completion: nil)
        default:
            break
        }
    }
}
