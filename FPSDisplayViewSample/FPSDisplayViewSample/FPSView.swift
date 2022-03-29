//
//  FPSView.swift
//  FPSDisplayViewSample
//
//  Created by 岡崎伸也 on 2022/03/29.
//

import Foundation
import UIKit

/// FPSを表示するView
/// memo: CADisplayLink を使う
/// https://developer.apple.com/documentation/quartzcore/cadisplaylink
/// memo: 参考
/// https://stackoverflow.com/questions/57937529/cadisplaylink-is-unable-to-achieve-a-constant-frame-rate-in-simulator
/// https://anthrgrnwrld.hatenablog.com/entry/2017/11/29/224129
/// https://jpdebug.com/p/938774
class FPSView: UIView {
    // private var previousTimeInSeconds: Double = 0
    
    private lazy var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(
            target: self,
            selector: #selector(displayLoop)
        )
        return displayLink;
    }()
    
    var lastTime: TimeInterval = 0
    var count: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .clear
        
        startLoop()
    }
    
    private func startLoop() {
        // previousTimeInSeconds = Date().timeIntervalSince1970
        displayLink.add(to: .current, forMode: .common)
    }
    
    @objc private func displayLoop() {
        // 以下のサイトを参考に作成
        // https://jpdebug.com/p/938774
        
        if lastTime == 0 {
            // 最後のフレームが表示された時間を保存
            lastTime = displayLink.timestamp
            return
        }
        
        count += 1
        // 画面更新間の間隔を計算
        let timeDelta = displayLink.timestamp - lastTime
        // 更新頻度の閾値
        // if timeDelta < 0.25 { return }
        
        lastTime = displayLink.timestamp
        let fps: Double = Double(count) / timeDelta
        count = 0
        print("hoge, fps: \(fps)")
        // text = String(format: "%.0f", fps)
        // textColor = fps > 50 ? UIColor.green : UIColor.red
        
        // lastTime = displayLink.timestamp
    }
}
