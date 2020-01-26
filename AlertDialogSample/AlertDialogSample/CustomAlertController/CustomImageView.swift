//
//  CustomImageView.swift
//  AlertDialogSample
//
//  Created by 岡崎伸也 on 2020/01/26.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import UIKit

class CustomImageView: UIView {

    @IBOutlet var baseView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit(){
        Bundle.main.loadNibNamed("CustomImageView", owner: self, options: nil)
        baseView.frame = self.bounds
        addSubview(baseView)
    }
    
}
