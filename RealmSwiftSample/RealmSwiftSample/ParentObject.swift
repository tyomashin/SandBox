//
//  ParentObject.swift
//  RealmSwiftSample
//
//  Created by 岡崎伸也 on 2020/03/19.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation
import RealmSwift

protocol ParentObjectProtocol {
    static func getChildList() -> ParentObject?
}


extension ParentObjectProtocol{
    static func getChildList() -> ParentObject?{
        do{
            let realm = try Realm()
            return realm.objects(ParentObject.self).filter("id == '0'").first
        }catch{
            print(error)
        }
        return nil
    }
}


class ParentObject : Object, ParentObjectProtocol{
    @objc dynamic var id = "0"
    let childList = List<ChildObject>()
    
    func add(object : ParentObject){
        do{
            let realm = try Realm()
            try realm.write{
                realm.add(object)
            }
        }catch{
            print(error)
        }
    }
    
    func getUnit() -> ParentObject?{
            
        do{
            let realm = try Realm()
            return realm.objects(ParentObject.self).first
        }catch{
            print(error)
        }
        return nil
    }
    
    func debug(){
        let parentObject = ParentObject()
        let childObjects = ChildObject().getAll()
        childObjects.forEach{parentObject.childList.append($0)}
        add(object: parentObject)
    }
}
