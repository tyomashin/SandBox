//
//  MapKitGeo.swift
//  MapKitSample
//
//  Created by 岡崎伸也 on 2019/09/14.
//  Copyright © 2019 sample. All rights reserved.
//
/**
 MapKit を使用した地名検索やジオコーディングをじ行うクラス
 */
import Foundation
import MapKit


class MapKitGeo{
    /**
     MKLocalSearch で場所検索を行なっている。
     引数にクロージャを受け取って検索完了後に行う処理を定義している。
     特徴：
      MKMapItem.name に場所名が含まれる。
      MKMapItem.placemark.title に住所が含まれる。
     参考：https://qiita.com/mshrwtnb/items/48fec048f55ad87121a7
    */
    static func mkLocalSearch(str : String,
                              completionHandler: @escaping (([MKMapItem], Error?) -> Void)){
        // リクエストの作成
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = str
        // 検索の実行
        MKLocalSearch(request: request).start{(response, error) in
            completionHandler(response?.mapItems ?? [], error)
        }
    }
}
