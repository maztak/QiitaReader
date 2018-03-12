//
//  ViewController.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/03/09.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //テーブルビュー
    @IBOutlet var table :UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Table View　のDataSouce参照先指定R
        table.dataSouce = self
        //Table Viewタップ時のdelegate先を指定
        table.delegate = self
        
        
        //記事情報の取得先（最初は別で用意した配列から取得する形を目指す）
        var titleLabel = article.title //titleLabelに記事1のタイトルを代入
        print("\(titleLabel)")

        

        
        //Qiitaサーバーに対してHTTP通信のリクエストを出してデータを取得
        //let requestUrl = "https://qiita.com/api/v2/items"
        
        
        //新着記事一覧データを格納する配列
        //var shinchakuDataArray = NSArray()
        
        
        
        //新着記事データをテーブルビューに表示
        }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

