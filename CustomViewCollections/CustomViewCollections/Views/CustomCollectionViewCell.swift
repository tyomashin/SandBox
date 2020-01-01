//
//  CustomCollectionViewCell.swift
//  CustomViewCollections
//
//  Created by 岡崎伸也 on 2019/09/29.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imageCollectionView: ImageCollectionView!
    
    
    
    var iconImageView : UIImageView? = nil
    var iconImageView2 : UIImageView? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCustom()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCustom()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initCustom()
    }

    func initCustom(){
        Bundle.main.loadNibNamed("CustomCollectionViewCell", owner: self, options: nil)
        baseView.frame = self.bounds
        addSubview(baseView)
        baseView.backgroundColor = .white
        addGestureRecognizer()
    }
    // セルが再利用される際に既存のデータが入らないようにする
    override func prepareForReuse() {
        imageView.image = nil
        baseView.backgroundColor = .white
        iconImageView?.removeFromSuperview()
        iconImageView2?.removeFromSuperview()
    }
}


extension CustomCollectionViewCell : UIGestureRecognizerDelegate{
    func addGestureRecognizer(){
        // タップ中の動作
        let touchDown = UILongPressGestureRecognizer(target:self, action: #selector(touchDownGesture(sender:)))
        // 長押し検知までの時間を0にする
        touchDown.minimumPressDuration = 0
        touchDown.cancelsTouchesInView = false
        touchDown.delegate = self
        //self.addGestureRecognizer(touchDown)
        //self.button.addGestureRecognizer(touchDown)
        // タップ後の動作を設定
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        //tapGesture.numberOfTouchesRequired = 1
        //tapGesture.numberOfTapsRequired = 1
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        //self.isUserInteractionEnabled = true
        //self.addGestureRecognizer(tapGesture)
        //self.button.addGestureRecognizer(tapGesture)
    }
    // 同一View上で指が話された時、何らかの処理を行う
    @objc func tapGesture(sender: UITapGestureRecognizer){
        //self.transform.scaledBy(x: 1.5, y: 1.5)
        if sender.state == .ended{
            print("tapGesture ended")
        }
    }
    // 見栄えの変更
    @objc func touchDownGesture(sender: UILongPressGestureRecognizer){
        if sender.state == .began{
            print("touchDown began")
            self.button.alpha = 0.8
        }
        else if sender.state == .ended{
            print("touchDown ended")
            self.button.alpha = 1
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
        return true
    }
}

