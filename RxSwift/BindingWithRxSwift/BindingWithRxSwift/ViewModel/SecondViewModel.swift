//
//  SecondViewModel.swift
//  BindingWithRxSwift
//
//  Created by 岡崎伸也 on 2021/11/03.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

protocol SecondViewModelProtocol{
    var output: SecondViewModelOutputProtocol { get }
}

/* output (ViewModel -> View) */
// memo: View側でイベントを流せないように制御できている
protocol SecondViewModelOutputProtocol{
    var notification: Driver<String?>{ get }
}

/* input（View -> ViewModel） */
// memo: 「View側のイベントをViewModel側で受け取る」という用途が実現できている
// memo: View 側のストリーム（RxCocoa 由来）を受け取っているため、ViewModel側でUIイベントを発火しないことが保証される
// memo: 気になる点として、ViewModel 側で View への参照（依存性逆転の法則によりプロトコルへの依存）を持つ必要がある
protocol SecondViewModelInputProtocol{
    // memo: View側のストリームを受け取る
    var tapButton: Signal<Void>{ get }
    var inputText: Driver<String?>{ get }
}

/* ViewModelの実装例 */
// memo: ここでは、View側のUIストリームをViewModelのイニシャライザで受け取るために、Viewの抽象に対する参照をViewModelで受け取っている（依存性逆転の法則）
// memo: -> ViewModel側ではViewから渡されたSignalやDriverなどを受け取って購読する（ViewModel側でUIストリーム管理せずに済む（ViewModel側でこれらのストリームを作ったところでどうということはないが））
class SecondViewModel: SecondViewModelProtocol{
    /* output (ViewModel -> View) */
    // memo: View側でイベントを流せないように制御できている
    struct SecondViewModelOutput: SecondViewModelOutputProtocol{
        // Driver はエラーを流さないため、UI周りのストリームに適している
        var notification: Driver<String?>
    }
    
    let output: SecondViewModelOutputProtocol
    let input: SecondViewModelInputProtocol
    
    /* ViewModel側でストリーム生成する（Output）用 */
    // memo: Relay はエラーを流さないため、UIへのデータストリームに向いている
    private let notificationRelay = BehaviorRelay<String?>(value: "init")
    
    private let disposeBag = DisposeBag()
    
    init(view: SecondViewModelInputProtocol){
        self.output = SecondViewModelOutput(notification: notificationRelay.asDriver())
        self.input = view
        
        input.tapButton.emit(onNext: {
            print("tap button")
        }).disposed(by: disposeBag)
        
        input.inputText.drive(onNext: {value in
            print(value)
            self.notificationRelay.accept(value)
        }).disposed(by: disposeBag)
    }
}
