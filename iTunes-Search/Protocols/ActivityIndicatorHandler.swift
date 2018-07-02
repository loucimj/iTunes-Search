//
//  ActivityIndicatorHandler.swift
//  Qeeptouch
//
//  Created by Javi on 5/24/16.
//  Copyright © 2016 Qeeptouch. All rights reserved.
//

import Foundation
import UIKit


class ActivityIndicatorData {
    static var sharedInstance = ActivityIndicatorData()
    var count: Int =  0
}

protocol ActivityIndicatorHandler {
    
}

extension ActivityIndicatorHandler {
    func startActivityIndicator() {
        ActivityIndicatorData.sharedInstance.count += 1
        checkStatusAndStartActivityIndicator()
    }
    
    func stopActivityIndicator() {
        ActivityIndicatorData.sharedInstance.count -= 1
        checkStatusAndStartActivityIndicator()
    }
    
    fileprivate func checkStatusAndStartActivityIndicator() {
        #if EXTENSION_APP
        #else
        if UIApplication.shared.isNetworkActivityIndicatorVisible {
            if ActivityIndicatorData.sharedInstance.count == 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        } else {
            if ActivityIndicatorData.sharedInstance.count > 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
        #endif
    }
}
