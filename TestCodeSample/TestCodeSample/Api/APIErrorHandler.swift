//
//  APIErrorHandler.swift
//  AlamofireSample
//
//  Created by 岡崎伸也 on 2020/08/17.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation

enum APIErrorType{
    case NetworkError
    case ServerError
    case ClientError
    case InvalidUrlError
    case DataDecodeError
    case EmptyResponse
}

enum APIStatusType: Int, CaseIterable{
    case OK = 200
    case ClientError = 400
    case ServerError = 500
}

final class APIErrorHandler{
    
    static func handleErrorTypeFromStatusCode(statusCode: Int?) -> APIErrorType?{
        // ステータスコードがない場合
        guard let statusCode = statusCode else{
            return .ServerError
        }
        let statusType = APIStatusType(rawValue: statusCode)
        if let statusType = statusType, let errorType = toErrorTypeFromStatusType(statusType: statusType){
            return errorType
        }
        
        return nil
    }
    
    private static func toErrorTypeFromStatusType(statusType: APIStatusType) -> APIErrorType?{
        switch statusType {
        case .OK:
            return nil
        case .ClientError:
            return .ClientError
        case .ServerError:
            return .ServerError
        }
    }
}
