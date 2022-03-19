//
//  TapGestureSampleViewController.swift
//  TableViewLongTapSample
//
//  Created by 岡崎伸也 on 2022/03/16.
//

import UIKit

/// TableView 長押し時の挙動確認 ()
class TapGestureSampleViewController: UIViewController {
    
    private var dataList = [Int]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        (0..<10).forEach { dataList.append($0) }
        
        tableView.dataSource = self
        
        // TableView に長押し検知のためのジェスチャーを追加
        // https://stackoverflow.com/questions/37770240/how-to-make-tableviewcell-handle-both-tap-and-longpress
        // https://swiswiswift.com/2020-11-10/
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        // ロングタップを検出するまでの時間を指定
        // https://qiita.com/nemu_ru_00/items/7b0bd73d3518c952fc48
        longTap.minimumPressDuration = 0.5
        // 指のずれを許容する
        longTap.allowableMovement = 10
        tableView.addGestureRecognizer(longTap)
    }

    @objc func longTap(sender: UILongPressGestureRecognizer) {
        // 長押し判定時のみ処理する
        guard sender.state == .began else { return }
        // 指が離された位置
        let touchPoint = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            print(indexPath.description)
            
            // 確認用にアラートを表示
            showMessage(title: "長押し！", message: "\(indexPath.row)", tapOk: nil)
        }
    }
}

extension TapGestureSampleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: .zero)
        var content = cell.defaultContentConfiguration()
        content.text = dataList[indexPath.row].description
        cell.contentConfiguration = content
        return cell
    }
}
