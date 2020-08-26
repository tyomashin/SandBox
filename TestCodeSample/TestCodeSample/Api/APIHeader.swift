//
//  APIHeaderCreater.swift
//  AlamofireSample
//
//  Created by 岡崎伸也 on 2020/08/17.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation

final class APIHeader{
    static func createHeader() -> [String: String]{
        var header: [String: String] = [:]
        header["hoge"] = "1"
        return header
    }
}
