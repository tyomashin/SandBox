//
//  ViewController.swift
//  ModernCollectionView
//
//  Created by 岡崎伸也 on 2022/10/01.
//

import UIKit

/// モダンなCollectionViewの実装サンプル.
class ViewController: UIViewController {

    lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    /// レイアウトの設定.
    /// UICollectionViewCompositionalLayout は、「小さなコンポーネントを組み合わせて完全なレイアウトを構成する」.
    /// セクション単位で、見た目が違うコンポーネントをグループ化する.
    /// https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout
    ///
    /// また、セクションごとに異なるレイアウトを使用する場合、UICollectionViewCompositionalLayoutSectionProvider を使用する必要がある.
    /// -> 以下ではこの例をコーディング
    lazy var layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self]
        (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
        
        guard let section = Section(rawValue: sectionIndex) else { return nil }
        
        // セクションごとに、コンポーネントのレイアウトを定義する.
        //   - まずアイテムからグループへ、グループからセクションへ、そして最後にレイアウトへと構築することで、コンポーネント全体を構成
        switch section {
        case .topHeader:
            // 1. アイテムのサイズ・レイアウトを決める
            //      - width: グループの横幅いっぱいに指定. fractional は「親サイズに対する比率」を指定する
            //      - height: グループの縦幅いっぱいに指定
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            // アイテム間のスペース
            // item.contentInsets = .init(top: 5, leading: 20, bottom: 5, trailing: 20)
            
            // 2. グループのサイズ・レイアウトを決める
            //      - width: セクションに対する横幅を指定
            //      - height: 絶対値で高さを指定
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1), heightDimension: .absolute(60))
            // グループのレイアウトを指定する。
            // horizontal は水平に、vertical は垂直にアイテムが並ぶ.
            //      - submit: グループ内のアイテムのレイアウト
            //      - count: グループ内のアイテム数
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
            // NOTE: 以下のような指定もできる. グループ内のアイテム数は、submits.count となる.
            // let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item1, item2])
            
            // アイテム間のスペース
            group.interItemSpacing = .fixed(0)
            
            // 3. セクションのレイアウトを決める
            let sectionLayout = NSCollectionLayoutSection(group: group)
            // グループ間のスペース指定
            sectionLayout.interGroupSpacing = 0
            // セクション間のスペース指定
            sectionLayout.contentInsets = .init(top: 20, leading: 10, bottom: 20, trailing: 10)
            return sectionLayout
        }
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

