//
//  WikiDataRepository.swift
//  MoyaSample
//
//  Created by 岡崎伸也 on 2021/04/05.
//

import Foundation

protocol WikiDataRepositoryProtocol {
    func getWikiData(wikiCode: String) -> ApiResponse<WikiDataResponseEntity>
}
