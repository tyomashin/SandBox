//
//  ViewController.swift
//  MVPSample
//
//  Created by 岡崎伸也 on 2019/10/23.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit

protocol MainInterface : class{
    func setResult()
}

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    var presenter: MainPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        presenter = MainPresenter(with: self)
    }

    /// ボタンがタップされた時にPresenterに通知する
    @IBAction func touchButton(_ sender: Any) {
        presenter?.buttonTapped()
    }
}

extension ViewController : MainInterface{
    /// Presenter から処理完了通知が届いたら描画する
    func setResult() {
        if let presenter = presenter{
            // データはPresenterが持っている
            label.text = presenter.resultList.description
            // SampleTableViewControllerに遷移する
            let storyboard: UIStoryboard = UIStoryboard(name: "SampleTable", bundle: nil)
            let nextView = storyboard.instantiateInitialViewController() as! SampleTableViewController
            self.navigationController?.pushViewController(nextView, animated: true)//遷移する
        }
    }
}

