//
//  SearchViewController.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/04/04.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import APIKit
import Himotoki
import Nuke
import RealmSwift
//po Realm.Configuration.defaultConfiguration.fileURL
//FinderでShift+Cmd+gで絶対パスを指定


class SearchViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, ArticleCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    var testSearchBar: UISearchBar!
    var articles: [Article] = []
    var searchQuery: String = ""
    
    ////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        //何も入力されていなくてもReturnキーを押せるようにする。
        testSearchBar.enablesReturnKeyAutomatically = true
        //XibとCellのReuseIdentifierを登録する
        self.tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    /////////////////////////////////////////////////////////////
    //*各種メソッド
    /////////////////////////////////////////////////////////////
    //検索ボタン押下時の呼び出しメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        testSearchBar.endEditing(true)
        articles.removeAll()
        getArticles()
        tableView.reloadData()
    }
    

    /*JSON型のデータを取得し、structに変換、配列に格納するメソッド*/
    func getArticles() {
        var encodedQuery = ""
        var targetUrl = ""
        
        searchQuery = testSearchBar.text!
        encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        targetUrl = "https://qiita.com/api/v2/items?page=1&per_page=10&query=title%3A\(encodedQuery)"
        
        guard let url = URL(string: targetUrl) else {
            print("無効なURL")
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            guard let object: Any = response.result.value else { return }
            
            let json = JSON(object)
            json.forEach { (_, json) in
                let risouTags = json["tags"].array!.map { $0["name"].string! }
                
                let article = Article (
                    title: json["title"].string!,
                    authorName: json["user"]["id"].string!,
                    authorImageUrl: json["user"]["profile_image_url"].string!,
                    goodCnt: json["likes_count"].int!,
                    tags: risouTags,
//                    tag1: json["tags"][0]["name"].string,
//                    tag2: json["tags"][1]["name"].string,
//                    tag3: json["tags"][2]["name"].string,
                    url: json["url"].string!,
                    id: json["id"].string!
                )
                self.articles.append(article)
            }
            self.tableView.reloadData()
        }
    }
    
    /*データの個数を返すメソッド*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    /*データを返すメソッド*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        // セルのプロパティに記事情報を設定する
        let article: Article = articles[indexPath.row]
        //タイトルラベルを設定
        let attributedString = NSMutableAttributedString(string: article.title)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 9
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        cell.title.attributedText = attributedString
        cell.title.lineBreakMode = NSLineBreakMode.byTruncatingTail
        cell.title.numberOfLines = 2
        cell.title.textAlignment = NSTextAlignment.left
        //その他のラベルを設定
        cell.author.text = article.authorName
        Manager.shared.loadImage(with: URL(string: article.authorImageUrl)!, into: cell.authorIcon)
        cell.goodCnt.text = String(article.goodCnt)
//        cell.tag1.text = article.tag1
//        cell.tag2.text = article.tag2
//        cell.tag3.text = article.tag3
        cell.tagListView.removeAllTags()
        cell.tagListView.addTags(article.tags)
        
        cell.delegate = self
        return cell
    }
    
    
    
 
    /*記事詳細detailViewに遷移させるメソッド*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController: DetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//        detailViewController.entry = articles[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    // MARK: - setupSearchBarメソッド
    private func setupSearchBar() {
        if let navigationBarFrame = navigationController?.navigationBar.bounds {
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = "Search"
            searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            searchBar.keyboardType = UIKeyboardType.default
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.testSearchBar = searchBar
            searchBar.becomeFirstResponder()
        }
    }
    
    
    /*あとで読むRealmに記事を追加するメソッド*/
    func addReadLater(cell: UITableViewCell) {
        //タップされたcellのindexPath.row（tableViewの何行目か）を取得する
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        //そこから対応している記事を取得し
        let article: Article = articles[indexPath.row]
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
