//
//  UIView+Category.swift
//  SuperPlayer
//
//  Created by 邵帅 on 16/9/27.
//  Copyright © 2016年 Beijing Jaeger Communication Electronic Technology Co., Ltd. Beijing Jaeger Communication Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

extension UIView {
    var frameX: CGFloat {
        get{return self.frame.origin.x}
        set(newFrameX){
            var newFrame = self.frame
            newFrame.origin.x = newFrameX
            self.frame = newFrame
        }
    }
    
    var frameY: CGFloat {
        get{return self.frame.origin.y}
        set(newFrameY){
            var newFrame = self.frame
            newFrame.origin.y = newFrameY
            self.frame = newFrame
        }
    }
    
    var frameWidth: CGFloat {
        get{return self.frame.size.width}
        set(newFrameWidth){
            var newFrame = self.frame
            newFrame.size.width = newFrameWidth
            self.frame = newFrame
        }
    }
    
    var frameHeight: CGFloat {
        get{return self.frame.size.height}
        set(newFrameHeight){
            var newFrame = self.frame
            newFrame.size.height = newFrameHeight
            self.frame = newFrame
        }
    }
    
    var frameOrigin: CGPoint {
        get{return self.frame.origin}
        set(newFrameOrigin){
            var newFrame = self.frame
            newFrame.origin = newFrameOrigin
            self.frame = newFrame
        }
    }
    
    var frameSize: CGSize {
        get{return self.frame.size}
        set(newFrameSize){
            var newFrame = self.frame
            newFrame.size = newFrameSize
            self.frame = newFrame
        }
    }
    
    var boundsX: CGFloat {
        get{return self.bounds.origin.x}
        set(newBoundsX){
            var newBounds = self.bounds
            newBounds.origin.x = newBoundsX
            self.frame = newBounds
        }
    }
    
    var boundsY: CGFloat {
        get{return self.bounds.origin.y}
        set(newBoundsY){
            var newBounds = self.bounds
            newBounds.origin.y = newBoundsY
            self.frame = newBounds
        }
    }
    
    var boundsWidth: CGFloat {
        get{return self.bounds.size.width}
        set(newBoundsWidth){
            var newBounds = self.frame
            newBounds.size.width = newBoundsWidth
            self.frame = newBounds
        }
    }
    
    var boundsHeight: CGFloat {
        get{return self.bounds.size.height}
        set(newBoundsHeight){
            var newBounds = self.frame
            newBounds.size.width = newBoundsHeight
            self.frame = newBounds
        }
    }
    
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func toImageView() -> UIImageView {
        return UIImageView.init(image: toImage())
    }
}
