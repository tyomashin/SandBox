//
//  tableViewCellSample1.swift
//  QiitaReaderSample
//
//  Created by 岡崎伸也 on 2019/10/27.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation
import UIKit

class TableViewCellSample1 : UITableViewCell{
    
    // セルのコンテンツに画像があるかどうかの種別
    enum CellState{
        case Full
        case NotImage
    }
    
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionImageView: UIImageView!
    
    @IBOutlet weak var descriptionImageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionImageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelAndImageViewHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionTitleLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelTrailingConstraint: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //let margins = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        //self.layoutMargins = margins
    }
    /// セルの制約を変更する
    func updateCellConstraint(state : CellState){
        switch state {
        case .Full:
            //descriptionImageView.isHidden = true
            descriptionLabelTrailingConstraint.priority = UILayoutPriority(rawValue: 1)
            descriptionImageViewTrailingConstraint.priority = UILayoutPriority(rawValue: 1000)
            descriptionLabelAndImageViewHorizontalConstraint.priority = UILayoutPriority(rawValue: 1000)
            // Todo: ImageView とラベルの大きい方の制約を使うこと
            descriptionTitleLabelBottomConstraint.priority = UILayoutPriority(rawValue: 1000)
            descriptionImageViewBottomConstraint.priority = UILayoutPriority(rawValue: 1)
        case .NotImage:
            //descriptionLabelTrailingConstraint.priority = UILayoutPriority(rawValue: 1000)
            descriptionTitleLabelBottomConstraint.priority = UILayoutPriority(rawValue: 1000)
        }
    }
}
