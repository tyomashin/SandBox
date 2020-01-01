//
//  SampleTableViewCell.swift
//  MVPSample
//
//  Created by 岡崎伸也 on 2019/10/25.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation
import UIKit

class SampleTableViewCell : UITableViewCell{
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    //@IBOutlet weak var topView: UIView!
    //@IBOutlet weak var bottomView: UIView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topLabel.textColor = .black
        bottomLabel.textColor = .black
    }
    
}
