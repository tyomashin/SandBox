//
//  HelloMetal-Bridging-Header.h
//  ManyRectangleMetalSample
//
//  Created by 岡崎伸也 on 2022/05/03.
//

/// ブリッジヘッダファイルを追加
/// memo: ヘッダファイルをSwift側で使用するための定義
/**
 プロジェクトファイルにもブリッジヘッダファイルの場所を指定する必要がある。
 1. BuildSettings -> Objective-C Bridging Header
 2. 「$(SRCROOT)/ManyRectangleMetalSample/Metal/HelloMetal-Bridging-Header.h」と入力する
 */
#ifndef HelloMetal_Bridging_Header_h
#define HelloMetal_Bridging_Header_h

#include "ShaderTypes.h"

#endif /* HelloMetal_Bridging_Header_h */
