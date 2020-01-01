//
//  ViewController.swift
//  QiitaReaderSample
//
//  Created by 岡崎伸也 on 2019/10/27.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit


protocol MainInterface : class{
    func setResult()
    func reloadNewData()
}

class ViewController: UIViewController {
    @IBOutlet weak var searchTermTextField: UITextField!
    @IBOutlet weak var mainTableView: UITableView!
    
    var mainPresenter : MainPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mainPresenter = MainPresenter(with: self)
        
        // セルの登録
        mainTableView.register(UINib(nibName: "TableViewCellSample1", bundle: nil),
                               forCellReuseIdentifier: "TableViewCellSample1")
        mainTableView.register(UINib(nibName: "TableViewCellContentView", bundle: nil),
                               forCellReuseIdentifier: "TableViewCellContentView")
        
        // セルの高さを動的にする設定
        // 参考：https://qiita.com/ytakzk/items/d7bb8182d43cdfc9b580
        mainTableView.estimatedRowHeight = 300 // 適当
        //mainTableView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }

    @IBAction func tapSearchButton(_ sender: Any) {
    }
    
}

extension ViewController : MainInterface{
    func setResult() {
    }
    func reloadNewData() {
        mainTableView.reloadData()
    }
}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainPresenter.resultList.count
        //return 10
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 高さが可変なセルとしている。
        // memo: cell の autolayout が重要。特にtopとbottomの制約をつけていることが重要
        return UITableView.automaticDimension
    }
    */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // セルの高さを格納する
        mainPresenter.tableCellSizeDic[indexPath] = cell.frame.size.height

        if indexPath.row + 1 == mainPresenter.resultList.count{
            mainPresenter.tableViewWillBottom()
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = mainPresenter.tableCellSizeDic[indexPath]{
            return height
        }
        return UITableView.automaticDimension
    }
    
}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellSample1",
                                                     for: indexPath) as! TableViewCellSample1
            cell.updateCellConstraint(state: .Full)
            //cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            cell.shadowAndBorderForCell(yourTableViewCell: cell)
            cell.layoutMargins = UIEdgeInsets.zero
            cell.layoutMargins.left = 20
            cell.backgroundColor = .blue
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellContentView",
                                                     for: indexPath) as! TableViewCellContentView
            //cell.updateCellConstraint(state: .Full)
            //cell.shadowAndBorderForCell(yourTableViewCell: cell)
            cell.backgroundColor = .white
            return cell
        }
        
        
        
        /*
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
        */
    }
}
