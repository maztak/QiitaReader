////
////  MakeAlertView.swift
////  QiitaReader
////
////  Created by Takuya Matsuda on 2018/05/16.
////  Copyright © 2018年 mycompany. All rights reserved.
////
//
//import UIKit
//
//class MakeAlertView: UIViewController {
//    
//    public func makeAlertView(viewController: UIViewController) {
//        var myView: UIView!
//        var myButton: UIButton!
//        var myLabel: UILabel!
//        
//        // Viewを生成.
//        viewController.myView = UIView(frame: CGRect(x: 0, y: 0, width: 220, height: 135))
//        // myViewの背景を緑色に設定.
//        viewController.myView.backgroundColor = UIColor.init(red: 200, green: 200, blue: 200, alpha: 1.0)
//        // 透明度を設定.
//        //                viewController?.myView.alpha = 0.85
//        // 位置を中心に設定.
//        viewController.myView.layer.position = CGPoint(x: (viewController.view.frame.width)/2, y: (viewController.view.frame.height)/2)
//        // 角丸
//        viewController.myView.layer.cornerRadius = 20.0
//        viewController.myView.isHidden = true
//        
//        // ボタンを生成
//        viewController.myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
//        //                viewController?.myButton.backgroundColor = UIColor.red
//        viewController.myButton.layer.position = CGPoint(x: (viewController.myView.frame.width)/2, y: (viewController.myView.frame.height)-50)
//        viewController.myButton.setTitle("リトライ", for: .normal)
//        viewController.myButton.setTitleColor(UIColor.blue, for: .normal)
//        viewController.myButton.addTarget(viewController, action: #selector(viewController.onClickMyButton), for: .touchUpInside)
//        viewController.myButton.isHidden = true
//        
//        //ラベルを生成
//        viewController.myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
//        //                viewController?.myLabel.backgroundColor = UIColor.blue
//        viewController.myLabel.layer.position = CGPoint(x: (viewController.myView.frame.width)/2, y: (viewController.myView.frame.height)-100)
//        viewController.myLabel.textAlignment = NSTextAlignment.center
//        viewController.myLabel.text = "ネットワーク通信エラー"
//        viewController.myLabel.textColor = UIColor.black
//        viewController.myLabel.isHidden = true
//        
//        // myViewをviewに追加.
//        viewController.view.addSubview(viewController.myView!)
//        // ボタンをviewに追加.
//        viewController.myView?.addSubview(viewController.myButton!)
//        // ラベルを追加
//        viewController.myView?.addSubview(viewController.myLabel!)
//        
//    }
//    
//    
//    /* リトライボタンイベント */
//    @objc func onClickMyButton(sender: UIButton) {
////        // リトライ処理
////        print("Retry")
////        myView.isHidden = true
////        myButton.isHidden = true
////        myLabel.isHidden = true
////        SVProgressHUD.show()
////        getArticles()
//    }
//
//}
