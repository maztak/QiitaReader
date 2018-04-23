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
import Nuke

class SearchViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    var testSearchBar: UISearchBar!
    var articles: [Article] = []
//    //検索結果配列を用意
//    var searchResult = [Article]() // <- いらない？
    var searchQuery: String = ""
    
    //////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSearchBar()
        //何も入力されていなくてもReturnキーを押せるようにする。
        testSearchBar.enablesReturnKeyAutomatically = true
        //使用するXibとCellのReuseIdentifierを登録する
        self.tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    //////////////////////////////////////////////////////////////////////////
    //*各種メソッド                                                          *//
    //////////////////////////////////////////////////////////////////////////
    
    //検索ボタン押下時の呼び出しメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        testSearchBar.endEditing(true)
//        //検索結果配列を空にする。 <- いらない？
//        searchResult.removeAll()

        //ここにgetArticles()をもってくる
        getArticles()
        
        //テーブルを再読み込みする。
        tableView.reloadData()
    }
    

    
    /*JSON型のデータを取得し、structに変換、配列に格納するメソッド*/
    func getArticles() {
        //
        searchQuery = testSearchBar.text!
        let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        var targetUrl = ""
        targetUrl = "https://qiita.com/api/v2/items?page=1&per_page=10&query=title%3A\(encodedQuery!)"
        
        guard let url = URL(string: targetUrl) else {
            print("無効なURL")
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            guard let object: Any = response.result.value else {
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


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
