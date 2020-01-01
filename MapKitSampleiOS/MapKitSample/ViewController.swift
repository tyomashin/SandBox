//
//  ViewController.swift
//  MapKitSample
//
//  Created by 岡崎伸也 on 2019/09/12.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    var searchCompleter = MKLocalSearchCompleter()
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        print(textField?.text ?? "")
        // MKLocalSearchCompleter の実行
        searchCompleter.delegate = self
        searchCompleter.queryFragment = textField?.text ?? ""
        // MKLocalSearch の実行
        MapKitGeo.mkLocalSearch(str: textField?.text ?? ""){result,error in
            if error != nil || result.count == 0{
                print("error")
            }
            else{
                for i in 0 ... result.count - 1{
                    print("name : \(String(describing: result[i].name)), placemark.title : \(String(describing: result[i].placemark.title))")
                }
                // View の描画処理など
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    // セルの加工
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = textField.text
        return cell
    }
}

// MKLocalSearchCompleter の結果を受け取るデリゲート
extension ViewController : MKLocalSearchCompleterDelegate{
    // 正常に完了した時
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter){
        if completer.results.count != 0 {
            for i in 0 ... completer.results.count - 1{
                print("title : \(completer.results[i].title),subtitle : \(completer.results[i].subtitle)")
            }
        }else{
            print("result zero")
        }
    }
    // エラー時
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error){
        print(error)
    }
}
