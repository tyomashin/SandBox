//
//  BaseApiClient.swift
//  AlamofireSample
//
//  Created by 岡崎伸也 on 2020/08/17.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation
import Alamofire

class BaseAPIClient {
    
    private static func baseRequest<T:Codable>(request: URLRequest?, completion:@escaping((T?, APIErrorType?) -> Void)){
        guard let request = request else{
            completion(nil, .EmptyResponse)
            return
        }
        AF.request(request).response{(response) in
            //DebugLog.outputDebugLogFromData(data: response.data)
            // エラー時
            if let errorType = APIErrorHandler.handleErrorTypeFromStatusCode(statusCode: response.response?.statusCode){
                completion(nil, errorType)
                return
            }
            guard let data = response.data else{
                completion(nil, .EmptyResponse)
                return
            }
            
            do{
                let obj = try JSONDecoder().decode(T.self, from: data)
                completion(obj, nil)
            }catch{
                print(error)
                completion(nil, .DataDecodeError)
                return
            }
        }
    }
    
    static func baseGetRequest<T:Codable>(baseUrl: String, path: String, queries: [String:String], completion:@escaping((T?, APIErrorType?) -> Void)){
        let queryStr = APIQueryCreater.queryDicToString(queryDic: queries)
        let headers = APIHeaderCreater.createHeader()
        let url = baseUrl + path + queryStr
        let request = APIRequestCreater.createRequest(urlStr: url, method: .get, header: headers)
        
        baseRequest(request: request, completion: completion)
    }
    
    static func basePostRequest<T:Codable>(baseUrl: String, path: String, body: Data?, completion:@escaping((T?, APIErrorType?) -> Void)){
        
    }
}
