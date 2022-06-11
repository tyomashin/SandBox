//
//  GlobalActorSample.swift
//  ConcurrencySample
//
//  Created by 岡崎伸也 on 2022/06/06.
//

import Foundation

@globalActor
public struct SomeGlobalActor {
    public actor MyActor { }

    public static let shared = MyActor()
}


@globalActor
public actor SomeGlobalActor2 {
    public actor ActorType { }

    public static var shared: ActorType = ActorType()
}

@SomeGlobalActor
struct SomeGlobalActorImple {
    
    static func sleepSample() {
        // sleep(3)
        print("finish sleep:", Thread.current)
    }
}

@SomeGlobalActor2
final class SomeGlobalActorImple2: NSObject {
    static let shared = SomeGlobalActorImple2()
    private var components = DateComponents()
    
    private override init() {
        self.components.calendar = Calendar.current
        super.init()
    }
    
    func sleepSample(date: Date) {
        print("start sleep", date)
        sleep(3)
        print("finish sleep:", date, Thread.current)
    }
}
