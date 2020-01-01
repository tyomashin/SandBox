//
//  ViewController.swift
//  ContainerViewControllerSample
//
//  Created by 岡崎伸也 on 2019/09/19.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit

/// ContainerViewに表示するViewControllerをヘッダで切り替えるサンプル
class ViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var myContainerView: UIView!
    
    /*
    var viewController2 : ViewController2? = nil //生成したContainerViewに表示するオブジェクトを保持する
    var viewController3 : ViewController3? = nil // 同上
    */
    var currentViewControllerType : ViewControllerType? = nil // 現在ContainerViewに表示しているViewController の種類
    
    var viewControllerDic : [ViewControllerType : BaseViewController?] = [
        ViewControllerType.VC2 : nil,
        ViewControllerType.VC3 : nil
    ]
    
    enum ViewControllerType : String {
        case VC2 = "ViewController2"
        case VC3 = "ViewController3"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Container View に初期画面を表示
        changeContainerView(targetType: ViewControllerType.VC2)
    }

    @IBAction func touchButton1(_ sender: Any) {
        changeContainerView(targetType: ViewControllerType.VC2)
    }
    @IBAction func touchButton2(_ sender: Any) {
        changeContainerView(targetType: ViewControllerType.VC3)
    }
    
    /// ContainerView に表示する画面を変更する
    func changeContainerView(targetType : ViewControllerType){
        // 表示中の画面が再選択されたときは何もしない
        if currentViewControllerType == targetType{
            return
        }
        // 対象のViewControllerをインスタンス化済みの場合は再利用
        if viewControllerDic[targetType]! != nil{
            removeContainerView(targetType: targetType)
            guard let targetView = viewControllerDic[targetType]??.view else {
                return
            }
            self.myContainerView.addSubview(targetView)
            currentViewControllerType = targetType
        }else{
            removeContainerView(targetType: targetType)
            let storyboard = UIStoryboard(name: targetType.rawValue, bundle: nil)
            let targetViewContoller = storyboard.instantiateInitialViewController() as! BaseViewController
            viewControllerDic[targetType] = targetViewContoller
            addChild(targetViewContoller)
            self.myContainerView.addSubview(targetViewContoller.view)
            targetViewContoller.view.frame = self.myContainerView.bounds
            targetViewContoller.didMove(toParent: self)
            currentViewControllerType = targetType
        }
    }
    /// 現在表示中の ContainerView を削除
    func removeContainerView(targetType : ViewControllerType){
        viewControllerDic[targetType]??.view.removeFromSuperview()
    }
}

