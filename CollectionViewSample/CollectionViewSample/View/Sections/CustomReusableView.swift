//
//  CustomReusableView.swift
//  CollectionViewSample
//
//  Created by 岡崎伸也 on 2019/10/07.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation
import UIKit

class CustomReusableView: UICollectionReusableView {
    @IBOutlet var baseView: UIView!
    @IBOutlet weak var label: UILabel!
    
    
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
        Bundle.main.loadNibNamed("CustomReusableView", owner: self, options: nil)
        baseView.frame = self.bounds
        addSubview(baseView)
    }
    
}
