//
//  String+Extension.swift
//  AlertDialogSample
//
//  Created by 岡崎伸也 on 2020/02/02.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation

/// 多言語対応したStringを取得する拡張クラス
extension String{
    var localized : String{
        return NSLocalizedString(self, comment: "")
    }
    /*
    var localized: String {
      let lang = {アプリ内で設定している言語の文字列を取得するコード}
      // lang からリソースのパスを取得して bundle を取得
      guard let path = Bundle.main.path(forResource: lang, ofType: "lproj"),
        let bundle = Bundle(path: path) else {
          // bundle が取得できなかった場合は端末の言語設定を元に切り替える
          return NSLocalizedString(self, comment: "")
      }
      // 取得した bundle でキーを参照して切り替える
      return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    */
}
