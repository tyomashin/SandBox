//
//  ContextMenuSampleViewController.swift
//  TableViewLongTapSample
//
//  Created by 岡崎伸也 on 2022/03/16.
//

import UIKit

/// TableView 長押し時の挙動確認 (ContextMenuを使用する)
class ContextMenuSampleViewController: UIViewController {

    private var dataList = [Int]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        (0..<10).forEach { dataList.append($0) }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ContextMenuSampleViewController: UITableViewDataSource {
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

extension ContextMenuSampleViewController: UITableViewDelegate {
    /// セル長押し時にコンテキストメニューを表示する
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let firstMenuAction = UIAction(title: "最初のメニュー", image: nil, identifier: nil, discoverabilityTitle: nil) { _ in
            print("メニュー選択時の処理")
        }
        let lastMenuAction = UIAction(title: "最後のメニュー", image: nil, identifier: nil, discoverabilityTitle: nil) { _ in
            print("メニュー選択時の処理")
        }
        
        let menu = UIMenu(title: "メニュー", image: nil, identifier: nil, options: [], children: [firstMenuAction, lastMenuAction])
        let contextMenuConfiguration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            menu
        }
        
        return contextMenuConfiguration
    }
}
