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
//po Realm.Configuration.defaultConfiguration.fileURL
//FinderでShift+Cmd+gで絶対パスを指定


class NewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ArticleCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    var articles: [Article] = [] //記事を入れるプロパティarticles:構造体の配列
    var refreshControl:UIRefreshControl!
    
    //////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        //記事を取得し、tableViewをリロードする
        getArticles()
        //使用するXibとCellのReuseIdentifierを登録する
        self.tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        self.refreshControl.addTarget(self, action: #selector(NewViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refresh()
    {
        getArticles()
        refreshControl.endRefreshing()
    }
    
    
    ////////////////////////////////////////////////////////////////////
    //*各種メソッド
    ////////////////////////////////////////////////////////////////////
    
    /*JSON型のデータを取得し、structに変換、配列に格納するメソッド*/
    func getArticles() {
        Alamofire.request("https://qiita.com/api/v2/items").responseJSON { response in
            //guard letで引数responseのvalueプロパティをnil剥がし定数object:記事の辞書？に入れる
            guard let object: Any = response.result.value else { return }
            
            //objectをJSON型にキャスト <- もともとJSON型のものをなぜキャストする必要があるのかは不明
            let jsObject = JSON(object)
            
            //JSON型の辞書jsObjectの各要素をforEachで呼び出し、articlesにappendしていく
            jsObject.forEach { (_, json) in
                let article = Article (
                    title: json["title"].string!,
                    authorName: json["user"]["id"].string!,
                    authorImageUrl: json["user"]["profile_image_url"].string!,
                    goodCnt: json["likes_count"].int!,
                    tag1: json["tags"][0]["name"].string,
                    tag2: json["tags"][1]["name"].string,
                    tag3: json["tags"][2]["name"].string,
                    url: json["url"].string!
                )
                self.articles.append(article)
            }
            self.tableView.reloadData() //TableViewを更新
        }
    }
    
    
    /*データを返すメソッド*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: ArticleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        // セルのプロパティに記事情報を設定する
        let article: Article = articles[indexPath.row]
        cell.title.text = article.title
        cell.author.text = article.authorName
        Manager.shared.loadImage(with: URL(string: article.authorImageUrl)!, into: cell.authorIcon)
        cell.goodCnt.text = String(article.goodCnt)
        cell.tag1.text = article.tag1
        cell.tag2.text = article.tag2
        cell.tag3.text = article.tag3
        cell.delegate = self
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
    
    
    /*あとで読むRealmに記事を追加するメソッド*/
    func addReadLater(cell: UITableViewCell) {
        //タップされたcellのindexPath.row（tableViewの何行目か）を取得する
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        //そこから対応している（代入した）記事article = articles[indexPath.row]を取得し
        let article: Article = articles[indexPath.row]

        //その情報をrealmArticleとしてモデル作成
        let realmArticle = RealmArticle(value: [
            "title" : article.title,
            "authorName": article.authorName,
            "goodCnt": article.goodCnt,
            "tag1": article.tag1 ?? String(),
            "tag2": article.tag2 ?? String(),
            "tag3": article.tag3 ?? String(),
            "url": article.url,
            "authorImageUrl": article.authorImageUrl
            ])
        
        // デフォルトRealmを取得する(おまじない)
        let realm = try! Realm()
        
        // トランザクションを開始して、オブジェクトをRealmに追加する
        try! realm.write {
            realm.add(realmArticle)
        }
        
        //追加した記事をコンソールに出力（確認用）
        print(realmArticle)
        
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

