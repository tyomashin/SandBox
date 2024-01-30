//
//  TextureCreator.swift
//  MetalBrendhingSample
//
//  Created by 岡崎伸也 on 2022/06/29.
//

import Foundation
import UIKit
import MetalKit

class TextureCreator {
    

    /// TextureLoader を使ってAssetの画像からMTLTexture生成
    func makeTextureFromAssets(device: MTLDevice?) -> MTLTexture? {
        guard let device = device else { return nil }
        let loader = MTKTextureLoader(device: device)
        do {
            let texture = try loader.newTexture(name: "arrowImage", scaleFactor: 1, bundle: nil)
            return texture
        } catch {
            print(error)
        }
        return nil
    }
    
    /// TextureLoader を使ってCGImageからMTLTextureを生成
    func makeTextureFromCGImage(device: MTLDevice?, cgImage: CGImage) -> MTLTexture? {
        guard let device = device else { return nil }
        let loader = MTKTextureLoader(device: device)
        do {
            let texture = try loader.newTexture(cgImage: cgImage)
            return texture
        } catch {
            print(error)
        }
        return nil
    }
    
    /// Note: 非推奨
    /// 書籍に記載されていた、手動でMTLTextureを生成する方法.
    /// -> 現在は MTKTextureLoader が用意されているので、手動で作る必要は基本的にない
    func makeTexture(device: MTLDevice?) -> MTLTexture? {
        // アセットカタログから画像を読み込む
        //guard let image = UIImage(named: "textureImage") else { return nil }
        guard let image = UIImage(named: "arrowImage") else { return nil }
        // let image = textImageCreater.makeTextImage()
        
        let date = Date()
        print("hoge!", image.size)
        
        // CGImageを取得する
        guard let cgImage = image.cgImage else {
            return nil
        }
        
        // データプロバイダ経由でピクセルデータを取得する
        guard let pixelData = cgImage.dataProvider?.data else {
            return nil
        }

        guard let srcBits = CFDataGetBytePtr(pixelData) else {
            return nil
        }
        
        // テクスチャを作成する
        let desc = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .rgba8Unorm,
            width: cgImage.width,
            height: cgImage.height,
            mipmapped: false)
        
        let texture = device?.makeTexture(descriptor: desc)
        
        
        // RGBA形式のピクセルデータを作る
        let bytesPerRow = cgImage.width * 4
        var dstBits = Data(count: bytesPerRow * cgImage.height)
        let alphaInfo = cgImage.alphaInfo
        print("hoge", alphaInfo)
        
        // Note: 以下は書籍に記載されていたRGBA配置
        /*
        let rPos = (alphaInfo == .first || alphaInfo == .noneSkipFirst) ? 1 : 0
        let gPos = rPos + 1
        let bPos = gPos + 1
        let aPos = (alphaInfo == .last || alphaInfo == .noneSkipLast) ? 3 : 0
        */
        
        print("hoge!!!", alphaInfo)
         
        // Note: テキスト表示時は以下のRBGA配置になっている
        let rPos = 2
        let gPos = 1
        let bPos = 0
        let aPos = 3
         
        for y in 0 ..< cgImage.height {
            for x in 0 ..< cgImage.width {
                let srcOff = y * cgImage.bytesPerRow +
                    x * cgImage.bitsPerPixel / 8
                let dstOff = y * bytesPerRow + x * 4
                
                dstBits[dstOff] = srcBits[srcOff + rPos]
                dstBits[dstOff + 1] = srcBits[srcOff + gPos]
                dstBits[dstOff + 2] = srcBits[srcOff + bPos]
                
                if alphaInfo != .none {
                    dstBits[dstOff + 3] = srcBits[srcOff + aPos]
                }
            }
        }
        
        // テクスチャのピクセルデータを置き換える
        dstBits.withUnsafeBytes { (bufPtr) in
            if let baseAddress = bufPtr.baseAddress {
                let region = MTLRegion(origin: MTLOrigin(x: 0, y: 0, z: 0),
                                       size: MTLSize(width: cgImage.width,
                                                     height: cgImage.height,
                                                     depth: 1))
                texture?.replace(region: region,
                                 mipmapLevel: 0,
                                 withBytes: baseAddress,
                                 bytesPerRow: bytesPerRow)
            }
        }

        print("make texture finish", Date().timeIntervalSince(date))
        
        return texture
    }

}
