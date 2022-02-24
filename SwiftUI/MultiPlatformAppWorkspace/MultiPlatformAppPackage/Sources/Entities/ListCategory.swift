//
//  ListCategory.swift
//  MultiPlatformAppMac (macOS)
//
//  Created by 岡崎伸也 on 2022/01/08.
//

import SwiftUI

public enum ListCategory: String, CaseIterable, Identifiable{
    case Sample
    case Hoge
    
    // Identifiableに準拠
    public var id: Self { self }
}
