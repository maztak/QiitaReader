//
//  NewViewController.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/03/09.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit
import Alamofire    //APIで記事を取得したりするときに使う
import SwiftyJSON   //JSON型にキャストしたり、stringやintプロパティを使う
import Nuke         //サムネイル画像を表示して、キャッシュまでしてくれる
import RealmSwift

class NewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ArticleCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    var articles: [Article] = [] //記事を入れるプロパティarticles:構造体の配列
    
    //////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        //記事を取得し、tableViewをリロードする（tableViewCellは、下にfuncを記載しているから、それを勝手に実行して記事をセットしてくれるっぽい）
        getArticles()
        //使用するXibとCellのReuseIdentifierを登録する
        self.tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //////////////////////////////////////////////////////////////////////
    //*各種メソッド
    //////////////////////////////////////////////////////////////////////
    
    /*JSON型のデータを取得し、structに変換、配列に格納するメソッド*/
    func getArticles() {
        Alamofire.request("https://qiita.com/api/v2/items").responseJSON { response in
            guard let object: Any = response.result.value else { //guard letで引数responseのvalueプロパティをnil剥がして、定数objectに入れる
                return
            }
            
            let json = JSON(object) //object（1つの記事）をJSON型にキャストし、定数jsonに入れる
            json.forEach { (_, json) in //JOSN型の定数jsonの各要素をforEachで呼び出し、それらを構造体Articleの引数とし
                let article = Article ( //articleを生成していく
                    title: json["title"].string!,
                    authorName: json["user"]["id"].string!,
                    authorImageUrl: json["user"]["profile_image_url"].string!,
                    goodCnt: json["likes_count"].int!,
                    tag1: json["tags"][0]["name"].string,
                    tag2: json["tags"][1]["name"].string,
                    tag3: json["tags"][2]["name"].string,
                    url: json["url"].string!
                )
                self.articles.append(article) //それを辞書の配列であるarticlesに入れていく
            }
            self.tableView.reloadData() //TableViewを更新
        }
    }
    
    
    /*データを返すメソッド*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        // セルのプロパティに記事情報を設定する
        let article: Article = articles[indexPath.row]
        cell.title.text = article.title
        cell.author.text = article.authorName
        cell.goodCnt.text = String(article.goodCnt)
        cell.tag1.text = article.tag1
        cell.tag2.text = article.tag2
        cell.tag3.text = article.tag3
        cell.url = article.url
        cell.delegate = self
        Manager.shared.loadImage(with: URL(string: article.authorImageUrl)!, into: cell.authorIcon)
        return cell
    }
    
    
    /*データの個数を返すメソッド*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    
    /*記事詳細detailViewに遷移させるメソッド*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController: DetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.entry = articles[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    /*あとで読むボタンタップされた時のメソッド*/
    func addReadLater(cell: ArticleCell) {
        //Realmに記事を追加する処理
        let myRealm = RealmTest3(value: [
            "title" : cell.title.text!,
            "authorName": cell.author.text!,
            "authorImageUrl": cell.authorIcon!,
            "goodCnt": cell.goodCnt.text!,
            "tag1": cell.tag1.text!,
            "tag2": cell.tag2.text!,
            "tag3": cell.tag3.text!,
            "url": cell.url
            ])
        
        // デフォルトRealmを取得する(おまじない)
        let realm = try! Realm()
        
        // トランザクションを開始して、オブジェクトをRealmに追加する
        try! realm.write {
            realm.add(myRealm)
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
}

