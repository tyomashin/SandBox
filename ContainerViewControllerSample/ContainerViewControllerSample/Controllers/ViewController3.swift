//
//  ViewController3.swift
//  ContainerViewControllerSample
//
//  Created by 岡崎伸也 on 2019/09/19.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController3: BaseViewController {

    @IBOutlet var rootView: UIView!
    @IBOutlet weak var containerView1: UIView!
    @IBOutlet weak var containerViewInView1: UIView!
    @IBOutlet weak var containerView2: UIView!
    @IBOutlet weak var containerViewInView2: UIView!
    @IBOutlet weak var button1: UIButton!
    
    var googleMap : GMSMapView!
    var marker : GMSMarker? = nil
    
    //緯度経度 -> 金沢駅
    let latitude: CLLocationDegrees = 36.5780574
    let longitude: CLLocationDegrees = 136.6486596
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("vc3")
        // Googlemap の初期化
        initGoogleMap()
        // CustomButton を、button1 の位置に描画する
        let customButton = CustomButton(frame: button1.frame)
        print(button1.frame)
        containerViewInView2.addSubview(customButton)
        // ボタンの制約
        customButton.trailingAnchor.constraint(equalTo: self.containerViewInView2.trailingAnchor).isActive = true
        customButton.bottomAnchor.constraint(equalTo: self.containerViewInView2.bottomAnchor).isActive = true
    }
    
    func initGoogleMap(){
        // ズームレベル.
        let zoom: Float = 15
        // カメラを生成.
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude,longitude: longitude, zoom: zoom)
        // MapViewを生成.
        googleMap = GMSMapView(frame: CGRect(x: 0, y: 0,
                                             width: self.containerViewInView2.bounds.width,
                                             height: self.containerViewInView2.bounds.height))
        // MapViewにカメラを追加.
        googleMap.camera = camera
        //マーカーの作成
        marker = GMSMarker()
        marker?.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker?.map = googleMap
        // マーカーのアイコンを設定
        let iconImage = UIImage(named: "sample-icon")!.withRenderingMode(.alwaysOriginal)
        let newWidth : CGFloat = iconImage.size.width * 2
        let newHeight : CGFloat = iconImage.size.height * 2
        let resizeIconImage = iconImage.resizeImage(image: iconImage,
                                                    scaledToSize: CGSize(width: newWidth, height: newHeight))
        let circleImage = iconImage.createCircleImage(diameter: 20, color: .red, text : "5")
        //marker?.icon = resizeIconImage
        marker?.icon = circleImage
        //viewにMapViewを追加.
        self.containerViewInView2.addSubview(googleMap)
        // map に制約をつける
        googleMap.topAnchor.constraint(equalTo: self.containerViewInView2.topAnchor).isActive = true
        googleMap.leadingAnchor.constraint(equalTo: self.containerViewInView2.leadingAnchor).isActive = true
        googleMap.trailingAnchor.constraint(equalTo: self.containerViewInView2.trailingAnchor).isActive = true
        googleMap.bottomAnchor.constraint(equalTo: self.containerViewInView2.bottomAnchor).isActive = true
    }
}

extension UIImage{
    // 画像のリサイズ
    func resizeImage(image : UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    // 円形画像を作成
    func createCircleImage(diameter: CGFloat, color: UIColor, text: String) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        // 描画開始
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        // 描画終了
        UIGraphicsEndImageContext()
        
        return img
    }
    /*
     // Todo: 画像の中にテキストを描画したい
     // 参考：https://stackoverflow.com/questions/28906914/how-do-i-add-text-to-an-image-in-ios-swift
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
       let textColor = UIColor.white
       let textFont = UIFont(name: "Helvetica Bold", size: 12)!

       let scale = UIScreen.main.scale
       UIGraphicsBeginImageContextWithOptions(image.size, false, scale)

       let textFontAttributes = [
           NSAttributedStringKey.font: textFont,
           NSAttributedStringKey.foregroundColor: textColor,
           ] as [NSAttributedStringKey : Any]
       image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))

       let rect = CGRect(origin: point, size: image.size)
       text.draw(in: rect, withAttributes: textFontAttributes)

       let newImage = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()

       return newImage!
    }
    */
    /*
    // 画像にバッチをつける
    func addNumberLabel() -> UIImage{
        
    }
    */
}
