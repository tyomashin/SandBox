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
    @IBOutlet weak var underView: UIView!
    @IBOutlet weak var underViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var underViewLeadingConstraint: NSLayoutConstraint!
    
    let MIN_CELL_WIDTH: CGFloat = 100
    var selectedItem = 0
    
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

extension TabView: UICollectionViewDelegateFlowLayout{
    // func collectionnumber
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        print("collectionViewLayout", selectedItem)
        let height = collectionView.frame.height * 0.8
        //let width = max(self.frame.width * 0.2, MIN_CELL_WIDTH)
        let width = collectionView.frame.width * 0.25
        print(width, self.frame, collectionView.frame)
        
        if indexPath.row == selectedItem{
            underViewWidthConstraint.constant = width
        }
        
        return CGSize(width: width, height: height)
    }
}

extension TabView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath)

        if let cell = cell as? CustomCollectionViewCell {
            if indexPath.row == selectedItem{
                cell.label.textColor = .orange
                self.underViewLeadingConstraint.constant = cell.frame.origin.x
                UIView.animate(withDuration: 0.1){
                    self.layoutIfNeeded()
                }
            }else{
                cell.label.textColor = .gray
            }
        }
        print("cellForItemAt", cell.frame, cell.center)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = indexPath.row
        print("didSelectItemAt", selectedItem)
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
