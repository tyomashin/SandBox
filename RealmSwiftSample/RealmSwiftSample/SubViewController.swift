//
//  SubViewController.swift
//  RealmSwiftSample
//
//  Created by 岡崎伸也 on 2020/03/19.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import UIKit

class SubViewController: UIViewController {

    var parentObject : ParentObjectProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(parentObject)
        // Do any additional setup after loading the view.
        
        issue()
    }
    
    func issue(){
        //let list = parentObject!.childList
        
        DispatchQueue.global().async{
            //let hoge = self.parentObject!.childList
            //print(self.parentObject)
            let current = ParentObject.getChildList()
            print(current)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
