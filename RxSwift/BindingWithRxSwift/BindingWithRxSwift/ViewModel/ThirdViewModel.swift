//
//  ThirdViewModel.swift
//  BindingWithRxSwift
//
//  Created by 岡崎伸也 on 2021/11/04.
//

import Foundation
import RxSwift
import RxCocoa

/// 双方向バインディング
class ThirdViewModel{
    let textRelay = BehaviorRelay<String?>(value: nil)
    var validationDriver: Driver<String?>{
        textRelay.asDriver()
    }
    private let disposeBag = DisposeBag()
    
    init(){
        textRelay
            .compactMap{ $0 }
            .subscribe(onNext: {value in
                print("text: \(value)")
                // バリデーションチェック：「10文字以上は入力させない」制御をする
                // memo: ここでtextRelayを更新しようとすると警告が表示されて無限ループする
                if (value.count >= 10){
                    let newValue = String(value.prefix(9))
                    self.textRelay.accept(newValue)
                }
            })
            .disposed(by: disposeBag)
    }
}
