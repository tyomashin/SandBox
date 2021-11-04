//
//  SecondViewController.swift
//  BindingWithRxSwift
//
//  Created by 岡崎伸也 on 2021/11/05.
//

import UIKit
import RxSwift
import RxCocoa

class SecondViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    // ViewModel のイニシャライザにUIストリームを渡す必要があるのでオプショナルで定義
    // memo: 結局ViewModelはDIで外部から注入されるため、ViewController 側で受け取る限りオプショナルになることは仕方がない（StoryBoard を使用している場合、イニシャライザを定義しにくいので）
    private var viewModel: SecondViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = SecondViewModel(view: self)
        
        viewModel?.output.notification.drive(label.rx.text).disposed(by: disposeBag)
    }
}

extension SecondViewController: SecondViewModelInputProtocol{
    var tapButton: Signal<Void> {
        button.rx.tap.asSignal()
    }
    
    var inputText: Driver<String?> {
        textField.rx.text.asDriver()
    }
}
