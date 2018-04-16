//
//  ReadLaterViewController.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/03/09.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit
import Nuke         //サムネイル画像を表示して、キャッシュまでしてくれる
import RealmSwift
//po Realm.Configuration.defaultConfiguration.fileURL
//FinderでShift+Cmd+gで絶対パスを指定


class ReadLaterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var articles: [Article] = []
    var refreshControl:UIRefreshControl! //下に引っ張って更新のためのプロパティ
    
    ////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        //記事を取得し、tableViewをリロードする
        getArticles()
        //使用するXibとCellのReuseIdentifierを登録する
        self.tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "下に引っ張って更新")
        self.refreshControl.addTarget(self, action: #selector(NewViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refresh()
    {
        articles = []
        getArticles()
        refreshControl.endRefreshing()
    }

    ////////////////////////////////////////////////////////////////////
    //*各種メソッド
    ////////////////////////////////////////////////////////////////////

    /*realmからデータ取得し*/
    func getArticles() {
        // デフォルトRealmを取得する(おまじない)
        let realm = try! Realm()
        let object = realm.objects(RealmArticle.self)
        print("object: \(object)")
        
        //配列？objectの各要素をforEachで呼び出し、articlesにappendしていく
        object.forEach{ realmArticle in
            let article = Article (
                title: realmArticle.title,
                authorName: realmArticle.authorName,
                authorImageUrl: realmArticle.authorImageUrl,
                goodCnt: realmArticle.goodCnt,
                tag1: realmArticle.tag1,
                tag2: realmArticle.tag2,
                tag3: realmArticle.tag3,
                url: realmArticle.url
            )
            self.articles.append(article)
        }
        self.tableView.reloadData() //TableViewを更新
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
//        cell.delegate = self
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
    
    
    
//    // モデル作成
//    //        let realmArticle = RealmArticle(value: [
//    //            "title" : "はじめてのiOS開発",
//    //            "authorName": "テスト太郎",
//    //            "authorImageUrl": "http://sampleImage",
//    //            "goodCnt": 3,
//    //            "tag1": "iOS",
//    //            "tag2": "swift",
//    //            "tag3": "Xcode",
//    //            "url": "http://test.com"
//    //            ])
//    //
//    //        // デフォルトRealmを取得する(おまじない)
//    //        let realm = try! Realm()
//    //
//    //        // トランザクションを開始して、オブジェクトをRealmに追加する
//    //        try! realm.write {
//    //            realm.add(realmArticle)
//    //        }
//
//
//
//    //読み取り部分
//    let objs = realm.objects(RealmArticle.self).filter("title == \"はじめてのiOS開発\"")
//    if let obj = objs.first {
//        print(obj)
//    }
//

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
