//
//  SampleUseCase.swift
//  ViewModelSample
//
//  Created by 岡崎伸也 on 2021/10/30.
//

import Foundation
import Combine

protocol SampleUseCaseProtocol {
    // AnyPublisher == RxSwift.Observable のようなもの。subject に対してイベントを流せなくする（読み取り専用にラップ）
    // https://zenn.dev/yorifuji/articles/ios-swift-combine
    var subjectPub: AnyPublisher<String, Never> { get }
    
    // RxSwift.Single と同じ（厳密には違うが） Publisher を返す
    func getFutureWithDeferred() -> Deferred<Future<Date, Never>>
}

class SampleUseCase: SampleUseCaseProtocol {
    private let subject = PassthroughSubject<String, Never>()
    // eraseToAnyPublisher を使うことで、subject から AnyPublisher に変換できる（asObservableのようなもの）
    var subjectPub: AnyPublisher<String, Never>{ subject.eraseToAnyPublisher() }
    private var index = 0
    
    init() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){_ in
            self.index += 1
            self.subject.send("\(self.index)")
        }
    }
    
    /// 購読後に処理を実行して、結果を一度だけ流すPublisher
    /// memo: RxSwift.Single とほぼ同じ動きをする
    func getFutureWithDeferred() -> Deferred<Future<Date, Never>> {
        Deferred{
            Future<Date, Never>{callback in
                let date = Date()
                print("getFuture, \(date)")
                callback(.success(date))
                // 下は発火しない（最初の一つだけ）
                // callback(.success(date))
            }
        }
    }
}
