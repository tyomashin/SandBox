//
//  ViewController.swift
//  BindingWithRxSwift
//
//  Created by 岡崎伸也 on 2021/11/02.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    private let viewModel: MainViewModelProtocol = MainViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        button.rx.tap.bind(to: viewModel.input.tapButtonRelay).disposed(by: disposeBag)
        textField.rx.value.bind(to: viewModel.input.inputTextRelay).disposed(by: disposeBag)
        
        viewModel.output.notification.drive(label.rx.text).disposed(by: disposeBag)
        
        /*
        viewModel.output.notification.drive(onNext: {value in
            self.label.text = value
        }).disposed(by: disposeBag)
        */
    }
}

