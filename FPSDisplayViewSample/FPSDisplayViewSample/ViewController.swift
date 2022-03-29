//
//  ViewController.swift
//  FPSDisplayViewSample
//
//  Created by 岡崎伸也 on 2022/03/29.
//

import UIKit

class ViewController: UIViewController {

    var fpsView: FPSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tmpFpsView = FPSView(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: 30))
        self.view.addSubview(tmpFpsView)
        self.fpsView = tmpFpsView
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            Thread.sleep(forTimeInterval: 1)
            print("FPS: end")
        }
    }

}

