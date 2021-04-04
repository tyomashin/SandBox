//
//  ViewController.swift
//  MoyaSample
//
//  Created by 岡崎伸也 on 2021/04/03.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let dataStore = WikiDataStore()
        dataStore.getWikiData(wikiCode: "Q750569")
            .subscribe(onNext: {result in
                print(result)
                switch result{
                case .success(response: let response):
                    let hoge = response.entities?["Q750569"]
                    print(hoge)
                    break
                case .commonError(error: let error):
                    break
                case .uniqueError(error: let error):
                    break
                }
            })
    }


}

