//
//  CFArray+Extension.swift
//  CoreTextSample
//
//  Created by 岡崎伸也 on 2022/05/30.
//

import Foundation

extension CFArray {
    
    func toArray<T>(sourceArray: CFArray) -> [T] {
        return (sourceArray as NSArray) as! [T]
    }
    
    /// CFArrayをSwiftのArrayに変換
    static func toArray<T>(sourceArray: CFArray) -> [T] {
        var destinationArray = [T]()
        let count = CFArrayGetCount(sourceArray)
        destinationArray.reserveCapacity(count)
        for index in 0..<count {
            let untypedValue = CFArrayGetValueAtIndex(sourceArray, index)
            let value = unsafeBitCast(untypedValue, to: T.self)
            destinationArray.append(value)
        }
        return destinationArray
    }
}
