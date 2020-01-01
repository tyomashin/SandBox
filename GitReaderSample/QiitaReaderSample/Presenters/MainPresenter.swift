//
//  mainPresenter.swift
//  QiitaReaderSample
//
//  Created by 岡崎伸也 on 2019/10/27.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation
import UIKit

class MainPresenter{
    weak var view : MainInterface?
    var mainModel : MainModel?
    // View に描画するデータを保持する
    var resultList : [String] = ["1","1","1","1","1","1","1"]
    var tableCellSizeDic : [IndexPath: CGFloat] = [:]
    
    init(with view: MainInterface){
        self.view = view
        mainModel = MainModel()
        mainModel?.delegate = self
    }
    /// Model にWebAPI実行を依頼する
    func buttonTapped(){
        mainModel?.exeWebAPI()
    }
    /// tableview のスクロール位置が最下部にきたとき
    func tableViewWillBottom(){
        for _ in 0 ... 5{
            resultList.append("aaa")
        }
        view?.reloadNewData()
    }
}

/// MainModel の処理完了後に結果とともに通知される
extension MainPresenter : MainModelDelegate{
    func didConnection(str: String) {
        resultList.append(str)
        // 結果をViewに描画させる
        view?.setResult()
    }
}
