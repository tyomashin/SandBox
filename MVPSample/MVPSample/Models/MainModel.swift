//
//  MainModel.swift
//  MVPSample
//
//  Created by 岡崎伸也 on 2019/10/24.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation

protocol MainModelDelegate : class {
    func didConnection(str : String)
}

class MainModel{
    weak var delegate : MainModelDelegate?
    
    let HOGE : String = {
        if let hoge = UserDefaults.standard.string(forKey: "hoge"){
            return hoge
        }else{
            UserDefaults.standard.set("hoge", forKey: "hoge")
            return "aaa"
        }
    }()
    
    static var shared = MainModel()
    
    /// WebAPI 通信を行う
    func exeWebAPI(){
        /// hogehoge...
        delegate?.didConnection(str: HOGE)
    }
    
}
