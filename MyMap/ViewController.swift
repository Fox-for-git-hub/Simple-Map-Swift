//
//  ViewController.swift
//  MyMap
//
//  Created by 工藤千寛 on 2019/11/19.
//  Copyright © 2019 工藤千寛. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController , UITextFieldDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Text Fieldのdelegate通知先を設定
        inputText.delegate = self
    }

    @IBOutlet weak var inputText: UITextField!
    
    @IBOutlet weak var dispMap: MKMapView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //キーボードを閉じる
        textField.resignFirstResponder()
        
        //入力された文字を取り出す
        if let searchKey = textField.text {
            
            //入力された文字をデバッグエリアに表示
            print(searchKey)
            
            //GLGeocoderインスタンスを取得
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(searchKey , completionHandler: { (placemarks, error) in
                
                //位置情報が存在する場合は、unwrapPlacemarksに取り出す
                if let unwrapPlacemarks = placemarks {
                    
                    //1軒目の情報を取り出す
                    if let firstPlacemark = unwrapPlacemarks.first {
                        
                        //位置情報を取り出す
                        if let location = firstPlacemark.location {
                            
                            //位置情報から緯度経度をtargetCoordinateに取り出す
                            let targetCoordinate = location.coordinate
                            
                            //緯度経度をデバッグエリアに表示
                            print(targetCoordinate)
                            
                            //MKPointAnnotationインスタンスを取得し、ピンを生成
                            let pin = MKPointAnnotation()
                            
                            //ピンの置く場所に緯度経度を設定
                            pin.coordinate = targetCoordinate
                            
                            //ピンのタイトルを設定
                            pin.title = searchKey
                            
                            //ピンを地図に置く
                            self.dispMap.addAnnotation(pin)
                            
                            //緯度軽度を中心にして、半径500mの範囲を表示
                            self.dispMap.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                            
                            
                        }
                    }
                }
                
            })
        }
        
        //デフォルト操作を行うのでtrueを返す
        return true
    }
    
    @IBAction func changeMapButton(_ sender: Any) {
        
        //mapTypeプロパティ値をトグル
        //標準 → 航空写真 → 航空写真 + 標準
        // → 3D Flyover 3D Flyover + 標準
        // → 交通機関
        if dispMap.mapType == .standard {
            dispMap.mapType = .satellite
        } else if dispMap.mapType == .satellite {
            dispMap.mapType = .hybrid
        } else if dispMap.mapType == .hybrid {
            dispMap.mapType = .satelliteFlyover
        } else if dispMap.mapType == .satelliteFlyover {
            dispMap.mapType = .hybridFlyover
        } else if dispMap.mapType == .hybridFlyover {
            dispMap.mapType = .mutedStandard
        } else {
            dispMap.mapType = .standard
        }
    }
}

