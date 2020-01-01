//
//  MainModel.swift
//  QiitaReaderSample
//
//  Created by 岡崎伸也 on 2019/10/27.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation

protocol MainModelDelegate : class {
    func didConnection(str : String)
}

/// WebAPI の通信を行って、取得したデータを構造体にマッピングしたリストをぷPresenterに返す
class MainModel{
    weak var delegate : MainModelDelegate?
    
    static var shared = MainModel()
    
    /// WebAPI 通信を行う
    func exeWebAPI(){
        /// hogehoge...
        delegate?.didConnection(str: "test")
    }
    
}
