//
//  Alertable.swift
//  Qeeptouch
//
//  Created by Javier Loucim on 11/2/16.
//  Copyright © 2016 Javier Loucim. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

protocol Alertable {
    
}

extension Alertable where Self: UIViewController {
    fileprivate func setStyle() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setMinimumSize(CGSize(width: 250, height: 250))
        SVProgressHUD.setImageViewSize(CGSize(width: 60, height: 60))
//        SVProgressHUD.setFont(UIFont(name: "SFUIDisplay-Regular", size: 24)!)
        SVProgressHUD.setHapticsEnabled(true)
        SVProgressHUD.setCornerRadius(12)
    }
    

    func showAlertMessage(message:String, seconds: Double = 0.0, completionBlock: (()->())? = nil) {
        setStyle()
        SVProgressHUD.show(withStatus: message)
        if seconds > 0.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds ) {
                SVProgressHUD.dismiss()
                if completionBlock != nil {
                    completionBlock!()
                }
            }
        }
    }
    func showOKMessage(message:String, seconds: Double = 0.0, completionBlock: (()->())? = nil) {
        setStyle()
        SVProgressHUD.showSuccess(withStatus: message)
        if seconds > 0.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds ) {
                SVProgressHUD.dismiss()
                if completionBlock != nil {
                    completionBlock!()
                }
            }
        }
    }
    
    func showErrorMessage(message:String, seconds: Double = 0.0, completionBlock: (()->())? = nil) {
        setStyle()
        SVProgressHUD.showError(withStatus: message)
        if seconds > 0.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds ) {
                SVProgressHUD.dismiss()
                if completionBlock != nil {
                    completionBlock!()
                }
            }
        }
    }
    
    func showWaitingCircle() {
        setStyle()
        SVProgressHUD.show()
    }
    func showProgress(message:String, progress:Float) {
        setStyle()
        SVProgressHUD.showProgress(progress, status: message)
    }
    
    func hideAlertMessage(){
        SVProgressHUD.dismiss()
    }
}
