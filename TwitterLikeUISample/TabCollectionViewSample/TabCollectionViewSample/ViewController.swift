//
//  ViewController.swift
//  TabCollectionViewSample
//
//  Created by micware on 2021/07/12.
//

import UIKit

class ViewController: UIViewController {
    private let TABLE_VIEW_OFFSET: CGFloat = 200
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tabView: TabView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topViewTopConstraints: NSLayoutConstraint!
    
    private let TOPVIEW_HEIGHT: CGFloat = 100
    // private var currentOffsetY: CGFloat = 0
    private var currentOffsetForDirection: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currentOffsetForDirection = -TABLE_VIEW_OFFSET
        tableView.contentInset = UIEdgeInsets(top: TABLE_VIEW_OFFSET, left: 0, bottom: 0, right: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var contentOffset = scrollView.contentOffset.y
        
        print("hoge, offset!", contentOffset, currentOffsetForDirection)
        let diff = contentOffset - currentOffsetForDirection
        print("hoge!, diff", diff)

        
        // 上方向スクロール
        if currentOffsetForDirection - contentOffset < 0, contentOffset > -TABLE_VIEW_OFFSET{
            print("up", contentOffset, -TABLE_VIEW_OFFSET)
            // ヘッダーViewがまだ見えている場合：ヘッダーをさらに隠すように移動させる
            if topViewTopConstraints.constant > -100{
                let diff = contentOffset - currentOffsetForDirection
                topViewTopConstraints.constant -= diff
                print("come!!!")
            }
            // ヘッダーViewが見えなくなった場合：その位置で固定する
            else{
                topViewTopConstraints.constant = -100
            }
        }
        // 下方向スクロール
        else {
            print("down")
            // TableViewの一番上のセルが見えている場合
            // TODO: ヘッダーの高さを考慮する（ヘッダーが全部隠れている場合は、contentOffset == -100 の時にヘッダーの高さも移動させなければならない）
            if contentOffset <= (-TABLE_VIEW_OFFSET - topViewTopConstraints.constant){
                print("hoge!!!!", (-TABLE_VIEW_OFFSET - topViewTopConstraints.constant))
                //contentOffset = TABLE_VIEW_OFFSET
                // ヘッダーViewがまだ下へ移動する余地がある場合
                if topViewTopConstraints.constant < 0{
                    let diff = contentOffset - currentOffsetForDirection
                    topViewTopConstraints.constant -= diff
                }
                // ヘッダーViewが下へ移動できない場合：その位置で固定する
                else{
                    topViewTopConstraints.constant = 0
                }
            }
            // TableViewを下方向へスクロールする余地がある場合
            else{
                // 何もしない
            }
        }
        
        currentOffsetForDirection = contentOffset
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        //let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell = UITableViewCell()
        // セルに表示する値を設定する
        cell.textLabel!.text = "\(indexPath.row)"
        return cell
    }
    
    
}
