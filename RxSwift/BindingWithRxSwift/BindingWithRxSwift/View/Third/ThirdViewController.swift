//
//  ThirdViewController.swift
//  BindingWithRxSwift
//
//  Created by 岡崎伸也 on 2021/11/04.
//

import UIKit
import RxSwift
import RxCocoa

class ThirdViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    private let viewModel = ThirdViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 双方向バインディング
        (textField.rx.text <-> viewModel.textRelay).disposed(by: disposeBag)
        
        // この書き方だと双方向バインディングにはならない
        //textField.rx.text.bind(to: viewModel.textRelay).disposed(by: disposeBag)
    }
}

infix operator <-> : DefaultPrecedence

func <-> <T>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    let bindToUIDisposable = relay.bind(to: property)
    let bindToRelay = property
        .subscribe(onNext: { n in
            relay.accept(n)
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })

    return Disposables.create(bindToUIDisposable, bindToRelay)
}
