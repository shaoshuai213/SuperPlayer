//
//  SPRemotePlayerViewController.swift
//  SuperPlayer
//
//  Created by 邵帅 on 16/9/29.
//  Copyright © 2016年 Beijing Jaeger Communication Electronic Technology Co., Ltd. Beijing Jaeger Communication Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SPRemotePlayerViewController: SPViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let controller: AVPlayerViewController = AVPlayerViewController.init()
        controller.player = AVPlayer.init(url: Bundle.main.url(forResource: "hubblecast", withExtension: "m4v")!)
        controller.view.frame = self.view.frame
        self.addChildViewController(controller)
        self.view.addSubview(controller.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
