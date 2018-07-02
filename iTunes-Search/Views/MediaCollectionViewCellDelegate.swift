//
//  MediaCollectionViewCellDelegate.swift
//  iTunes-Search
//
//  Created by Javier Loucim on 01/07/2018.
//  Copyright © 2018 Qeeptouch. All rights reserved.
//

import Foundation

protocol MediaCollectionViewCellDelegate {
    func userWantsToSeeMedia(type:MediaTypeSelection, media:Media)
}

protocol MediaConfigurable {
    func configure(with delegate:MediaCollectionViewCellDelegate?, media:Media)
}
