//
//  MediaSectionController.swift
//  iTunes-Search
//
//  Created by Javier Loucim on 01/07/2018.
//  Copyright © 2018 Qeeptouch. All rights reserved.
//

import Foundation
import UIKit
import IGListKit

final class MediaSectionController: ListSectionController {
    
    var media:Media?
    var type:MediaTypeSelection = .music
    var delegate:MediaCollectionViewCellDelegate?
    
    convenience init(type:MediaTypeSelection, delegate:MediaCollectionViewCellDelegate?) {
        self.init()
        self.type = type
        self.delegate = delegate
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        var height:CGFloat = 0
        switch self.type {
        case .music:
            height = MusicCollectionViewCell.calculateHeight()
        case .movies:
            height = MovieCollectionViewCell.calculateHeight()
        case .tvShows:
            height = MovieCollectionViewCell.calculateHeight()
        }
        return CGSize(width: width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        var cellName = ""
        switch self.type {
        case .music:
            cellName = "MusicCollectionViewCell"
        case .movies:
            cellName = "MovieCollectionViewCell"
        case .tvShows:
            cellName = "MovieCollectionViewCell"
        }
        let cell = collectionContext!.dequeueReusableCell(withNibName: cellName, bundle: Bundle.main, for: self, at: index)
        if let configurableCell = cell as? MediaConfigurable, let media = self.media {
            configurableCell.configure(with: self.delegate, media: media)
        }
        return cell
    }
    override func didUpdate(to object: Any) {
        precondition(object is DiffableBox<Media>, "💥 Wrong data type on Post controller: ")
        let boxed = object as! DiffableBox<Media>
        self.media = boxed.value
    }
    
    override func didSelectItem(at index: Int) {

    }
    
}

