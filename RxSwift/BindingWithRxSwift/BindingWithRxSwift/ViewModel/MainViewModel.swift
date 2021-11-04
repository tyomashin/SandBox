//
//  MainViewModel.swift
//  BindingWithRxSwift
//
//  Created by 岡崎伸也 on 2021/11/02.
//

import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelProtocol{
    var output: MainViewModelOutput{ get }
    var input: MainViewModelInput{ get }
}

/* output (ViewModel -> View) */
// memo: View側でイベントを流せないように制御できている
struct MainViewModelOutput{
    // Driver はエラーを流さないため、UI周りのストリームに適している
    var notification: Driver<String?>
}

/* input（View -> ViewModel） */
// memo: 「View側のイベントをViewModel側で受け取る」という用途は実現できている
// memo: デメリットとして、ViewModel側でストリームを作っているのでそれに対してイベントを流せてしまう。（普通の使い方をしていれば起こり得ないが、設計上は可能な操作となってしまっている）
// memo: -> このデメリットを解消するためには、ViewModel 側で View への参照（依存性逆転の法則によりプロトコルへの依存）を持つ必要がある。-> SecondViewModel 側で実装確認
struct MainViewModelInput{
    // memo: Relayからストリーム初期化
    // memo: デメリット：やろうと思えばView側からもViewModel側からもイベントを流せてしまう
    let tapButtonRelay = PublishRelay<Void>()
    let inputTextRelay: BehaviorRelay<String?>
    
    init(value: String?) {
        self.inputTextRelay = BehaviorRelay<String?>(value: value)
    }
}

/* ViewModelの実装例 */
// memo: ここではMVVMの依存関係を単一方向（View -> ViewModel）にするために、ViewModel内でViewへの参照を保持していない。
// memo: ViewModel でViewのプロトコルへの参照を持たせる実装パターンもあり、その場合はSignalやDriverなどRxCocoaのクラスを使用した実装が可能になる（ViewModel側でストリームを生成しなくて済むパターン）
// memo: -> SecondViewModel で実装確認
class MainViewModel: MainViewModelProtocol{
    
    /* Bidirectional（双方向バインディング） */
    // 基本的に双方向バインディングは、「単方向バインディングを２つ組み合わせる」つまり「Input, Output それぞれに双方向バインディングのための単方向バインディングの変数を用意する」アプローチで実現する。
    // memo: 他のアプローチとしては、双方向バインディングのための <-> 演算子を使用する
    // 双方向バインディングはあまり推奨されないと思っているためここでは試さない
    // 参考：https://dev.to/vaderdan/rxswift-reverse-observable-aka-two-way-binding-5e5n
    // https://qiita.com/cross-xross/items/c18744512cb37793b0a2
    //
    
    let output: MainViewModelOutput
    let input: MainViewModelInput
    
    /* ViewModel側でストリーム生成する（Output）用 */
    // memo: Relay はエラーを流さないため、UIへのデータストリームに向いている
    private let notificationRelay = BehaviorRelay<String?>(value: "init")
    
    /* ViewModel側で購読する用 */
    // Signal も Driver 同様にエラーを流さないため、UI周りのストリームに適している
    // Signal は Driver と異なり、最初に購読した時に初期値をリプレイしないため、ボタンタップ操作などに使用する
    private var tapButtonSignal: Signal<Void> {
        input.tapButtonRelay.asSignal()
    }
    private var inputTextDriver: Driver<String?> {
        input.inputTextRelay.asDriver()
    }
    
    private let disposeBag = DisposeBag()
    
    init(){
        self.output = MainViewModelOutput(notification: notificationRelay.asDriver())
        self.input = MainViewModelInput(value: "value")
        
        tapButtonSignal.emit(onNext: {
            print("tap button")
        }).disposed(by: disposeBag)
        
        inputTextDriver.drive(onNext: {value in
            print(value)
            self.notificationRelay.accept(value)
        }).disposed(by: disposeBag)
    }
}
