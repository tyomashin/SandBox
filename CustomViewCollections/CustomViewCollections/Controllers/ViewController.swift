//
//  ViewController.swift
//  CustomViewCollections
//
//  Created by 岡崎伸也 on 2019/09/29.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var collectionItemList = [
        "1","2"
    ]

    @IBOutlet weak var collectionViewArea: CollectionViewArea!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewArea.initFromVC(list: collectionItemList)
    }
}

