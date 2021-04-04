//
//  ApiDataStore.swift
//  MoyaSample
//
//  Created by 岡崎伸也 on 2021/04/04.
//

import Foundation
import Moya
import RxSwift

protocol ApiProtocol {
    func request<T: TargetType, U: Codable>(targetType: T) -> Observable<ApiResponse<U>>
}

extension ApiProtocol{
    func request<T: TargetType, U: Codable>(targetType: T) -> Observable<ApiResponse<U>>{
        let provider = MoyaProvider<T>()
        return Observable.create{ observer in
            provider.request(targetType){event in
                switch event{
                case let .success(result):
                    if let responseEntity = try? JSONDecoder().decode(U.self, from: result.data){
                        observer.onNext(.success(response: responseEntity))
                    }else{
                        observer.onNext(.uniqueError(error: .dataEmpty))
                    }
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
