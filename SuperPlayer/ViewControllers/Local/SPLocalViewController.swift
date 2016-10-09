//
//  SPLocalViewController.swift
//  SuperPlayer
//
//  Created by 邵帅 on 16/9/26.
//  Copyright © 2016年 Beijing Jaeger Communication Electronic Technology Co., Ltd. Beijing Jaeger Communication Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

class SPLocalViewController: SPViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "local_playmedia" {
            let vc: SPMediaPlayerViewController = segue.destination as! SPMediaPlayerViewController
            vc.assertURL = Bundle.main.url(forResource: "hubblecast", withExtension: "m4v")
        }
    }
}
