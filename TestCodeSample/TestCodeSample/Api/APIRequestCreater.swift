//
//  APIRequestCreater.swift
//  AlamofireSample
//
//  Created by 岡崎伸也 on 2020/08/17.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation
import Alamofire

final class APIRequestCreater{
    
    static func createRequest(urlStr: String, method: HTTPMethod, header: [String: String]) -> URLRequest?{
        guard let url = URL(string: urlStr) else{
            return nil
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 100
        request.method = method
        request.allHTTPHeaderFields = header
        return request
    }
}
