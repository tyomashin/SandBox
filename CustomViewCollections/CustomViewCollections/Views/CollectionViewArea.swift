//
//  CollectionViewArea.swift
//  CustomViewCollections
//
//  Created by 岡崎伸也 on 2019/09/29.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit

class CollectionViewArea: UIView {

    @IBOutlet var baseView: UIView!
    @IBOutlet weak var collectionViewAreaLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var footerView: UIView!
    
    var collectionItemList : [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCustom()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCustom()
    }

    func initCustom(){
        Bundle.main.loadNibNamed("CollectionViewArea", owner: self, options: nil)
        baseView.frame = self.bounds
        addSubview(baseView)
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.height)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.delaysContentTouches = false
    }
    
    func initFromVC(list : [String]){
        collectionItemList = list
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension CollectionViewArea : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionItemList.count
    }
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 100)
    }*/
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //let totalCellWidth = (collectionView.frame.width / 2.5) * 12
        //let totalSpacingWidth = CellSpacing * (CellCount - 1)

        let cellWidth = collectionView.frame.width / 2.5
        let leftInset = (collectionView.frame.width / 2) - (cellWidth / 2)
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // セルを再利用キューから取り出す
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath)
        if let cell = cell as? CustomCollectionViewCell{
            let baseImage = UIImage(named: "sample-image")!.withRenderingMode(.alwaysOriginal)
            print(baseImage.size)

            cell.imageView.image = baseImage
            var imageTagList : [UIImage] = []
            var image = UIImage(named: "sample-image")!.withRenderingMode(.alwaysOriginal)
            imageTagList.append(image)
            imageTagList.append(image)
            image = UIImage(named: "baseline_book_black_36dp")!.withRenderingMode(.alwaysOriginal)
            imageTagList.append(image)
            cell.imageCollectionView.setUIImageTagList(imageList: imageTagList)
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
        //cell.baseView.backgroundColor = .lightGray
        cell.alpha = 0.9
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
        //cell.baseView.backgroundColor = .white
        cell.alpha = 1.0
    }
}
