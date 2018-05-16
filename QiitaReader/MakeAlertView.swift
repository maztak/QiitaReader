//
//  MakeAlertView.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/05/16.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit

class MakeAlertView: UIViewController {
    
//    func makeAlertView(self: NewViewController) {
//        // Viewを生成.
//        self.myView = UIView(frame: CGRect(x: 0, y: 0, width: 220, height: 135))
//        // myViewの背景を緑色に設定.
//        self.myView.backgroundColor = UIColor.init(red: 200, green: 200, blue: 200, alpha: 1.0)
//        // 位置を中心に設定.
//        self.myView.layer.position = CGPoint(x: (self.view.frame.width)/2, y: (self.view.frame.height)/2)
//        // 角丸
//        self.myView.layer.cornerRadius = 20.0
//        self.myView.isHidden = true
//        
//        // ボタンを生成
//        self.myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
//        self.myButton.layer.position = CGPoint(x: (self.myView.frame.width)/2, y: (self.myView.frame.height)-50)
//        self.myButton.setTitle("リトライ", for: .normal)
//        self.myButton.setTitleColor(UIColor.blue, for: .normal)
//        self.myButton.addTarget(self, action: #selector(self.onClickMyButton), for: .touchUpInside)
//        self.myButton.isHidden = true
//        
//        //ラベルを生成
//        self.myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
//        self.myLabel.layer.position = CGPoint(x: (self.myView.frame.width)/2, y: (self.myView.frame.height)-100)
//        self.myLabel.textAlignment = NSTextAlignment.center
//        self.myLabel.text = "ネットワーク通信エラー"
//        self.myLabel.textColor = UIColor.black
//        self.myLabel.isHidden = true
//        
//        // myViewをviewに追加.
//        self.view.addSubview(self.myView)
//        // ボタンをviewに追加.
//        self.myView.addSubview(self.myButton)
//        // ラベルを追加
//        self.myView.addSubview(self.myLabel)
//    }
    
    
    /* リトライボタンイベント */
    @objc func onClickMyButton(sender: UIButton) {
//        // リトライ処理
//        print("Retry")
//        myView.isHidden = true
//        myButton.isHidden = true
//        myLabel.isHidden = true
//        SVProgressHUD.show()
//        getArticles()
    }

}
