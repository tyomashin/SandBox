//
//  SampleViewModel.swift
//  ConcurrencySample
//
//  Created by 岡崎伸也 on 2022/06/04.
//

import Foundation

class SampleViewModel: ObservableObject {
    
    let hogeActor = HogeActor()
    
    var count = 0
    
    init() {
        /* Note: 以下のように複数のTaskを同時に作成した場合、この順番で実行されるとは限らない
         例えば化の例では、hoge(id:) の中でTaskが実行される順番が「1,2,3,4,5, 7, 6」となることがあったり、実行タイミングによってバラバラになる.
             -> このため、実行順序が重要な場合は、以下の書き方は潜在的なバグを抱えることになる
         */
        /*
        hoge(id: 1)
        hoge(id: 2)
        hoge(id: 3)
        hoge(id: 4)
        hoge(id: 5)
        hoge(id: 6)
        hoge(id: 7)
        */
        
        /*
         ただし、以下のようにTaskを生成する間に一瞬待機すると、Taskを生成した順番通りに処理が進む。
         ただし、Task 内の処理は非同期に実行されるため、最終的な完了時間は前後する可能性がある。
           -> これを避けるためには、Task 内で Actor のメソッドを await で呼び出す。
              Actor のメソッドは同時に一つのスレッドからしか実行できないため、順番通りに処理を行うことができる.
         */
        /*
        hoge(id: 1)
        Thread.sleep(forTimeInterval: 0.00000000000000001)
        hoge(id: 2)
        Thread.sleep(forTimeInterval: 0.00000000000000001)
        hoge(id: 3)
        Thread.sleep(forTimeInterval: 0.00000000000000001)
        hoge(id: 4)
        Thread.sleep(forTimeInterval: 0.00000000000000001)
        hoge(id: 5)
        Thread.sleep(forTimeInterval: 0.00000000000000001)
        hoge(id: 6)
        Thread.sleep(forTimeInterval: 0.00000000000000001)
        hoge(id: 7)
        */
        /*
        Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in
            self.count += 1
            self.hoge(id: self.count)
        }
         */
        
        /*
        Task.detached(priority: .high) {
            while true {
                self.count += 1
                if self.count % 10000 == 0 {
                    print("task loop: ", self.count, Thread.current)
                }
            }
        }
        */
        
        // taskSample()
        
        // asyncLetSample()
        
        /*
        actorTaskSample(id: 1)
        Thread.sleep(forTimeInterval: 0.00000000000000001)
        actorTaskSample(id: 2)
        Thread.sleep(forTimeInterval: 0.00000000000000001)
        actorTaskSample(id: 3)
        */
        
        Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in
            Task {
                await SomeGlobalActorImple.sleepSample()
                // await SomeGlobalActorImple2.shared.sleepSample(date: Date())
            }
        }
    }
    
    func hoge(id: Int) {
        Task.detached(priority: .high) {
            print("start!!", id, Thread.current)
            // Actor のメソッドを呼び出しているため、排他的に実行される（シリアルキューに格納された処理のように実行される）
            // ただし条件があり、それは「Actor method 内で await が使われていない」という
            try await self.hogeActor.update(id: id, date: Date())
            print("await finish:", id, Thread.current)
            
            await print(self.hogeActor.idList)
            await print(self.hogeActor.lastDate)
        }
    }
    
    func hoge2(id: Int) {
        Task.detached(priority: .high) {
            try await self.sampleAsync(id: id)
        }
    }
    
    func sampleAsync(id: Int) async throws -> Int {
        /* サスペンションポイントの確認。
         await キーワードの前後でスレッドが切り替わっていることがわかる
         */
        print(id, Thread.current)
        try await Task.sleep( nanoseconds: 1 * 1000 * 1000 * 1000 )
        print(id, Thread.current)
        return id
    }
    
    /// 非構造化タスク
    /**
     Task は、非同期的な処理を並行に実行するためのコンテキストを提供する。
         * タスクは「async」メソッドを呼び出した時に作成されるわけではない
         * タスクを作る方法、作られるタイミングは決まっている（常に明示的に作成する）
     
     【Task.init】
     現在のアクターで実行されるタスクが生成される
     
     【Task.detached】
     現在のアクターのタスクではない「デタッチタスク」を作成する。
     */
    func taskSample() {
        // デタッチタスクを作成する
        Task.detached(priority: .high) {
            // このコンテキストで実行するタスクを作成する
            let handle = Task { () -> Int in
                print("start task")
                return 1
            }
            print("before await")
            // ここでTaskが完了されるまで待機する
            let result = await handle.value
            print("after await")
        }
    }
    
    /// async let 呼び出しのサンプル
    /**
     ◯async メソッドを並列に実行する
     async メソッドを await で呼び出すと、一度に1つのコードが実行される。
     この時、呼び出しもとは結果が返されるのを待ってから、次のコードを実行する。
     
     -> 「async let」を使うことで、Task が生成されて async メソッドを非同期に実行できる
     */
    func asyncLetSample() {
        Task.detached(priority: .high) {
            // Note: ここで3つの子Taskが生成されている
            async let first = self.taskSample2(id: 1)
            async let second = self.taskSample2(id: 2)
            async let third = self.taskSample2(id: 3)
            
            let results = await [first, second, third]
            print(results)
        }
    }
    
    func taskSample2(id: Int) async -> Int {
        let handle = Task { () -> Int in
            let random = Int.random(in: 0..<3)
            sleep(UInt32(random))
            return id
        }
        let result = await handle.value
        return result
    }
    
    
    /**
     Actor 内でTaskを呼び出す時の挙動を確認
     
     ◯構造化されていないタスク
     Task.init で生成されたタスクは「構造化されていないタスク」
     ・Actor 隔離を引き継ぐ
     
     ◯隔離されたタスク
     Tasi.detached で生成されたタスクは「隔離されたタスク」
     ・Actor 隔離を引き継がない
     
     ★今ひとつ挙動の違いがわかっていないので、ここは適当に流す
     */
    func actorTaskSample(id: Int) {
        Task.detached(priority: .high) {
            print("actorTaskSample start:", id)
            let result = await self.hogeActor.taskSample(id: id)
            print("actorTaskSample finish:", id)
        }
    }
}

/// Actor のサンプル
/// Note: Actor は
actor HogeActor {
    var idList = [Int]()
    private(set) var lastDate = Date()
    
    private var count = 0
    
    /// 以下のメソッドは同時に一度しか呼び出されない
    /// -> Serial Dispatch Queue でやっていたことと同じことができる
    func update(id: Int, date: Date) async throws {
        // Note: 単純なスリープ関数の場合、全ては同期的に実行されるためスレッドの切り替わりは発生しない
        sleep(1)
        idList.append(id)
        lastDate = date
        
        // Note: 以下のように、Actor 内で await キーワードが現れる場合（サスペンションポイント）は注意が必要
        // （詳細は以下のメソッド「updateWithSuspension」を参照のこと）
        // try await Task.sleep(nanoseconds: 1 * 1000 * 1000 * 1000)
    }
    
    func updateWithSuspension(id: Int, date: Date) async throws {
        // 以下のように、Actor 内で await キーワードが現れる場合（サスペンションポイント）、
        // ここで処理が一時停止している間にも他のスレッドからこのメソッドが実行される可能性がある。
        //   -> このため、Serial Dispatch Queue と同じ動作の実現はできなくなる
        // つまり、await キーワードの前後でActor内の状態が変わっている可能性がある
        try await Task.sleep(nanoseconds: 1 * 1000 * 1000 * 1000)
        idList.append(id)
        lastDate = date
    }
    
    func taskSample(id: Int) async -> Int {
        print("taskSample. Actor 隔離開始：", id)
        let hoge = Task { () -> Int in
            print("Child Task start:", id)
            return id
        }
        print("taskSample. finish", id)
        return await hoge.value
    }
}
