//
//  ViewController.swift
//  CreateLayerImageSample
//
//  Created by 岡崎伸也 on 2022/04/28.
//

import UIKit

class ViewController: UIViewController {

    let sampleLayer = SampleLayer()
    let targetImageLayer = CALayer()
    
    var dic: [String: UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let targetFrame = CGRect(x: 10, y: 10, width: 300, height: 80)
        sampleLayer.setup(rootLayer: self.view.layer, targetFrame: targetFrame)
        
        targetImageLayer.frame = .init(x: 10, y: 400, width: 300, height:80)
        targetImageLayer.backgroundColor = UIColor.yellow.cgColor
        self.view.layer.addSublayer(targetImageLayer)
        
        targetImageLayer.contentsScale = UIScreen.main.scale
        targetImageLayer.contentsGravity = .topLeft
        targetImageLayer.isGeometryFlipped = true
    }
    
    
    @IBAction func tapButton(_ sender: Any) {
        Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) {_ in
            // TODO: 
//            self.sampleLayer.frame.origin.y += 0.1
//            self.targetImageLayer.frame.origin.y += 0.1
        }
        
        
        /*
        let date = Date()
        for i in 0..<1{
            UIGraphicsBeginImageContextWithOptions(self.sampleLayer.frame.size, true, 0.0)
            let context = UIGraphicsGetCurrentContext()!
            self.sampleLayer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.targetImageLayer.contents = image.cgImage
        }
        print("image render", Date().timeIntervalSince(date))
        */
    }
}

