//
//  SampleModel.swift
//  HttpConnectionSampleiOS
//
//  Created by 岡崎伸也 on 2019/09/18.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation

struct SampleModel : Codable {
    var result : Result
    var content : Content
}

struct Result : Codable{
    var id : Int
    var name : String
}
struct Content : Codable {
    var info : Info
    var sage : Sage
}

struct Info : Codable {
    var id : Int
}
struct Sage : Codable {
    var name : String
}

struct Re : Codable{
    var result : Result
}
