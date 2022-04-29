//
//  PointerSample.swift
//  PointerAndConflictSample
//
//  Created by 岡崎伸也 on 2022/04/01.
//

import Foundation

/*
 memo:
 
 「Unsafe」とは？
 ・参照するメモリの管理をARCで行なっていない
 
 「Mutable」とは？
 ・ポインタが指すメモリ領域に書き込んで変更できることを意味する
 　　C言語の場合： (int *) 型
 　　Swiftの場合：UnsafeMutablePointer<Int32>
 
 ・一方で、値を書き換えないポインタは以下
 　　C言語の場合：（const int *）型
 　　Swiftの場合：UnsafePointer<Int32>
 
 ----
 「UnsafeRawPointer」
 ・C言語で「void *」型のポインターで、純粋なメモリの参照位置のこと。
 
 ----
 「&」記号について
 ・「変数へのポインタ」を取得する場合に、「&hoge」のように使う
 
 ----
◯ ポインタを使ってメモリにアクセスする
 アンセーフポインタは構造体で定義されている。
 
 UnsafePointer p が存在する場合、
 ・p.pointee でデータへのアクセスが可能
 ・p[0] でもOK
 ・p += 1 でポインタを一つ進めたりできる
 
 ---
 参考文献
 ・Swiftの参考書
 */

class PointerSample {
    var buffer = [ 0.01, 10.0, 25.4, 31.9 ]
    var sampleList = [SampleModel]()
    
    private let queue = DispatchQueue(label: "pointee.serial.queue", qos: .userInteractive)
    
    init() {
        /* 以下は参考書のサンプルコードを試したもの。
         　参考書にも注意書きされているが、以下を注意。
         　「Swiftが管理する通常の変数は、アンセーフポインタに渡したメモリ位置をずっと使用しているとは限りません。
         　　（Copy-On-Writeなどの挙動に依存）。
         　　このプログラムは実験例であり、一般には動作が保証されない書き方であることに留意してください。」
         */
        
        // TODO: なぜか警告が出ているので調べる
        // 追記：以下の書き方だと、ポインタが解放されない（Unsafe == ARCの管理下にない）らしい。
        // let p = UnsafeMutablePointer<Double>(&buffer)
        // 以下サイトを参考に、withUnsafe...を使う方法に書き換えた。
        // https://qiita.com/Satachito/items/4c39c9b06304e4d86660
        
        // アンセーフミュータブルポインターを作成。こちらは変更も可能。（& は必須！）
        // let p = UnsafeMutablePointer<Double>(&buffer)
        // アンセーフポインタを作成。こちらは参照用。（ & はつけてはいけない！ ）
        // var q = UnsafePointer<Double>(buffer)
        
        let p = buffer.withUnsafeMutableBufferPointer { $0.baseAddress! }
        var q = buffer.withUnsafeBufferPointer { $0.baseAddress! }
        print(p.pointee, p[3])  // "0.01 31.9" が表示される
        
        // p は定数だが参照先に代入可能
        p[2] = 100.0
        // ポインタを２つ分進める
        q += 2
        print( q.pointee )      // "100.0" が表示される
        
        
        // 以降は純粋な初期化
        for i in 0..<100000 {
            sampleList.append(.init())
        }
    }
    
    /* memo: ポインターアクセスによる参照の高速化
     普通に添字で配列をループするよりも、ポインターで回した方が高速にアクセスできるらしい。
     
     参考文献：https://ameblo.jp/13703600/entry-12648943179.html
     
     ----
     ・基本的に、添字アクセスは非効率な模様
     ・for よりも while のほうが早い
     ・class のオブジェクトよりも struct にアクセスするほうが早い
     
     */
    func loopTest() {
        
        // UnsafeMutablePointer を使用したケース。
        // 0.0013840198516845703 -> 普通の添字参照よりも10倍速い
        queue.async {
            let startDate = Date()
            var ptr = UnsafeMutablePointer<SampleModel>(&self.sampleList)
            let endPtr = ptr + self.sampleList.count
            
            while ptr < endPtr {
                ptr.pointee.id = "reset!!!"
                ptr += 1
            }
            
            print(Date().timeIntervalSince(startDate))
        }
        
        // ポインターを使用したケースだが、添字で参照した場合
        // 0.0063010454177856445 -> 普通の添字参照よりは速いが、上記のポインタ参照と比べると５倍遅い
        queue.async {
            let startDate = Date()
            var ptr = UnsafeMutablePointer<SampleModel>(&self.sampleList)
            
            var index = 0
            
            while index < self.sampleList.count {
                ptr[index].id = "reset!!!"
                index += 1
            }
            
            print(Date().timeIntervalSince(startDate))
        }

        
        queue.async {
            // ちゃんと配列が変わっている確認
            print(self.sampleList.first?.id)
        }
        
        /// 普通の添字参照。
        /// 0.013442039489746094 -> ポインタの参照と比べると遅い
        queue.async {
            let startDate = Date()
            var index = 0
            while index < self.sampleList.count {
                self.sampleList[index].id = "hoge!!!"
                index += 1
            }
            
            print(Date().timeIntervalSince(startDate))
        }
        
        /// 配列からforで取り出す方式。
        /// 0.032099008560180664 -> 一番遅い
        /*
        queue.async {
            let startDate = Date()
            
            for model in self.sampleList {
                // imutableなので書き換えられない
            }
            
            print(Date().timeIntervalSince(startDate))
        }
         */
        
        queue.async {
            // ちゃんと配列が変わっている確認
            print(self.sampleList.first?.id)
        }
        
        // TODO: SIMD pointer access? がかなり高速なようなのでこちらを使ってみる
    }
    
}
