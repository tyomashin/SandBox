//
//  MainScreen.swift
//  CollectionViewSample
//
//  Created by 岡崎伸也 on 2019/10/10.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation
import UIKit

class MainScreen : UIView{
    
    @IBOutlet var baseView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topViewHeightConstaint: NSLayoutConstraint!
    
    var HEADER_FLAG = true
    
    let sampleDataList1 : [SampleData1] = [SampleData1(), SampleData1()]
    let sampleDataList2 : [SampleData2] = [SampleData2(),SampleData2(),SampleData2()]
    
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
    private func initCustom(){
        Bundle.main.loadNibNamed("MainScreen", owner: self, options: nil)
        baseView.frame = self.bounds
        addSubview(baseView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // 使用するセルとヘッダーを登録する
        collectionView.register(CustomCell1.self, forCellWithReuseIdentifier: "CustomCell1")
        collectionView.register(CustomReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "CustomReusableView")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addGestureRecognizer()
        
        changeHeader()
    }
    
    @IBAction func touchButton(_ sender: Any) {
        HEADER_FLAG = false
        changeHeader()
    }
    
    
    // ヘッダーの表示状態を変更する
    private func changeHeader(){
        // ヘッダーを表示する
        if HEADER_FLAG{
            
        }
        // ヘッダーの一部を非表示にする
        else{
            // ヘッダ下部エリアを非表示にする
            bottomView.isHidden = true
            // 非表示となった部分を埋めるように制約を変更する
            self.headerView.layoutIfNeeded()
            //topView.layoutIfNeeded()
            // headerView の高さ制約を変更する
            headerViewHeightConstraint.isActive = false
            headerView.heightAnchor.constraint(equalToConstant: topView.frame.height).isActive = true
            // トップビューを親ビューいっぱいに表示する
            topViewHeightConstaint.isActive = false
            topView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
            self.headerView.layoutIfNeeded()
            //topView.layoutIfNeeded()
        }
        
        /*
         self.headerView.layoutIfNeeded()
         // ヘッダ下部エリアを非表示にする
         bottomView.isHidden = true
         // headerView の高さ制約を変更する
         headerViewHeightConstraint?.isActive = false // nil になる
         outHeaderViewHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: topView.frame.height)
         outHeaderViewHeightConstraint?.isActive = true
         // トップビューを親ビューいっぱいに表示する
         outTopViewHeightConstaint = topView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
         outTopViewHeightConstaint?.isActive = true
         self.headerView.layoutIfNeeded()
         self.topView.layoutIfNeeded()
         */
    }
}

extension MainScreen : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //セクションの個数を返すメソッド
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    // セクションにおけるセル数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return sampleDataList1.count
        }else if section == 1{
            return sampleDataList2.count
        }else{
            return 0
        }
    }

    // 表示するセルを返す
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell1", for: indexPath) as! CustomCell1
        
        cell.baseView.backgroundColor = .red

        return cell
    }
    
    // セルのサイズを返す
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize(width: collectionView.frame.width, height: 150)
        }else if indexPath.section == 1{
            return CGSize(width: collectionView.frame.width, height: 200)
        }else{
            return CGSize.zero
        }
    }
    
    // ヘッダー、フッターのサイズをかえす
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0{
            return CGSize(width: collectionView.frame.width, height: 100)
        }else if section == 1{
            return CGSize(width: collectionView.frame.width, height: 100)
        }
        return CGSize.zero
    }
    
    // ヘッダー、フッターを返す
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        // ヘッダー
        if kind == UICollectionView.elementKindSectionHeader{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                             withReuseIdentifier: "CustomReusableView",
                                                                             for: indexPath) as! CustomReusableView

            headerView.baseView.backgroundColor = UIColor.blue
            headerView.label.text = "section \(indexPath.section)"
            return headerView
        }
        
        return UICollectionReusableView()
    }
}



// タップ関連
extension MainScreen : UIGestureRecognizerDelegate{
    func addGestureRecognizer(){
        // タップ中の動作
        let touchDown = UILongPressGestureRecognizer(target:self, action: #selector(touchDownGesture(sender:)))
        // 長押し検知までの時間を0にする
        touchDown.minimumPressDuration = 0
        touchDown.cancelsTouchesInView = false
        touchDown.delegate = self
        self.collectionView.addGestureRecognizer(touchDown)
        // タップ後の動作を設定
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        //tapGesture.numberOfTouchesRequired = 1
        //tapGesture.numberOfTapsRequired = 1
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        self.isUserInteractionEnabled = true
        self.collectionView.addGestureRecognizer(tapGesture)
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
            self.collectionView.alpha = 0.8
            HEADER_FLAG = true
            changeHeader()
        }
        else if sender.state == .ended{
            print("touchDown ended")
            self.collectionView.alpha = 1
            HEADER_FLAG = true
            changeHeader()
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
