//
//  WikiDataDataStore.swift
//  MoyaSample
//
//  Created by 岡崎伸也 on 2021/04/03.
//

import Foundation
import RxSwift
import Moya
//import RxMoya
//import RxMoya

protocol WikiDataStoreProtocol: ApiProtocol {
    func getWikiData(wikiCode: String) -> Observable<ApiResponse<WikiDataResponseEntity>>
}

struct WikiDataStore: WikiDataStoreProtocol {
    func getWikiData(wikiCode: String) -> Observable<ApiResponse<WikiDataResponseEntity>>{
        return request(targetType: WikiApi.entityData(entityCode: wikiCode))
    }
}
