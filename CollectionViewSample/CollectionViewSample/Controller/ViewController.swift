//
//  ViewController.swift
//  CollectionViewSample
//
//  Created by 岡崎伸也 on 2019/10/06.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //let sampleDataList1 : [SampleData1] = [SampleData1(), SampleData1()]
    //let sampleDataList2 : [SampleData2] = [SampleData2(),SampleData2(),SampleData2()]

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        // 使用するセルとヘッダーを登録する
        collectionView.register(CustomCell1.self, forCellWithReuseIdentifier: "CustomCell1")
        collectionView.register(CustomReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "CustomReusableView")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        */
        let mainScreen = MainScreen(frame: self.view.frame)
        self.view.addSubview(mainScreen)
    }
}
/*
extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
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

*/
