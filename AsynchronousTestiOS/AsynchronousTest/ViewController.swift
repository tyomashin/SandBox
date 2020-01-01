//
//  ViewController.swift
//  AsynchronousTest
//
//  Created by 岡崎伸也 on 2019/09/09.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        alamofireEasySample()
    }
    
    func alamofireEasySample(){
        // https://rara-world.com/cocoapods-alamofire-swift/
        Alamofire.request("https://randomuser.me/api").responseJSON{
            res in
            if res.result.isSuccess{
                if let returnValue = res.result.value{
                    print(JSON(returnValue))
                }
            }else{
                print("ERROR!")
            }
        }
    }


}

