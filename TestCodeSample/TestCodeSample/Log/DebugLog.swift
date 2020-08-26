//
//  DebugLog.swift
//  AlamofireSample
//
//  Created by 岡崎伸也 on 2020/08/17.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation

class DebugLog{
    static func outputDebugLogFromData(data: Data?){
        if let data = data, let responseStr = String(data: data, encoding: .utf8){
            print(responseStr)
        }
    }
}
