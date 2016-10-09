//
//  SSMPOverlayView.swift
//  SuperPlayer
//
//  Created by 邵帅 on 16/9/27.
//  Copyright © 2016年 Beijing Jaeger Communication Electronic Technology Co., Ltd. Beijing Jaeger Communication Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

protocol SSMPOverlayViewDelegate {
    
    func play()
    func pause()
    func stop()
    
    func scrubbingDidStart()
    func scrubbedToTime(time: TimeInterval)
    func scrubbingDidEnd()
    
    func jumpToTime(time: TimeInterval)
}

class SSMPOverlayView: UIView, UIGestureRecognizerDelegate, SSMPPlayerControllerDelegate {
    
    var delegate: SSMPOverlayViewDelegate?

    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var togglePlaybackButton: UIButton!
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var remainTimeLabel: UILabel!
    @IBOutlet var scrubberSlider: UISlider!
    @IBOutlet var infoView: UIView!
    @IBOutlet var scrubbingTimeLabel: UILabel!
    
    var controlsHidden: Bool = true
    var scrubbing: Bool = false
    var infoViewOffset: Float = Float(0)
    var lastPlaybackRate: Float = Float(0)
    var timer: Timer!
    var excludedViews: Array<UIView>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrubberSlider.setThumbImage(UIImage.init(named: "knob"), for: .normal)
        scrubberSlider.setThumbImage(UIImage.init(named: "knob_highlighted"), for: .highlighted)
        scrubberSlider.addTarget(self, action: #selector(showPopupUI), for: .valueChanged)
        scrubberSlider.addTarget(self, action: #selector(hidePopupUI), for: .touchUpInside)
        scrubberSlider.addTarget(self, action: #selector(unhidePopupUI), for: .touchDown)
        
        infoView.isHidden = true
        calculateInfoViewOffset()
        
        excludedViews = [self.navigationBar, self.toolBar]
        self.resetTimer()
    }
    
    private func calculateInfoViewOffset()
    {
        infoView.sizeToFit()
        infoViewOffset = ceilf(Float(infoView.frameWidth / CGFloat(2)))
    }
    
    private func resetTimer()
    {
        if timer != nil {
            timer.invalidate()
        }
        if !scrubbing {
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func updateTimer()
    {
        if timer.isValid && !controlsHidden {
            toggleControls()
        }
    }
    
    @objc private func showPopupUI()
    {
        infoView.isHidden = false
        
        let trackRect = scrubberSlider.convert(scrubberSlider.bounds, to: nil)
        let thumbRect = scrubberSlider.thumbRect(forBounds: scrubberSlider.bounds, trackRect: trackRect, value: Float(self.boundsHeight - CGFloat(80)))
        infoView.frameOrigin = CGPoint.init(x: thumbRect.origin.x - CGFloat(infoViewOffset+16), y: self.boundsHeight - 78)
        self.currentTimeLabel.text = "--:--:--"
        self.remainTimeLabel.text = "--:--:--"
        
        self.setScrubbingTime(time: TimeInterval(scrubberSlider.value))
        delegate?.scrubbedToTime(time: TimeInterval(scrubberSlider.value))
    }
    
    @objc private func hidePopupUI()
    {
        UIView.animate(withDuration: 0.3, animations: { 
            self.infoView.alpha = 0
            }) { (Bool) in
                self.infoView.alpha = 1
                self.infoView.isHidden = true
        }
        scrubbing = false
        delegate?.scrubbingDidEnd()
    }
    
    @objc private func unhidePopupUI()
    {
        self.infoView.isHidden = false
        self.infoView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.infoView.alpha = 1
        }
        scrubbing = true
        self.resetTimer()
        delegate?.scrubbingDidStart()
    }
    
    @IBAction private func toggleControls()
    {
        UIView.animate(withDuration: 0.35) { 
            if !self.controlsHidden {
                self.navigationBar.frameY -= self.navigationBar.frameHeight
                self.toolBar.frameY += self.toolBar.frameHeight
            }
            else{
                self.navigationBar.frameY += self.navigationBar.frameHeight
                self.toolBar.frameY -= self.toolBar.frameHeight
            }
            self.controlsHidden = !self.controlsHidden
        }
    }
    
    @IBAction private func togglePlayback(button: UIButton)
    {
        button.isSelected = !button.isSelected
        if button.isSelected {
            delegate?.play()
        }
        else{
            delegate?.pause()
        }
    }
    
    @IBAction private func closeWindow()
    {
        timer.invalidate()
        timer = nil
        delegate?.stop()
        self.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: SSMPPlayerControllerDelegate
    
    func setCurrentTime(time: TimeInterval, duration: TimeInterval)
    {
        let currentSeconds = NSInteger(time)
        let remainingTime = NSInteger(duration - time)
        self.currentTimeLabel.text = self.formatSeconds(seconds: currentSeconds)
        self.remainTimeLabel.text = self.formatSeconds(seconds: remainingTime)
        self.scrubberSlider.maximumValue = Float(duration)
        self.scrubberSlider.minimumValue = 0
        self.scrubberSlider.value = Float(time)
    }
    
    private func setScrubbingTime(time: TimeInterval)
    {
        self.scrubbingTimeLabel.text = self.formatSeconds(seconds: NSInteger(time))
    }
    
    private func setCurrentTime(time: TimeInterval)
    {
        delegate?.jumpToTime(time: time)
    }
    
    func setTitle(title: String)
    {
        self.navigationBar.topItem?.title = title
    }
    
    func playbackComplete()
    {
        self.closeWindow()
    }
    
    func setSubtitles(subtitles: [String]?)
    {
        
    }
    
    private func formatSeconds(seconds: NSInteger) -> String
    {
        var timeString = "00:00:00"
        if seconds > 0 {
            let second = seconds % 60
            var munite = seconds / 60
            if munite >= 60 {
                let hour = munite / 60
                munite %= 60
                timeString = String.init(format: "%.2d:%.2d:%.2d", hour, munite, second)
            }
            else{
                timeString = String.init(format: "00:%.2d:%.2d", munite, second)
            }
        }
        
        return timeString
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        self.resetTimer()
        return !excludedViews.contains(touch.view!)  && !excludedViews.contains((touch.view?.superview)!)
    }
}
