//
//  HeaderButton.swift
//  ContainerViewControllerSample
//
//  Created by 岡崎伸也 on 2019/09/23.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit

/// 選択時と非選択時の状態で形状が変わるボタン
class HeaderButton: UIView {

    @IBOutlet var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    var nowState : Bool = false
    
    // コードから初期化したときに呼ばれる
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init(frame: CGRect)")
        initCustom()
    }
    // storyboard から初期化した時に呼ばれる
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init?(coder: NSCoder)")
        initCustom()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubView()")
        let image = UIImage(named: "CancelIcon")!
        self.iconView.image? = image
        self.titleLabel.text = "hoge"
        self.titleLabel.textColor = UIColor.white
        self.backgroundColor = UIColor.blue
        // 円形にする
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    func initCustom(){
        // Nib を読み込む
        //let bundle = Bundle(for: type(of: self))
        /*
        let nib = UINib(nibName: "HeaderButton", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else{
            return
        }
        */
        Bundle.main.loadNibNamed("HeaderButton", owner: self, options: nil)
        baseView.frame = self.bounds
        addSubview(baseView)
        // Gesture を設定
        addGestureRecognizer()
    }
    // viewController から呼び出す
    func vcInitCustom(str : String){
        self.titleLabel.text = str
        print(self.titleLabel)
    }
}

// tap, longTouch イベントを追加
// タップとロングタッチ療法を検知するには、UIGestureRecognizerDelegate を実装する必要がある
extension HeaderButton : UIGestureRecognizerDelegate{
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
                UIView.animate(withDuration: 0.5, animations: {
                    print("animate")
                    self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    self.iconView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                    self.titleLabel.alpha = 1
                }, completion: {_ in
                    self.nowState = false
                })
            }else{
                UIView.animate(withDuration: 0.5, animations: {
                    print("animate")
                    self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    self.iconView.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                    self.titleLabel.alpha = 0
                }, completion: {_ in
                    self.nowState = true
                })
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

