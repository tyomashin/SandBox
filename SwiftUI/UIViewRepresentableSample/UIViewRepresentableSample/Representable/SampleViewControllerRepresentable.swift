//
//  SampleViewControllerRepresentable.swift
//  UIViewRepresentableSample
//
//  Created by 岡崎伸也 on 2022/04/03.
//

import Foundation
import SwiftUI

/// UIViewController を SwiftUI で使うための実装
/// 参考：https://qiita.com/kazy_dev/items/f0850d7ee22d84192639
struct SampleViewControllerRepresentable: UIViewControllerRepresentable {
    /// SwiftUI側のデータとバインディングする
    @Binding var text: String
    
    let viewController: SampleViewController
    
    init(text: Binding<String>) {
        self.viewController = UIStoryboard(name: "Sample", bundle: nil).instantiateInitialViewController() as! SampleViewController
        self._text = text
    }
    
    /// UIKit のイベントを処理するために必要
    /// 参考：https://stackoverflow.com/questions/66540207/why-does-injecting-a-binding-into-uiviewcontrollerrepresentable-cause-a-retain-c
    /// https://s-cape.dev/uikit%E3%81%AEui%E3%82%92swiftui%E3%81%A7%E4%BD%BF%E3%81%86/
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    /// Viewの初期化処理
    func makeUIViewController(context: Context) -> SampleViewController {
        return viewController
    }
    
    /// データ更新時の処理. データ初期値もここにくる
    func updateUIViewController(_ uiViewController: SampleViewController, context: Context) {
        // VCのデリゲートにCoordinatorを登録
        // memo: 本来は「makeUIViewController」で登録したいが、まだIBOutletが初期化されていないのでここで登録している
        viewController.textField.delegate = context.coordinator
        
        viewController.label.text = text
    }
}

extension SampleViewControllerRepresentable {
    /// UIKitのイベントを処理するためのクラス. ここでは TextField の Delegate を処理している
    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: SampleViewControllerRepresentable
        
        init(parent: SampleViewControllerRepresentable) {
            self.parent = parent
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            parent.text = textField.text ?? ""
            print("bbb")
            
            return true
        }
    }
}
