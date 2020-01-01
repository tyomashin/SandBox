//
//  TableViewController.swift
//  MVPSample
//
//  Created by 岡崎伸也 on 2019/10/24.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation
import UIKit

class SampleTableViewController : UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var firstButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 縦に画像とテキストを表示するボタン
        let origImage = UIImage(named: "sampleIcon")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        firstButton.setImage(tintedImage, for: .normal)
        firstButton.tintColor = .black
        firstButton.makeCenterButtonImageAndTitle()
        // セルの登録
        tableView.register(UINib(nibName: "SampleTableViewCell", bundle: nil), forCellReuseIdentifier: "SampleTableViewCell")
        // セルの高さを動的にする設定
        // 参考：https://qiita.com/ytakzk/items/d7bb8182d43cdfc9b580
        tableView.estimatedRowHeight = 300 // 適当
        //tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SampleTableViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 高さが可変なセルとしている。
        // memo: cell の autolayout が重要。特にtopとbottomの制約をつけていることが重要
        return UITableView.automaticDimension
    }
}
extension SampleTableViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SampleTableViewCell", for: indexPath) as! SampleTableViewCell
        var sampleText = "aaaaaaaaaaaaaaaaaaaaaaaaaa"
        cell.backgroundColor = .white
        for _ in 0 ... indexPath.row{
            sampleText += sampleText
        }
        cell.topLabel.text = sampleText
        for _ in 0 ... indexPath.row{
            sampleText += sampleText
        }
        cell.bottomLabel.text = sampleText
        let origImage = UIImage(named: "sampleIcon")
        let tintedImage = origImage?.withRenderingMode(.alwaysOriginal)
        cell.cellImageView.image = tintedImage
        //cell.layoutIfNeeded()
        return cell
    }
}
