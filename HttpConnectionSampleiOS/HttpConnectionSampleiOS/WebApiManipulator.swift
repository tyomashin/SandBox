//
//  WebApiManipulator.swift
//  HttpConnectionSampleiOS
//
//  Created by 岡崎伸也 on 2019/09/16.
//  Copyright © 2019 sample. All rights reserved.
//
/**
 Todo:
  ・Codable
  ・JSON Object
  ・POST
  ・複数API を同時実行し、単一の結果を取得
  ・DB, UserDafaults Manipulator
 ・DispatchGroup : https://qiita.com/hyperkinoko/items/150342e388acf0c1f935
 */

import Foundation

class WebApiManipulator{
    
    private enum RequestMethod : String{
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
    }
    private enum WebApiResultType : String{
        case Success = "Success"
        case ClientError = "ClientError"
        case NoResponseError = "NoResponse"
        case ServerError = "ServerError"
    }
    

    
    static func sampleModelGet(){
        let sampleJson = """
{
"result" : {"id" : 10,"name":"hoge"},
"content" : {"info" : {"id" : 1}, "sage" : {"name" : "ho"}}
}
"""
        var jsonData = sampleJson.data(using: .utf8)!
        let sampleModel = try! JSONDecoder().decode(SampleModel.self, from: jsonData)
        print(sampleModel)
    }
    
    // URLSession を使用してJSONをGETする
    static func sampleGetRequest(){
        let URL_STRING = "https://randomuser.me/api"
        let url = URL(string: URL_STRING)
        /**
         Request の作成。
         用途によってカスタマイズする。
         https://developer.apple.com/documentation/foundation/urlrequest
         */
        var request = URLRequest(url : url!)
        // リクエストメソッドの設定
        request.httpMethod = RequestMethod.GET.rawValue
        // ヘッダーの設定
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("hoge", forHTTPHeaderField: "hoge_")
        
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            let resultType = errorCheck(data: data, response: response, error: error)
            switch resultType{
            case WebApiResultType.Success:
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(jsonObject)
                }catch let e {
                    print(e)
                }
            default:
                print("error")
            }
        }
        task.resume()
        
    }
    
    // HTTP 通信のレスポンスが正常に完了したかをチェック
    private static func errorCheck(data : Data?, response : URLResponse?, error : Error?) -> WebApiResultType{
        // エラーハンドリング
        if let error = error {
            print("urlsession error", "\(error.localizedDescription)\n")
            return WebApiResultType.ClientError
        }
        guard let data = data, let response = response as? HTTPURLResponse else{
            print("no data or no response")
            return WebApiResultType.NoResponseError
        }
        if response.statusCode == 200{
            print("success")
            dump(data)
            return WebApiResultType.Success
        }else{
            print("サーバサイドエラー：\(response.statusCode)\n")
            return WebApiResultType.ServerError
        }
    }
    
    // レスポンスデータを JSON
}
