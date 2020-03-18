//
//  ViewController.swift
//  RealmSwiftSample
//
//  Created by 岡崎伸也 on 2020/03/19.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    var parentObjectModel : ParentObject? = nil
    var parentUnit : ParentObject? = nil
    
    var childObjectModel : ChildObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        childObjectModel = ChildObject()
        //childObjectModel?.debug()
        
        parentObjectModel = ParentObject()
        //parentObjectModel?.debug()
        
        parentUnit = parentObjectModel?.getUnit()
        print(parentUnit)
        
        
        //issue()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var subViewController = UIStoryboard(name: "SubViewController", bundle: nil).instantiateInitialViewController() as! SubViewController
        subViewController.parentObject = parentUnit

        self.present(subViewController, animated: true, completion: nil)
    }

}

