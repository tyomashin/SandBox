//
//  URL+Extention.swift
//  FirebaseAnalyticsSample
//
//  Created by 岡崎伸也 on 2020/03/29.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation

extension URL {
    public func queryParams() -> [String : String] {
        var params = [String : String]()

        guard let comps = URLComponents(string: self.absoluteString) else {
            return params
        }
        guard let queryItems = comps.queryItems else { return params }

        for queryItem in queryItems {
            params[queryItem.name] = queryItem.value
        }
        return params
    }
}
