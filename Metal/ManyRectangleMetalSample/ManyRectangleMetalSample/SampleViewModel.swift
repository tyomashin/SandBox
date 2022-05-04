//
//  SampleViewModel.swift
//  ManyRectangleMetalSample
//
//  Created by 岡崎伸也 on 2022/05/03.
//

import Foundation
import UIKit

class SampleViewModel {
    private var sampleDataList = [SampleData]()
    
    private var view: ViewController?
    private var metalFrame: CGRect?
    
    func initSampleData(view: ViewController, metalLayerFrame: CGRect) {
        self.view = view
        self.metalFrame = metalLayerFrame
        
        let width: CGFloat = 60
        let height: CGFloat = 2
        
        let spaceX: CGFloat = 5
        let spaceY: CGFloat = 1
        
        var targetY: CGFloat = 20
        
        for y in 0..<30 * 12 {
            var leftX: CGFloat = 0
            for x in 0..<32 {
                var data = SampleData()
                data.frame = .init(x: leftX, y: targetY, width: width, height: height)
                let ran = Int.random(in: 0..<AppColor.allCases.count)
                data.color = AppColor.allCases[ran]
                data.cornerRadius = 1
                sampleDataList.append(data)
                
                leftX += width + spaceX
            }
            targetY += height + spaceY
        }
    }
    
    /// 現在の描画情報を返す
    func getCurrentVertexData() -> [ShaderVertex] {
        guard let targetFrame = metalFrame else { return [] }
        var results = [ShaderVertex]()
        
        let baseX: Float = Float(targetFrame.width / 2)
        let baseY: Float = Float(targetFrame.height / 2)
                
        // TODO: ポインタでアクセス
        for data in sampleDataList {
            let leftX = Float(data.frame.origin.x) - baseX
            let rightX = Float(data.frame.origin.x + data.frame.width) - baseX
            let topY = baseY - Float(data.frame.origin.y)
            let bottomY = baseY - Float(data.frame.origin.y + data.frame.height)
            
            let centerX = (rightX + leftX) / 2
            let centerY = (topY + bottomY) / 2
            let rectSizeX: Float = Float(data.frame.width / 2)
            let rectSizeY: Float = Float(data.frame.height / 2)
            
            results.append(.init(
                position: vector_float2(leftX, topY), color: data.color.color, cornerRadius: Float(data.cornerRadius),
                center: vector_float2(centerX, centerY), rectSize: vector_float2(rectSizeX, rectSizeY)
            ))
            results.append(.init(
                position: vector_float2(leftX, bottomY), color: data.color.color, cornerRadius: Float(data.cornerRadius),
                center: vector_float2(centerX, centerY), rectSize: vector_float2(rectSizeX, rectSizeY)
            ))
            results.append(.init(
                position: vector_float2(rightX, bottomY), color: data.color.color, cornerRadius: Float(data.cornerRadius),
                center: vector_float2(centerX, centerY), rectSize: vector_float2(rectSizeX, rectSizeY)
            ))
            
            results.append(.init(
                position: vector_float2(leftX, topY), color: data.color.color, cornerRadius: Float(data.cornerRadius),
                center: vector_float2(centerX, centerY), rectSize: vector_float2(rectSizeX, rectSizeY)
            ))
            results.append(.init(
                position: vector_float2(rightX, topY), color: data.color.color, cornerRadius: Float(data.cornerRadius),
                center: vector_float2(centerX, centerY), rectSize: vector_float2(rectSizeX, rectSizeY)
            ))
            results.append(.init(
                position: vector_float2(rightX, bottomY), color: data.color.color, cornerRadius: Float(data.cornerRadius),
                center: vector_float2(centerX, centerY), rectSize: vector_float2(rectSizeX, rectSizeY)
            ))
        }
        return results
    }
    
    /*
    func randomTimer() {
        Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in
            for _ in 0..<6 {
                self.sampleDataList.removeFirst()
            }
            
            
            DispatchQueue.global().async {
                let newVertexData = self.getCurrentVertexData()
                DispatchQueue.main.async {
                    self.view?.vertexArray = newVertexData
                }
            }
        }
    }
    */
}
