//
//  MusicCollectionViewCell.swift
//  iTunes-Search
//
//  Created by Javier Loucim on 30/06/2018.
//  Copyright © 2018 Qeeptouch. All rights reserved.
//

import UIKit


class TinyMusicCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    var delegate:MediaCollectionViewCellDelegate?
    var media:Media?
    
    class func calculateHeight() -> CGFloat {
        return 120
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        containerView.clipsToBounds = true

        overlayView.layer.cornerRadius = 12
        overlayView.layer.masksToBounds = true
 
        backgroundImageView.layer.cornerRadius = 12
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.clipsToBounds = true

        shadowView.clipsToBounds = false
        shadowView.layer.cornerRadius = 12
        shadowView.backgroundColor = .white
        shadowView.alpha = 1
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.24
        shadowView.layer.shadowRadius = 16
    }

    @objc fileprivate func userWantsToPlay() {
        guard self.media != nil else { return }
        delegate?.userWantsToSeeMedia(type: .music, media: media!)
    }
}

extension TinyMusicCollectionViewCell: MediaConfigurable {
    func configure(with delegate: MediaCollectionViewCellDelegate?, media: Media) {
        self.media = media
        self.delegate = delegate
        backgroundImageView.loadImageWithPlaceholder(imageURL: media.artWorkURL, placeholder: #imageLiteral(resourceName: "default-placeholder"))
        titleLabel.text = media.trackName
        authorLabel.text = media.artistName
        playImageView.respondToSelectorOnTap(target: self, selector: #selector(userWantsToPlay))
    }
}
