//
//  TrendViewController.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/03/09.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Nuke


//ArticleCellDelegateプロトコルに準拠　を試験的に追加
class TrendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var articles: [Article] = [] //記事を入れるプロパティarticles:構造体の配列
    
    //////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        //記事を取得し、tableViewに記録(register)していく
        getArticles()
        self.tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //////////////////////////////////////////////////////////////////////////
    //*各種メソッド                                                          *//
    //////////////////////////////////////////////////////////////////////////
    
    /*JSON型のデータを取得し、structに変換、配列に格納するメソッド*/
    func getArticles() {
        Alamofire.request("https://qiita.com/trend.json").responseJSON { response in
            guard let object = response.result.value else { //guard letで引数responseのvalueプロパティをnil剥がして、定数objectに入れる
                return
            }
            
            let json = JSON(object)["trendItems"] //objectをJSON型にキャストし定数jsonに入れる
            json.forEach { (_, json) in //JOSN型の定数jsonの各要素をforEachで呼び出し
                let article = Article ( //articleを生成していく
                    title: json["article"]["title"].string!,
                    authorName: json["article"]["author"]["urlName"].string!,
                    authorImageUrl: json["article"]["author"]["profileImageUrl"].string!,
                    goodCnt: json["article"]["likesCount"].int!,
                    tag1: json["article"]["tags"][0]["name"].string,
                    tag2: json["article"]["tags"][1]["name"].string,
                    tag3: json["article"]["tags"][2]["name"].string,
                    url: json["article"]["showUrl"].string!
                )
                self.articles.append(article) //それを辞書の配列であるarticlesに入れていく
            }
            self.tableView.reloadData() //TableViewを更新
        }
    }
    
    
    /*TableViewに表示する記事数を返すメソッド*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    
    /*tableViewCellを生成し、値を設定し、そのセルを返すメソッド*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルをdequeueReusableCell()で取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        // セルのプロパティに記事情報を設定
        let article: Article = articles[indexPath.row]
        cell.title.text = article.title
        cell.author.text = article.authorName
        cell.goodCnt.text = String(article.goodCnt)
        cell.tag1.text = article.tag1
        cell.tag2.text = article.tag2
        cell.tag3.text = article.tag3
        
        Manager.shared.loadImage(with: URL(string: article.authorImageUrl)!, into: cell.authorIcon)
        return cell
    }
    
//    /*「あとで読む」ボタンがタップされた時のメソッド*/
//    func addReadLater(cell: UITableViewCell) {
//
//        //Realm(DataBase）にその記事情報を書き込む
//    }
    
    
    
    
    
    /*記事詳細detailViewに遷移させるメソッド*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController: DetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.entry = articles[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    
   


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


