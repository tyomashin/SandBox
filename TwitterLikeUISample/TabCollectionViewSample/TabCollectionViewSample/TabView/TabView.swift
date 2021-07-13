//
//  TabView.swift
//  TabCollectionViewSample
//
//  Created by micware on 2021/07/12.
//

import UIKit

class TabView: UIView {

    @IBOutlet var baseView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// コードからの初期化時に呼ばれる
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCustom()
    }

    /// ストーリーボードからの初期化時に呼ばれる
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCustom()
    }

    /// 画面初期化時に呼ばれる
    private func initCustom() {
        Bundle.main.loadNibNamed("TabView", owner: self, options: nil)
        baseView.frame = self.bounds
        addSubview(baseView)
        
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

extension TabView: UICollectionViewDelegate{
    // func collectionnumber
}

extension TabView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath)

        if let cell = cell as? CustomCollectionViewCell {
            //cell.setupCell(model: models[indexPath.row])
        }
        

        return cell
    }
}
