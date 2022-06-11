//
//  ViewController.swift
//  CoreTextSample
//
//  Created by 岡崎伸也 on 2022/05/29.
//

import UIKit

class ViewController: UIViewController {

    let imageView = UIImageView()
    
    let coreTextModel = CoreTextModel()
    let textKitModel = TextKitModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .blue
        
        self.view.addSubview(imageView)
        
        sample()
        
        makeTextImage()
    }
    
    /// CoreTextを使ってテキスト画像生成
    func makeTextImage() {
        let date = Date()
        
        /* 表示する文字列を設定 */
        //var str = "サンプルです。\nabcdefgaaあああaaCCCaaaaaaあああ"
        var str = "サンプルです。\n2行目\n3行目\n4行目ああああああああBB"
        //var str = "aaaaaaaaaaaabbbbbbbbbbbcccccccccddddddddd"
        
//        for i in 0..<5 {
//            str += "\(i): samplesamplesamplesamplesampleああああ\n"
//        }
        // 行間などはStyleで指定
        let descriptionStyle = NSMutableParagraphStyle()
        descriptionStyle.lineSpacing = 3
        descriptionStyle.alignment = .left
        // memo: 末尾省略は行ごとに適用されるので使えない
        // descriptionStyle.lineBreakMode = .byTruncatingTail
        let attrStr = NSMutableAttributedString(string: str, attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .bold),
            .foregroundColor: UIColor(red: 1, green: 0, blue: 0, alpha: 1),
            .paragraphStyle: descriptionStyle
        ])

        // テキストを表示するサイズを指定
        let targetWidth: CGFloat = 150
        //let textSize = coreTextModel.sizeFromCTSuggestsFrame(attrStr: attrStr, width: targetWidth)
        let textSize = CGSize(width: targetWidth, height: 40)
        //let textImage = coreTextModel.drawTextWithCTFrame(attrStr: attrStr, rect: .init(origin: .zero, size: textSize))
        let textImage = coreTextModel.drawTextWithCTLines(attrStr: attrStr, rect: .init(origin: .zero, size: textSize))
        
        // デバッグ用
        coreTextModel.sample(attrStr: attrStr, rect: .init(origin: .zero, size: textSize))
        
        // デバッグ用：テキスト画像を表示する
        imageView.frame = .init(origin: .zero, size: textSize)
        imageView.image = textImage
        
        print("makeTextImage", textSize, Date().timeIntervalSince(date))
    }
    
    @IBAction func tapButton(_ sender: Any) {
        makeTextImage()
    }
}


extension ViewController {
    func sample() {
        let str = "サンプルです。aaaBBBCCC"
        let targetWidth: CGFloat = 100
        
        let attrStr = NSMutableAttributedString(string: str, attributes: [
            .font: UIFont.systemFont(ofSize: 10, weight: .bold),
            .foregroundColor: UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        ])
        
        var date = Date()
        let sizeFromCoreText = coreTextModel.sizeFromCTSuggestsFrame(attrStr: attrStr, width: targetWidth)
        print("sizeFromCoreText", sizeFromCoreText, Date().timeIntervalSince(date))

        date = Date()
        let sizeFromTextKit = textKitModel.sizeFromTKTextContainer(attrStr: attrStr, width: targetWidth)
        print("sizeFromTextKit", sizeFromTextKit, Date().timeIntervalSince(date))
    }
}
