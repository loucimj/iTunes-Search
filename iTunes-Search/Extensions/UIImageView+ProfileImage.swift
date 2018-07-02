//
//  UIImageView+ProfileImage.swift
//  iPulse
//
//  Created by Javier Loucim on 10/22/16.
//  Copyright © 2016 Javier Loucim. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import Alamofire
import ObjectiveC

private var fullImageURLAssociationKey: UInt8 = 0

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIImageView {
    
    var fullImageURL: String? {
        get {
            return objc_getAssociatedObject(self, &fullImageURLAssociationKey) as! String?
        } set(newValue) {
            objc_setAssociatedObject(self, &fullImageURLAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    func getLargeProfileImage(_ imageCode:String, makeCircular:Bool = true, dropShadow: Bool = false, completionBlock: ((DataResponse<UIImage>?)->())? = nil) {
        
        let urlString = ServiceAbsoluteEndpoint.SMUImage.rawValue + "/" + imageCode + "/1024/1024/2?o=MF_IOS&v=1.0"
        let url = URL(string: urlString )

        let placeholderImage:UIImage = ( makeCircular == true ) ? UIImage.from(color: UIColor.darkGray).af_imageRoundedIntoCircle() : UIImage.from(color: UIColor.darkGray)
        
        
        Alamofire.DataRequest.addAcceptableImageContentTypes(["image/jpg"])
        
        if makeCircular {
            self.makeCircular()
        }
        if dropShadow {
            self.dropShadow()
        }
        
        self.af_setImage(withURL: url!, placeholderImage: placeholderImage, filter: nil, progress: nil
            , progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.4), runImageTransitionIfCached: false
            , completion: { dataResponse in
                if makeCircular {
                    self.makeCircular()
                }
                if let block = completionBlock {
                    block(dataResponse)
                }
            }
        )
        
    }

    func getEvaluationImage(_ imageCode:String, makeCircular:Bool = true, tint: UIColor, completionBlock: ((DataResponse<UIImage>)->())? = nil) {
        
        guard !imageCode.isEmpty else {
            self.image = UIImage(named: "profilePlaceholder")!
            print("WARNING: Profile Image Code is Empty.")
            return
        }
        let scale = UIScreen.main.scale
        var urlString:String = ""
        if imageCode.substring(to: imageCode.index(imageCode.startIndex, offsetBy: 4)) == "http" {
            urlString = imageCode
        } else {
            urlString = ServiceAbsoluteEndpoint.SMUImage.rawValue + "/" + imageCode + "/28/28/2?o=MF_IOS&v=1.0"
        }
        
        let url = URL(string: urlString )
        
        let placeholderImage:UIImage = ( makeCircular == true ) ? UIImage(named: "profilePlaceholder")!.af_imageRoundedIntoCircle() : UIImage(named: "profilePlaceholder")!
        
        
        loadImage(url: url!, makeCircular: makeCircular, placeholderImage: placeholderImage, tint: tint, completionBlock: completionBlock)
    }
    
    func getProfileImage(_ imageCode:String, makeCircular:Bool = true, border : CGFloat = 0, completionBlock: ((DataResponse<UIImage>)->())? = nil) {
        
        guard !imageCode.isEmpty else {
            self.image = UIImage(named: "profilePlaceholder")!
            print("WARNING: Profile Image Code is Empty.")
            return
        }
        
        var urlString:String = ""
        if imageCode.substring(to: imageCode.index(imageCode.startIndex, offsetBy: 4)) == "http" {
            urlString = imageCode
        } else {
            urlString = ServiceAbsoluteEndpoint.SMUImage.rawValue + "/" + imageCode + "/200/200/2?o=MF_IOS&v=1.0"
        }
        
        let url = URL(string: urlString )
        
        let placeholderImage:UIImage = ( makeCircular == true ) ? UIImage(named: "profilePlaceholder")!.af_imageRoundedIntoCircle() : UIImage(named: "profilePlaceholder")!
        
        
        loadImage(url: url!, makeCircular: makeCircular, border: border, placeholderImage: placeholderImage, completionBlock: completionBlock)
    }
    
    func loadImageWithPlaceholder(imageCode:String, placeholder:UIImage) {
        var urlString:String = ""
        if imageCode.substring(to: imageCode.index(imageCode.startIndex, offsetBy: 4)) == "http" {
            urlString = imageCode
        } else {
            urlString = ServiceAbsoluteEndpoint.SMUImage.rawValue + "/" + imageCode + "/200/200/2?o=MF_IOS&v=1.0"
        }
        let url = URL(string: urlString )
        loadImage(url: url!, makeCircular: false, border: 0, placeholderImage: placeholder, tint: UIColor.clear, completionBlock: nil,contentMode: .scaleAspectFit)
    }
    
    fileprivate func loadImage (url: URL, makeCircular:Bool, border : CGFloat = 0, placeholderImage:UIImage, tint: UIColor = .clear, completionBlock: ((DataResponse<UIImage>)->())? = nil, contentMode: UIViewContentMode = .center ){
        Alamofire.DataRequest.addAcceptableImageContentTypes(["image/jpg"])
        
        var filter:AspectScaledToFillSizeWithRoundedCornersFilter? = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: self.frame.size,
            radius: 0
        )
        if contentMode == .scaleAspectFit {
            filter = nil
        }
        if makeCircular {
            self.makeCircular(border: border)
        }
        
        self.af_setImage(withURL: url, placeholderImage: placeholderImage, filter: filter, progress: nil,
                         progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.2),
                         runImageTransitionIfCached: false,
                         completion: { dataResponse in
                            if makeCircular {
                                self.makeCircular()
                            }
                            if tint != .clear {
                                if let myImage : UIImage = dataResponse.result.value {
                                    self.image = myImage.imageWith(color: tint)
                                }
                            }
                            if let block = completionBlock {
                                block(dataResponse)
                            }
        }
        )
    }
    
    
    func makeCircular(border : CGFloat = 0) {
        self.layer.cornerRadius = self.frame.size.height / 2;
        self.layer.masksToBounds = true
        if border != 0 {
            self.layer.borderWidth = border
            self.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    convenience init(baseImageView: UIImageView, frame: CGRect) {
        self.init(frame: CGRect.zero)
        
        image = baseImageView.image
        contentMode = baseImageView.contentMode
        clipsToBounds = true
        self.frame = frame
    }
}
