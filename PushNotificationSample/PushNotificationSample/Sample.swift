//
//  Sample.swift
//  PushNotificationSample
//
//  Created by 岡崎伸也 on 2019/12/13.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation

struct Sample : Codable{
    var coupon_id : Int
    var placementArea : [PlacementArea]
    var radius : Int
    var viewingStart : String
    var viewingEnd : String
    var enabledFlag : Bool
    var deletedFlag : Bool
}

struct PlacementArea : Codable{
    var lat : String
    var lng : String
    var memberStoreId : Int
}
