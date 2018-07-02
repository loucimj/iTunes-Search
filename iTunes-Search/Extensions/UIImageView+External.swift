//
//  UIImageView+External.swift
//  iTunes-Search
//
//  Created by Javier Loucim on 01/07/2018.
//  Copyright © 2018 Qeeptouch. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

extension UIImageView {
    func loadImageWithPlaceholder(imageURL:String, placeholder:UIImage) {
        let url = URL(string: imageURL )
        loadImage(url: url!, makeCircular: false, border: 0, placeholderImage: placeholder, tint: UIColor.clear, completionBlock: nil,contentMode: self.contentMode)
    }
    
    fileprivate func loadImage (url: URL, makeCircular:Bool, border : CGFloat = 0, placeholderImage:UIImage, tint: UIColor = .clear, completionBlock: ((DataResponse<UIImage>)->())? = nil, contentMode: UIViewContentMode = .center ){
        Alamofire.DataRequest.addAcceptableImageContentTypes(["image/jpg"])
        
        var filter:AspectScaledToFillSizeWithRoundedCornersFilter? = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: self.frame.size,
            radius: 0
        )
        if contentMode == .scaleAspectFit || contentMode == .scaleAspectFill {
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
}
