//
//  CustomCell1.swift
//  CollectionViewSample
//
//  Created by 岡崎伸也 on 2019/10/07.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation
import UIKit

class CustomCell1 : UICollectionViewCell{
    @IBOutlet var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
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
        Bundle.main.loadNibNamed("CustomCell1", owner: self, options: nil)
        baseView.frame = self.bounds
        addSubview(baseView)
    }
    
}
