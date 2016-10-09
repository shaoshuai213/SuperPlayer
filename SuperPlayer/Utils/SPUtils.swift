//
//  SPUtils.swift
//  SuperPlayer
//
//  Created by 邵帅 on 16/9/27.
//  Copyright © 2016年 Beijing Jaeger Communication Electronic Technology Co., Ltd. Beijing Jaeger Communication Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

class SPUtils: NSObject {

    public class func currentDateString() -> String
    {
        return dateString(date: Date.init())
    }
    
    public class func dateString(date: Date) -> String
    {
        let df = DateFormatter.init()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return df.string(from: date)
    }
}
