//
//  ApiResponse.swift
//  MoyaSample
//
//  Created by 岡崎伸也 on 2021/04/04.
//

import Foundation

enum ApiResponse<T: Codable> {
    case success(response: T)
    case commonError(error: Error)
    case uniqueError(error: UniqueError)
}

enum UniqueError {
    case dataEmpty
}
