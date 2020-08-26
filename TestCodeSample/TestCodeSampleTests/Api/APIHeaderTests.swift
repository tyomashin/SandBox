//
//  APIHeaderTests.swift
//  TestCodeSampleTests
//
//  Created by 岡崎伸也 on 2020/08/27.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

@testable import TestCodeSample
import XCTest

class APIHeaderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_createHeader() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let result = APIHeader.createHeader()
        
        XCTAssertNotNil(result["hoge"])
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
