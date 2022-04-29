//
//  ViewController.swift
//  TextLayerImageSample
//
//  Created by 岡崎伸也 on 2022/04/21.
//

import UIKit

/*
 memo: TextLayer から画像を生成するときのトラブルシューティング
 
 # テキストが一瞬大きくなった場合
 ・「CALayerのサイズ != TextLayer画像のサイズ」の場合、かつCALayer.resizeAspectFill の場合、画像が巨大表示される
   -> 対処法としては、「サイズを同じにする」または「resizeAspect」にする
    -> サイズが一瞬変わるタイミングがある場合は、「UIImage.size」をチェックして、レイヤーのサイズと違う場合は表示しない対応が必要
 */

class ViewController: UIViewController {
    let textLayer = CATextLayer()
    
    var layerList = [CALayer]()
    let backLayer = CALayer()
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        backLayer.frame = self.view.frame
        self.view.layer.addSublayer(backLayer)
        var index = 0
        var targetX: CGFloat = 0
        var targetY: CGFloat = 0
        while index < 20 {
            for _ in 0..<16 {
                let tmpLayer = createLayer(targetFrame: .init(x: targetX, y: targetY, width: 50, height: 100))
                tmpLayer.contents = makeTextImage().cgImage
                self.backLayer.addSublayer(tmpLayer)
                layerList.append(tmpLayer)
                targetX += 50
            }
            targetX = 0
            targetY += 100
            index += 1
        }
        
        self.view.bringSubviewToFront(button)
        button.backgroundColor = .black
    }
    
    
    func makeTextImage() -> UIImage {
        let str = randomString()
        let attrStr = NSMutableAttributedString(string: str, attributes: [
            .font: UIFont.systemFont(ofSize: 10, weight: .regular),
            .foregroundColor: UIColor.black
        ])
        textLayer.frame = .init(x: 0, y: 0, width: 50, height: 100)
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.string = attrStr
        //textLayer.string = str
        //textLayer.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        // memo: AttributedStringを使っている場合でもフォントサイズを指定しておいた方がよい。
        // -> 指定しないと、末尾の省略が発生しなかった
        textLayer.fontSize = 10
        textLayer.alignmentMode = .left
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.isWrapped = true
        textLayer.truncationMode = .end
        
        UIGraphicsBeginImageContextWithOptions(textLayer.frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        // !!! 以下のコードを書くとコンテキストがクリアされるらしい
        // context.clear(textLayer.frame)
        textLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func createLayer(targetFrame: CGRect) -> CALayer {
        let tmpLayer = CALayer()
        tmpLayer.frame = targetFrame
        //tmpLayer.backgroundColor = UIColor.red.cgColor
        // [resize]以外の場合、アスペクト比が維持される
        tmpLayer.contentsGravity = .left
        // !!! ここも重要
        tmpLayer.contentsScale = UIScreen.main.scale
        tmpLayer.isGeometryFlipped = true
        return tmpLayer
    }
    
    func randomString() -> String {
        let length = Int.random(in: 1...100)
        let str = "abcdefghijklmnopqrstuあいうえおかきくけこさしすせそたちつてとなにぬねの"
        return String((0..<length).map { _ in
            return str.randomElement() ?? Character("")
        })
    }
    
    @IBAction func tapButton(_ sender: Any) {
        hoge()
    }
    
    func hoge() {
        var index = 0
        Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { timer in
            index += 1
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            
            for tmpLayer in self.layerList {
                tmpLayer.contents = self.makeTextImage().cgImage
            }
            
            //self.backLayer.frame.origin.y -= 10
            
            CATransaction.commit()
            if index > 30 {
                timer.invalidate()
            }
        }
    }
}
