//
//  APITests.swift
//  TestCodeSampleTests
//
//  Created by 岡崎伸也 on 2020/08/27.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

@testable import TestCodeSample
import XCTest
import Mockingjay

class APITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// ステータスコード400エラーテスト
    func test_APIRequestStatusCode400Test(){
        // 全ての通信で400エラーが返されるように
        stub(everything, http(400))
        
        // 非同期通信のテスト
        let exp = expectation(description: "network")
        
        // 任意のWebAPIを実行
        APIClient.getQiitaList(){result, error in
            // クライアントエラー
            XCTAssertEqual(error, APIErrorType.ClientError)
            // 非同期通信終了
            exp.fulfill()
        }
        
        // 非同期通信の完了を待たずテストが終わらないように
        wait(for: [exp], timeout: 3)
    }
    
    /// ステータスコード500エラーテスト
    func test_APIRequestStatusCode500Test(){
        // 全ての通信で500エラーが返されるように
        stub(everything, http(500))
        
        // 非同期通信のテスト
        let exp = expectation(description: "network")
        
        // 任意のWebAPIを実行
        APIClient.getQiitaList(){result, error in
            // サーバーエラー
            XCTAssertEqual(error, APIErrorType.ServerError)
            // 非同期通信終了
            exp.fulfill()
        }
        
        // 非同期通信の完了を待たずテストが終わらないように
        wait(for: [exp], timeout: 3)
    }
    
    /// レスポンスが空のエラーテスト
    func test_APIRequestEmptyDataTest(){
        // 空のレスポンスを返すように
        //stub(http(.get, uri: Consts.WebAPI.LOGIN_PATH), json(Optional<String>.none as Any))
        stub(everything, http(200))
        
        // 非同期通信のテスト
        let exp = expectation(description: "network")
        
        // 任意のWebAPIを実行
        APIClient.getQiitaList(){result, error in
            // エンプティデータエラー
            XCTAssertEqual(error, APIErrorType.EmptyResponse)
            // 非同期通信終了
            exp.fulfill()
        }
        
        // 非同期通信の完了を待たずテストが終わらないように
        wait(for: [exp], timeout: 3)
    }
    
    /// レスポンスデータのデコードエラーテスト
    func test_APIRequestDecodeErrorTest(){
        // デコードできないデータをセット
        let responseData : [String: Any] = ["title": 0, "body": 0]
        stub(http(.get, uri: "https://qiita.com/api/v2/items"), json(responseData))
        
        // 非同期通信のテスト
        let exp = expectation(description: "network")
        
        // 任意のWebAPIを実行
        APIClient.getQiitaList(){result, error in
            // エンプティデータエラー
            XCTAssertEqual(error, APIErrorType.DataDecodeError)
            // 非同期通信終了
            exp.fulfill()
        }
        
        // 非同期通信の完了を待たずテストが終わらないように
        wait(for: [exp], timeout: 3)
    }
    
    /// 正常系
    /// TODO：WebAPI未実装のため仮
    func test_APIRequestForGetLogin(){
        // デコードできないデータをセット
        let responseData : [String: Any] = ["title": "test", "body": "hoge"]
        stub(http(.get, uri: "https://qiita.com/api/v2/items"), json(responseData))
        
        // 非同期通信のテスト
        let exp = expectation(description: "network")
        
        // 任意のWebAPIを実行
        APIClient.getQiitaList(){result, error in
            //XCTAssertEqual(result?.title, "test")
            //XCTAssertEqual(result?.body, "hoge")
            // 非同期通信終了
            exp.fulfill()
        }
        
        // 非同期通信の完了を待たずテストが終わらないように
        wait(for: [exp], timeout: 3)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
