//
//  SampleObject1.swift
//  RealmSwiftSample
//
//  Created by 岡崎伸也 on 2020/03/19.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation
import RealmSwift

class ChildObject : Object{
    @objc dynamic var id = "0"
    @objc dynamic var name = ""
    @objc dynamic var createdAt: Double = 0
    
    
    func add(object : ChildObject){
        do{
            let realm = try Realm()
            try realm.write{
                realm.add(object)
            }
        }catch{
            print(error)
        }
    }
    
    func getAll() -> [ChildObject]{
        var array : [ChildObject] = []
        do{
            let realm = try Realm()
            let targetList = realm.objects(ChildObject.self)
            targetList.forEach{array.append($0)}
        }catch{
            print(error)
        }
        return array
    }
    
    func debug(){
        let hoge1 = ChildObject()
        hoge1.id = "0"
        add(object: hoge1)
        
        let hoge2 = ChildObject()
        hoge2.id = "1"
        add(object: hoge2)
    }
}
