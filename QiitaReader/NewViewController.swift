//
//  NewViewController.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/03/09.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit
//import Alamofire    //APIで記事を取得したりするときに使う
import SwiftyJSON   //JSON型にキャストしたり、intプロパティ等を使う
import APIKit
import Himotoki
import Nuke         //サムネイル画像を表示して、キャッシュまでしてくれる
import RealmSwift
//po Realm.Configuration.defaultConfiguration.fileURL
//FinderでShift+Cmd+gで絶対パスを指定


class NewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ArticleCellDelegate {
    @IBOutlet weak var tableView: UITableView!
//    var articles: [Article] = []
    var refreshControl: UIRefreshControl!
    var repoArray: [ArticleByHimotoki] = [] //test
    
    ///////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        getArticles()
        //使用するXibとCellのReuseIdentifierを登録する
        self.tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
        
        //下に引っ張って更新する処理
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "下に引っ張って更新")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    @objc func refresh() {
        getArticles()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    ///////////////////////////////////////////////////////////
    //*各種メソッド
    ///////////////////////////////////////////////////////////
    /*JSON型のデータを取得し、structに変換、配列に格納するメソッド*/
    func getArticles() {
        Session.send(FetchRepositoryRequest(path: "")) { result in
            switch result {
            case .success(let response):
                print("成功：\(response)")
                self.repoArray = response
                self.tableView.reloadData()
                
            case .failure(let error):
                print("失敗：\(error)")
            }
        }
        
        
        
        //        let url = "https://qiita.com/api/v2/items"
        
        //        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { response in
        //            //guard letで引数responseのvalueプロパティをnil剥がし定数object:記事の辞書？に入れる
        //            guard let object: Any = response.result.value else { return }
        //            //objectをJSON型にキャスト <- もともとJSON型のものをなぜキャストする必要があるのかは不明
        //            let jsonObject = JSON(object)
        //            //JSON型の辞書jsObjectの各要素をforEachで呼び出し、articlesにappendしていく
        //            jsonObject.forEach { (_, json) in
        //                let risouTags = json["tags"].array!.map { $0["name"].string! }
        //
        //                let article = Article(
        //                    title: json["title"].string!,
        //                    authorName: json["user"]["id"].string!,
        //                    authorImageUrl: json["user"]["profile_image_url"].string!,
        //                    goodCnt: json["likes_count"].int!,
        //                    tags: risouTags,
        ////                    tag1: json["tags"][0]["name"].string,
        ////                    tag2: json["tags"][1]["name"].string,
        ////                    tag3: json["tags"][2]["name"].string,
        //                    url: json["url"].string!,
        //                    id: json["id"].string!
        //                )
        //                self.articles.append(article)
        //            }
        //            self.tableView.reloadData()
        //        }
    }
    
    
    /*データの個数を返すメソッド*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //    return articles.count
        return repoArray.count //test
    }
    
    
    /*TableViewにデータを返すメソッド*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //test
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        // セルのプロパティに記事情報を設定する
        let articleByHimotoki: ArticleByHimotoki = repoArray[indexPath.row]
        //タイトルラベルを設定
        let attributedString = NSMutableAttributedString(string: articleByHimotoki.title)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 9
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        cell.title.attributedText = attributedString
        cell.title.lineBreakMode = NSLineBreakMode.byTruncatingTail
        cell.title.numberOfLines = 2
        cell.title.textAlignment = NSTextAlignment.left
        //その他のラベルを設定
        cell.author.text = articleByHimotoki.authorName
        Manager.shared.loadImage(with: URL(string: articleByHimotoki.authorImageUrl)!, into: cell.authorIcon)
        cell.goodCnt.text = String(articleByHimotoki.goodCnt)
        
        let myTags = articleByHimotoki.tags.map { $0.name }
        cell.tagListView.removeAllTags()
        cell.tagListView.addTags(myTags)
        
        cell.delegate = self
        return cell
        
        
        //    // セルを取得する
        //    let cell: ArticleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        //    // セルのプロパティに記事情報を設定する
        //    let article: Article = articles[indexPath.row]
        //    //タイトルラベルを設定
        //    let attributedString = NSMutableAttributedString(string: article.title)
        //    let paragraphStyle = NSMutableParagraphStyle()
        //    paragraphStyle.lineSpacing = 9
        //    attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        //    cell.title.attributedText = attributedString
        //    cell.title.lineBreakMode = NSLineBreakMode.byTruncatingTail
        //    cell.title.numberOfLines = 2
        //    cell.title.textAlignment = NSTextAlignment.left
        //    //その他のラベルを設定
        //    cell.author.text = article.authorName
        //    Manager.shared.loadImage(with: URL(string: article.authorImageUrl)!, into: cell.authorIcon)
        //    cell.goodCnt.text = String(article.goodCnt)
        //    //        cell.tag1.text = article.tag1
        //    //        cell.tag2.text = article.tag2
        //    //        cell.tag3.text = article.tag3
        //    cell.tagListView.removeAllTags()
        //    cell.tagListView.addTags(article.tags)
        //
        //    cell.delegate = self
        //    return cell
    }
    
    
    
    
    
    /*記事詳細detailViewに遷移させるメソッド*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.entry = repoArray[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    
    /*あとで読むRealmに記事を追加するメソッド*/
    func addReadLater(cell: UITableViewCell) {
        //タップされたcellのindexPath.rowを取得する
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        //そこから対応している記事を取得し
        let article: ArticleByHimotoki = repoArray[indexPath.row]
        //その情報をrealmArticleとしてモデル作成
        let realmArticle = RealmArticle(value: [
            "title" : article.title,
            "authorName": article.authorName,
            "goodCnt": article.goodCnt,
            "tagList": article.tags,
            //            "tag1": article.tag1 ?? String(),
            //            "tag2": article.tag2 ?? String(),
            //            "tag3": article.tag3 ?? String(),
            "url": article.url,
            "authorImageUrl": article.authorImageUrl,
            "id": article.id
            ])
        // デフォルトRealmを取得する(おまじない)
        let realm = try! Realm()
        // トランザクションを開始して、オブジェクトをRealmに追加する
        try! realm.write {
            realm.add(realmArticle, update: true)
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

