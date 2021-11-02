//
//  SampleViewModel.swift
//  ViewModelSample
//
//  Created by 岡崎伸也 on 2021/10/30.
//

import Foundation
import Combine

protocol SampleViewModelProtocol: ObservableObject {
    // Output
    var sample: String { get }
    var nextValue: String { get }
    var currentTime: String { get }
    var isShow: Bool{ get }
    
    func tapButton()
}

class SampleViewModel: SampleViewModelProtocol {
    @Published var sample: String = ""
    @Published var nextValue: String = ""
    @Published var currentTime: String = "no"
    @Published var isShow: Bool = false
    
    private let useCase: SampleUseCaseProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    init(useCase: SampleUseCaseProtocol) {
        self.useCase = useCase
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){_ in
            self.sample = "\(Date())"
            print("hoge!")
        }
        
        // 愚直な書き方
        useCase.subjectPub.sink(receiveValue: { value in
            self.nextValue = value
            print("nextValue!")
        })
        .store(in: &subscriptions)
        // 以下は assign を使用した例。@Published で宣言した変数にバインディングしている。
        // memo: 「$」は、PropertyWrapper の projectedValew　にアクセスするための修飾子。@Published 変数の場合は、「Published<>」にアクセスする。
        // memo: 「&」は、とにかく必要なキーワードらしい（https://developer.apple.com/documentation/combine/fail/assign(to:)）
        //useCase.subjectPub.assign(to: &$nextValue)
    }
    
    func tapButton(){
        useCase.getFutureWithDeferred()
            .sink(receiveValue: {value in
                self.currentTime = "\(value)"
                self.isShow = !self.isShow
            })
            .store(in: &subscriptions)
    }
}
