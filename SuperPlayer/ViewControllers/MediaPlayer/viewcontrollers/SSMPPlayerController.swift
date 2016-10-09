//
//  SSMPPlayerController.swift
//  SuperPlayer
//
//  Created by 邵帅 on 16/9/28.
//  Copyright © 2016年 Beijing Jaeger Communication Electronic Technology Co., Ltd. Beijing Jaeger Communication Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import AVFoundation

//MARK: - Player Delegate -

protocol SSMPPlayerControllerDelegate {
    func setCurrentTime(time: TimeInterval, duration: TimeInterval)
    func playbackComplete()
    func setTitle(title: String)
    func setSubtitles(subtitles: [String]?)
}

class SSMPPlayerController: NSObject, SSMPOverlayViewDelegate {
    
    public var view: UIView!{
        get{
            return self.playerView
        }
    }
    public var delegate: SSMPPlayerControllerDelegate?
    
    let STATUS_KEY_PATH     = "status"
    let REFRESH_INTERVAL    = Float(0.5)
    
    let PlayerItemStatusContext = UnsafeMutableRawPointer(mutating: "PlayerItemStatusContext")
    
    var asset: AVAsset!
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    var playerView: SSMPPlayerView!
    var timeObserver: Any!
    var itemEndObserver: Any!
    var lastPlaybackRate: Float!
    
    init(assetURL: URL) {
        super.init()
        
        asset = AVAsset.init(url: assetURL)
        
        let keys = ["tracks", "duration", "commonMetadata", "availableMediaCharacteristicsWithMediaSelectionOptions"]
        playerItem = AVPlayerItem.init(asset: asset, automaticallyLoadedAssetKeys: keys)
        playerItem.addObserver(self, forKeyPath: STATUS_KEY_PATH, options: [.new, .old], context: PlayerItemStatusContext)
        player = AVPlayer.init(playerItem: playerItem)
        playerView = SSMPPlayerView.init(player: player, delegate: self)
        delegate = playerView.transportDelegate()
    }
    
    //MARK: - observe func -
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == PlayerItemStatusContext {
            DispatchQueue.main.async {
                self.playerItem.removeObserver(self, forKeyPath: self.STATUS_KEY_PATH)
                if self.playerItem.status == AVPlayerItemStatus.readyToPlay {
                    self.addPlayerItemTimeObserver()
                    self.addItemEndObserverForPlayerItem()
                    let duration: TimeInterval = CMTimeGetSeconds(self.playerItem.duration)
                    self.delegate?.setCurrentTime(time: CMTimeGetSeconds(kCMTimeZero), duration: duration)
                    self.delegate?.setTitle(title: self.asset.title)
                    self.player.play()
                    self.loadMediaOptions()
                }
                else{
                    
                }
            }
        }
    }
    
    private func loadMediaOptions()
    {
        let mc: String = AVMediaCharacteristicLegible
        let group: AVMediaSelectionGroup? = self.asset.mediaSelectionGroup(forMediaCharacteristic: mc)
        if group != nil {
            var subtitles = [String]()
            for option in (group?.options)! {
                subtitles.append(option.displayName)
            }
            self.delegate?.setSubtitles(subtitles: subtitles)
        }
        else{
            self.delegate?.setSubtitles(subtitles: nil)
        }
    }
    
    //MARK: - Add observer -
    
    private func addPlayerItemTimeObserver()
    {
        let interval = CMTimeMakeWithSeconds(Float64(REFRESH_INTERVAL), Int32(NSEC_PER_SEC))
        let calllBack: (CMTime) -> Void = {(time) in
            let currentTime = CMTimeGetSeconds(time)
            let duration = CMTimeGetSeconds(self.playerItem.duration)
            self.delegate?.setCurrentTime(time: currentTime, duration: duration)
        }
        
        let queue = DispatchQueue.main
        self.timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: queue, using: calllBack)
    }
    
    private func addItemEndObserverForPlayerItem()
    {
        let queue = OperationQueue.main
        let callBack: (Notification) -> Void = {(notification) in
            self.player.seek(to: kCMTimeZero, completionHandler: { (Bool) in
                self.delegate?.playbackComplete()
            })
        }
        self.itemEndObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem, queue: queue, using: callBack)
    }
    
    //MARK: - SSMPOverlayViewDelegate -
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func stop() {
        player.setRate(Float(0), time: CMTimeMakeWithSeconds(0, Int32(NSEC_PER_SEC)), atHostTime: CMTimeMakeWithSeconds(0, Int32(NSEC_PER_SEC)))
        self.delegate?.playbackComplete()
    }
    
    func scrubbingDidStart()
    {
        lastPlaybackRate = player.rate
        player.pause()
        player.removeTimeObserver(timeObserver)
    }
    
    func scrubbedToTime(time: TimeInterval)
    {
        playerItem.cancelPendingSeeks()
        player.seek(to: CMTimeMakeWithSeconds(Float64(time), Int32(NSEC_PER_SEC)))
    }
    
    func scrubbingDidEnd()
    {
        self.addPlayerItemTimeObserver()
        if self.lastPlaybackRate > 0 {
            self.player.play()
        }
    }
    
    func jumpToTime(time: TimeInterval)
    {
        player.seek(to: CMTimeMakeWithSeconds(Float64(time), Int32(NSEC_PER_SEC)))
    }
    
    deinit {
        if self.itemEndObserver != nil {
            NotificationCenter.default.removeObserver(self.itemEndObserver, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
            self.itemEndObserver = nil
        }
    }
}
