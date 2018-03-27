//
//  ShinchakuViewController.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/03/09.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit
import Alamofire    //Alamofireをimport

class ShinchakuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let fruits = [article1, article2]
    
    //////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getArticles()
        self.tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //////////////////////////////////////////////////////////////////////////
    /*記事を取得する*/
    func getArticles() {
        Alamofire.request("https://qiita.com/api/v2/items") //APIへリクエストを送信
            .responseJSON { response in
                print(response.result.value) // responseのresultプロパティのvalueプロパティをコンソールに出力
        }
    }
    
    
    
    /*記事をTableViewに表示する*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: ArticleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        // セルに表示する値を設定する
        cell.title.text = fruits[indexPath.row].title
        cell.author.text = fruits[indexPath.row].authorName
        return cell
    }
    
    //タップされたcellをprintするメソッドを追加
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell：\(indexPath.row) article：\(fruits[indexPath.row].title) URL:\(fruits[indexPath.row].url)")
    }
}
    
    

    
    
    
    
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


