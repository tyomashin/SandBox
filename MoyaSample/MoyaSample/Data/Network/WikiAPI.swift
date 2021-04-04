//
//  WikiAPI.swift
//  MoyaSample
//
//  Created by 岡崎伸也 on 2021/04/03.
//

import Foundation
import Moya

/// 参考
/// http://y-hryk.hatenablog.com/entry/2018/08/24/101332
/// enum ではなく protocol で定義する方法もある
/// https://qiita.com/kouheiszk/items/46e9a233d9bb227c3b1d
enum WikiApi {
    // APIのエンドポイント定義
    case entityData(entityCode: String)
}

extension WikiApi: TargetType{
    var baseURL: URL {
        return URL(string: "https://www.wikidata.org/")!
    }
    
    var path: String {
        switch self {
        case let .entityData(entityCode: entityCode):
            return "wiki/Special:EntityData/" + entityCode
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .entityData(_):
            return .get
        }
    }
    
    /// テストデータ
    var sampleData: Data {
        switch self {
        case .entityData(_):
            return Data()
        }
    }
    
    /// https://github.com/Moya/Moya/blob/master/Sources/Moya/Task.swift
    var task: Task {
        switch self {
        case .entityData(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .entityData(_):
            return ["Content-Type": "application/json", "Accept": "application/json"]
        }
    }
}
