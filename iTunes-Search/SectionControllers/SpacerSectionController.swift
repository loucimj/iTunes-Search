//
//  SpacerSectionController.swift
//
//  Created by Javier Loucim on 18/01/2018.
//  Copyright © 2018 Javier Loucim. All rights reserved.
//

import Foundation
import IGListKit
import UIKit

class IGListKitSpacer {
    var id:String = "IGListKitSpacer"
    var size: CGSize = CGSize.zero
    var color: UIColor = .clear
}

extension IGListKitSpacer: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        
        guard let object = object as? IGListKitSpacer else {
            return false
        }
        
        if object.id == self.id {
            return true
        }
        return false
    }
        
    static func ==(lhs: IGListKitSpacer, rhs: IGListKitSpacer) -> Bool {
        
        guard lhs.id == rhs.id else {
            return false
        }
        
        return true
    }
    
}

final class SpacerSectionController: ListSectionController {
    
    var spacer:IGListKitSpacer?
    
    convenience init(spacer:IGListKitSpacer) {
        self.init()
        self.spacer = spacer
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        if let spacer = self.spacer {
            var width:CGFloat = 0
            if spacer.size.width != 0 {
                width = spacer.size.width
            } else {
                width = collectionContext!.containerSize.width
            }
            let height:CGFloat = spacer.size.height
            return CGSize(width: width, height: height)
        }
        return CGSize.zero
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(withNibName: "SpacerCollectionViewCell", bundle: Bundle.main, for: self, at: index) as! SpacerCollectionViewCell
        if self.spacer != nil {
            cell.backgroundColor = spacer!.color
        }
        return cell
    }
    override func didUpdate(to object: Any) {
        //precondition(object is DiffableBox<SavedRating>, "💥 Wrong data type in controller ")
    }
    
    override func didSelectItem(at index: Int) {
        
    }
    
}
