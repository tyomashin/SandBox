//
//  SubHeaderButton.swift
//  ContainerViewControllerSample
//
//  Created by 岡崎伸也 on 2019/09/26.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit

class SubHeaderButton: UIView {
    
    @IBOutlet var baseView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonLabel: UILabel!
    
    
    var nowState : Bool = false
    
    // storyboard から初期化した時に呼ばれる
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init?(coder: NSCoder)")
        initCustom()
    }
    func initCustom(){
        // Nib を読み込む
        Bundle.main.loadNibNamed("SubHeaderButton", owner: self, options: nil)
        baseView.frame = self.bounds
        addSubview(baseView)
        // Gesture を設定
        addGestureRecognizer()
    }
    // viewController から呼び出す
    func vcInitCustom(str : String){
        //self.buttonLabel.text = str
        let image = UIImage(named: "CancelIcon")?.withRenderingMode(.alwaysOriginal)
        imageView.image = image
        imageView.backgroundColor = .black
        imageView.tintColor = UIColor.black
    }

}

// tap, longTouch イベントを追加
// タップとロングタッチ療法を検知するには、UIGestureRecognizerDelegate を実装する必要がある

extension SubHeaderButton : UIGestureRecognizerDelegate{
    func addGestureRecognizer(){
        // タップ中の動作
        let touchDown = UILongPressGestureRecognizer(target:self, action: #selector(touchDownGesture(sender:)))
        // 長押し検知までの時間を0にする
        touchDown.minimumPressDuration = 0
        touchDown.cancelsTouchesInView = false
        touchDown.delegate = self
        self.addGestureRecognizer(touchDown)
        // タップ後の動作を設定
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        //tapGesture.numberOfTouchesRequired = 1
        //tapGesture.numberOfTapsRequired = 1
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    // 同一View上で指が話された時、何らかの処理を行う
    @objc func tapGesture(sender: UITapGestureRecognizer){
        //self.transform.scaledBy(x: 1.5, y: 1.5)
        if sender.state == .ended{
            print("tapGesture ended")
            if nowState == true{
                /*
                UIView.animate(withDuration: 0.5, animations: {
                    print("animate")
                    self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    self.imageView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                    self.buttonLabel.alpha = 1
                }, completion: {_ in
                    self.nowState = false
                })
                */
                
                self.nowState = false
            }else{
                /*
                UIView.animate(withDuration: 0.5, animations: {
                    print("animate")
                    self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    self.imageView.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                    self.buttonLabel.alpha = 0
                }, completion: {_ in
                    self.nowState = true
                })
                */
                self.nowState = true
            }
        }
    }
    // 見栄えの変更
    @objc func touchDownGesture(sender: UILongPressGestureRecognizer){
        if sender.state == .began{
            print("touchDown began")
            self.alpha = 0.8
        }
        else if sender.state == .ended{
            print("touchDown ended")
            self.alpha = 1
        }
    }
    // タッチイベントを受け取るかどうか（なくても動作する）
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    // プレスイベントを受け取るかどうか（なくても動作する）
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // ロングタッチが同時ジェスチャーの時
        if otherGestureRecognizer is UILongPressGestureRecognizer{
            return true
        }
        // タップが同時ジェスチャーの時
        if otherGestureRecognizer is UITapGestureRecognizer{
            return true
        }
        // それ以外の同時実行ジェスチャーは拒否
        return false
    }
}


