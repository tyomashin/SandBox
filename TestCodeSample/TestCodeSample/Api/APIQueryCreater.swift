//
//  APIQueryCreater.swift
//  AlamofireSample
//
//  Created by 岡崎伸也 on 2020/08/17.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation

final class APIQueryCreater{
    static func queryDicToString(queryDic: [String:String]) -> String{
        var queryString = ""
        queryDic.forEach{(key, value) in
            queryString += key + "=" + value + "&"
        }
        if queryDic.count > 0{
            queryString.removeLast()
            queryString = "?" + queryString
        }
        return queryString
    }
}
