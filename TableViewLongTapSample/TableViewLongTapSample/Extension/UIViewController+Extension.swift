//
//  UIViewController+Extension.swift
//  TableViewLongTapSample
//
//  Created by 岡崎伸也 on 2022/03/19.
//

import Foundation
import UIKit

extension UIViewController {
    /// アラートダイアログを表示する
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: 本文
    ///   - tapOk: OKタップ時の処理
    func showMessage(title: String? = nil, message: String? = nil, tapOk: (() -> Void)? = nil) {
        let alertDialog = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            tapOk?()
        }
        alertDialog.addAction(okAction)
        present(alertDialog, animated: true, completion: nil)
    }
}
