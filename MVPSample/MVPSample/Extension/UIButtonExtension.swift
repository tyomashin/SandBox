//
//  UIButtonExtension.swift
//  MVPSample
//
//  Created by 岡崎伸也 on 2019/10/25.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    // 縦に画像とテキストを表示するボタン設定
    func makeCenterButtonImageAndTitle() {
      let spacing: CGFloat = 5
      let titleSize = self.titleLabel!.frame.size
      let imageSize = self.imageView!.frame.size

      self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                          left: -imageSize.width,
                                          bottom: -(imageSize.height + spacing),
                                          right: 0)
      self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing),
                                          left: -imageSize.width/2,
                                          bottom: 0,
                                          right: -titleSize.width)
    }
}
