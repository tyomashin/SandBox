//
//  APISender.swift
//  AlamofireSample
//
//  Created by 岡崎伸也 on 2020/08/17.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation
import Alamofire

final class APIClient{
    
    static func getQiitaList(completion:@escaping(([APIData]?, APIErrorType?) -> Void)){
        let url = "https://qiita.com/api/v2/items"
        BaseAPIClient.baseGetRequest(baseUrl: url, path: "", queries: [:], completion: completion)
    }
}
