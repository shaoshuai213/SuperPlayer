//
//  SSMPPlayerView.swift
//  SuperPlayer
//
//  Created by 邵帅 on 16/9/27.
//  Copyright © 2016年 Beijing Jaeger Communication Electronic Technology Co., Ltd. Beijing Jaeger Communication Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import AVFoundation

class SSMPPlayerView: UIView {
    
    var playerLayer = AVPlayerLayer()
    var player: AVPlayer{
        get{
            return playerLayer.player!
        }
        set(newPlayer){
            playerLayer.player = newPlayer
        }
    }

    var overlayView: SSMPOverlayView!
    
    public init(player: AVPlayer, delegate: SSMPOverlayViewDelegate?) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        self.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        self.layer.insertSublayer(playerLayer, at: 0)
        self.player = player
        overlayView = Bundle.main.loadNibNamed("SSMPOverlayView", owner: self, options: nil)?.first as! SSMPOverlayView!
        overlayView.delegate = delegate
        self.addSubview(overlayView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        overlayView.frame = self.frame
        playerLayer.frame = self.bounds
    }
    
    func transportDelegate() -> SSMPPlayerControllerDelegate {
        return overlayView
    }
}
