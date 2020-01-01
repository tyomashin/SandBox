//
//  MainPresenter.swift
//  MVPSample
//
//  Created by 岡崎伸也 on 2019/10/24.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation

class MainPresenter{
    weak var view : MainInterface?
    var mainModel : MainModel?
    var resultList : [String] = []
    
    init(with view: MainInterface){
        self.view = view
        mainModel = MainModel()
        mainModel?.delegate = self
    }
    
    /// Model にWebAPI実行を依頼する
    func buttonTapped(){
        mainModel?.exeWebAPI()
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
