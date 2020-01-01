//
//  TableViewCellExtension.swift
//  QiitaReaderSample
//
//  Created by 岡崎伸也 on 2019/10/27.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation
import UIKit

// カードビューっぽいレイアウトをつくる
// 参考
// https://medium.com/@puneetmaratha/show-your-tableview-cell-as-android-like-cardview-f08cca6e410a
extension UITableViewCell{
    func shadowAndBorderForCell(yourTableViewCell : UITableViewCell){
        yourTableViewCell.contentView.layer.borderWidth = 0.5
        yourTableViewCell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        yourTableViewCell.contentView.layer.masksToBounds = true
        yourTableViewCell.layer.shadowColor = UIColor.gray.cgColor
        yourTableViewCell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        yourTableViewCell.layer.shadowRadius = 2.0
        yourTableViewCell.layer.shadowOpacity = 1.0
        yourTableViewCell.layer.masksToBounds = false
        yourTableViewCell.layer.shadowPath = UIBezierPath(roundedRect:yourTableViewCell.bounds, cornerRadius:yourTableViewCell.contentView.layer.cornerRadius).cgPath
    }
}
