//
//  WikiDataEntity.swift
//  MoyaSample
//
//  Created by 岡崎伸也 on 2021/04/03.
//

import Foundation

struct WikiDataResponseEntity: Codable {
    var entities: [String: WikiDataDetails]?
}

struct WikiDataDetails: Codable {
    var labels: WikiDataJapanLabel?
}

struct WikiDataJapanLabel: Codable {
    var ja: WikiDataLabelDetail?
}

struct WikiDataLabelDetail: Codable {
    var language: String?
    var value: String?
}
