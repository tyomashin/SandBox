//
//  ViewController.swift
//  ScrollViewSample
//
//  Created by 岡崎伸也 on 2019/11/24.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewWidthConstraint: NSLayoutConstraint!
    
    var imageViewList : [UIImageView] = []
    
    var colorList : [UIColor] = [.red, .blue, .green]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    /// ScrollView にImageViewを配置する
    func setMultiImageViewInScrollView(count : Int = 3){
        for i in 0 ..< count{
            let color = colorList[i]
            let imageView = UIImageView()
            imageView.backgroundColor = color
            //scrollView.addSubview(imageView)
            containerView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            if let leadingImageView = imageViewList.last{
                setTrailingViewConstraint(leadingView: leadingImageView, trailingView: imageView)
            }else{
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
                imageView.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.5).isActive = true
                imageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
                imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
                imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            }
            imageViewList.append(imageView)
        }
        
    }
    
    /// 左のViewに対して右のViewの制約をつける
    func setTrailingViewConstraint(leadingView : UIView, trailingView : UIView){
        trailingView.widthAnchor.constraint(equalTo: leadingView.widthAnchor, multiplier: 1).isActive = true
        trailingView.heightAnchor.constraint(equalTo: leadingView.heightAnchor, multiplier: 1).isActive = true
        trailingView.topAnchor.constraint(equalTo: leadingView.topAnchor).isActive = true
        trailingView.leadingAnchor.constraint(equalTo: leadingView.trailingAnchor).isActive = true
        trailingView.bottomAnchor.constraint(equalTo: leadingView.bottomAnchor).isActive = true
    }
    
    func changeConstraint(){
        containerViewWidthConstraint.priority = UILayoutPriority(rawValue: 1)
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: CGFloat(imageViewList.count)).isActive = true
        
    }
    
    @IBAction func tapButton(_ sender: Any) {
        setMultiImageViewInScrollView()
        changeConstraint()
    }
    
}

