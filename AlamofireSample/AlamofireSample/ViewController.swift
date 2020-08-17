//
//  ViewController.swift
//  AlamofireSample
//
//  Created by 岡崎伸也 on 2020/08/17.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        APIClient.getQiitaList{(result, error) in
            print(error)
            print(result)
            
            guard let result = result else{
                return
            }
            print(result.count)
            /*
            for hoge in result{
                
            }
            */
        }
    }


}

