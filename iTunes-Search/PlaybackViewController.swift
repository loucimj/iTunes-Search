//
//  PlaybackViewController.swift
//  iTunes-Search
//
//  Created by Javier Loucim on 01/07/2018.
//  Copyright © 2018 Qeeptouch. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlaybackViewController: UIViewController {

    @IBOutlet weak var closeButtonImageView: UIImageView!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    var type:MediaTypeSelection = .music
    var media:Media?
    var player: AVPlayer?
    var isPlaybackPending = true
    
    //MARK: - Lifecycle
    class func initFromStoryboard() -> PlaybackViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PlaybackViewController") as! PlaybackViewController
        
        return viewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isPlaybackPending {
            isPlaybackPending = false
            updateViewsAndStartPlayback()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Functions
    func setupViews() {
        closeButtonImageView.respondToSelectorOnTap(target: self, selector: #selector(userWantsToClose))
    }
    
    func updateViewsAndStartPlayback() {
        guard media != nil, media?.previewURL != "" else { return }
        
        artworkImageView.loadImageWithPlaceholder(imageURL: media!.largeArtworkURL, placeholder: #imageLiteral(resourceName: "default-placeholder"))
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            let url = URL(string: media!.previewURL)!
            let playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            if self.type == .music {
                player?.play()
            } else {
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    //MARK: - Actions
    @objc func userWantsToClose() {
        player?.pause()
        player = nil
        self.dismiss(animated: true, completion: nil)
    }
}
