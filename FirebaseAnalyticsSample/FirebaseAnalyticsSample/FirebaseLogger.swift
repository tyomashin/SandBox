//
//  FirebaseLogger.swift
//  FirebaseAnalyticsSample
//
//  Created by 岡崎伸也 on 2020/03/27.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation
import FirebaseAnalytics
import FirebaseInstanceID
import Alamofire

class FirebaseLogger{
    
    static let CLIENT_ID = "976607547774-ragfptjv7hulc9uaubu2pvpe4miiejsa.apps.googleusercontent.com"
    static let REDIRECT_URI = "com.tyomashin.FirebaseAnalyticsSample://"
    
    /// 稼働状況を送信
    static func sendEventLog(){
        Analytics.logEvent("sendEventLog", parameters: nil)
    }
    
    /// 日付データ付き 稼働状況を送信
    /// - Parameters:
    ///   - bootDate: 日付情報
    static func sendEventLog( date : Date){
        Analytics.logEvent("sendEventLogDate", parameters: [
            "utc_time" : Int64(date.timeIntervalSince1970 * 1000),
        ])
    }
        
    /// アプリ内のユーザアナリティクスデータを削除
    static func deleteAppLog(){
        Analytics.resetAnalyticsData()
    }
        
    /// サーバ側のユーザアナリティクスデータを削除
    static func deleteServerLog(accessToken : String){
        // ユーザIDを取得
        InstanceID.instanceID().getID(handler: { identity, error in
        
            let urlStr = "https://www.googleapis.com/analytics/v3/userDeletion/userDeletionRequests:upsert"
            let url = URL(string: urlStr)!
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization" : "Bearer \(accessToken)"
            ]
            var bodyObject: [String:Any] = [:]
            bodyObject["kind"] = "analytics#userDeletionRequest"
            bodyObject["firebaseProjectId"] = "fir-analyticssample-b7b4d"
            var childBodyObject: [String: String] = [:]
            childBodyObject["type"] = "APP_INSTANCE_ID"
            childBodyObject["userId"] = identity
            bodyObject["id"] = childBodyObject
            var body: Data? = nil
            do {
                body = try JSONSerialization.data(withJSONObject: bodyObject, options: .fragmentsAllowed)
            } catch {
                body = nil
            }
            do{
                var urlRequest = try URLRequest(url: url, method: .post, headers: headers)
                urlRequest.httpMethod = "POST"
                urlRequest.timeoutInterval = 100.0
                if let body = body {
                    urlRequest.httpBody = body
                }
                AF.request(urlRequest).response { (response) in
                    print(response.response?.statusCode)
                    if let responseString = String(data: response.data!, encoding: .utf8) {
                        print("responseString \(responseString)")
                    }
                }
            }catch{
                print(error)
            }
        })
    }
        
    /// Google OAuth 認証を行なってアクセストークンを取得するための認証コードを取得
    static func getGoogleOAuthCodeForLogDelete(){
        var urlStr = "https://accounts.google.com/o/oauth2/v2/auth"
        var queries : [String:String] = [:]
        queries["client_id"] = CLIENT_ID
        queries["redirect_uri"] = REDIRECT_URI
        queries["response_type"] = "code"
        queries["scope"] = "https://www.googleapis.com/auth/analytics.user.deletion"
        
        var queryString = ""
        for(key, value) in queries {
            queryString += key + "=" + value + "&"
        }
        if queries.count > 0 {
            queryString.removeLast()
            queryString = "?" + queryString
        }
        
        urlStr += queryString
        
        guard let url = URL(string: urlStr) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    /// ログ削除のためのアクセストークンを取得
    static func getAccessTokenForLogDelete(code: String){
        let urlStr = "https://oauth2.googleapis.com/token"
        let url = URL(string: urlStr)!
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        var paramString: String = ""
        paramString = "grant_type=authorization_code"
            + "&client_id=\(CLIENT_ID)"
            + "&code=\(code)"
            + "&redirect_uri=\(REDIRECT_URI)"
        
        let urlEncodedParamString = paramString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        do{
            var urlRequest = try URLRequest(url: url, method: .post, headers: headers)
            urlRequest.timeoutInterval = 100.0
            urlRequest.httpBody = urlEncodedParamString.data(using: .utf8)
            
            AF.request(urlRequest).response { (response) in
                print(response.response?.statusCode)
                if let responseString = String(data: response.data!, encoding: .utf8) {
                    print("responseString \(responseString)")
                }
                if let data = response.data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
                            if let accessToken = json["access_token"] as? String{
                                deleteServerLog(accessToken: accessToken)
                            }
                        }
                    } catch {
                        print("Response->JSONObject変換に失敗した")
                    }
                }
            }
        }catch{
            print(error)
        }
    }
}
