//
//  SSMPCategorys.swift
//  SuperPlayer
//
//  Created by 邵帅 on 16/9/29.
//  Copyright © 2016年 Beijing Jaeger Communication Electronic Technology Co., Ltd. Beijing Jaeger Communication Electronic Technology Co., Ltd. All rights reserved.
//

import Foundation
import AVFoundation

extension AVAsset {
    var title: String{
        get{
            let status: AVKeyValueStatus = self.statusOfValue(forKey: "commonMetadata", error: nil)
            if status == AVKeyValueStatus.loaded {
                let items: [AVMetadataItem] = AVMetadataItem.metadataItems(from: self.commonMetadata, withKey: AVMetadataCommonKeyTitle, keySpace: AVMetadataKeySpaceCommon)
                if items.count > 0 {
                    let item: AVMetadataItem = items.first!
                    return item.value as! String
                }
            }
            return "Vedio Player"
        }
    }
}
