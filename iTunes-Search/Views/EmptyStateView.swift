//
//  EmptyStateView.swift
//  qontact-qa
//
//  Created by Javier Loucim on 9/16/17.
//  Copyright © 2017 Qeeptouch. All rights reserved.
//

import UIKit
import Lottie

class EmptyStateView: UIView, NibLoadable {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var animationContainerView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var buttonAnimation:LOTAnimationView = LOTAnimationView()
    
    func configure(with text:String) {
        textLabel.textColor = skinSecondaryTextColor()
        textLabel.text = text
        animationContainerView.isHidden = true
    }
    func configureAsLoader() {
        animationContainerView.isHidden = false

        // Do any additional setup after loading the view.
        buttonAnimation = LOTAnimationView(name: "SimpleLoader")
        buttonAnimation.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100))
        buttonAnimation.contentMode = .scaleAspectFill
        buttonAnimation.center = CGPoint(x: animationContainerView.frame.size.width/2, y: animationContainerView.frame.size.height/2)
        
        buttonAnimation.loopAnimation = true
        buttonAnimation.animationSpeed = 0.6
        animationContainerView.addSubview(buttonAnimation)
        buttonAnimation.play(completion: { completed in
            self.buttonAnimation.animationProgress = 0
        })
        

    }

}
