//
//  SampleLayer.swift
//  CreateLayerImageSample
//
//  Created by 岡崎伸也 on 2022/04/28.
//

import Foundation
import UIKit

class SampleLayer: CALayer {
    let sampleSublayer = CALayer()
    //let textLayer = CATextLayer()

    /*
    override func draw(in ctx: CGContext) {
        print("hoge!?!?")
    }
    
    override func display() {
        print("hoge!!!")
    }
    
    override func render(in ctx: CGContext) {
        print("hoge????")
    }
     */
    
    func setup(rootLayer: CALayer, targetFrame: CGRect) {
        self.drawsAsynchronously = true
        self.backgroundColor = UIColor.lightGray.cgColor
        self.frame = targetFrame
        
        sampleSublayer.drawsAsynchronously = true
        sampleSublayer.frame = .init(x: 0, y: 10, width: 100, height: 30)
        sampleSublayer.backgroundColor = UIColor.red.cgColor
        self.addSublayer(sampleSublayer)
        
        rootLayer.addSublayer(self)
        
        for i in 0..<100000 {
            let tmpLayer = CALayer()
            let tmpTextLayer = CATextLayer()
            tmpLayer.drawsAsynchronously = true
            tmpTextLayer.drawsAsynchronously = true
            
            tmpLayer.backgroundColor = UIColor.black.cgColor
            tmpLayer.frame = .init(x: 0, y: 10, width: self.frame.width, height: 1)
            tmpTextLayer.frame = .init(x: 0, y: 20, width: 50, height: 50)
            tmpTextLayer.string = "aaa"
            tmpTextLayer.isHidden = true
            self.addSublayer(tmpLayer)
            //self.addSublayer(tmpTextLayer)
        }
        
        
//        textLayer.frame = .init(x: 0, y: 20, width: 50, height: 50)
//        textLayer.string = "test"
//        textLayer.fontSize = 10
//
//        self.addSublayer(textLayer)
    }
}
