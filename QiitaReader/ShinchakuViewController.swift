//
//  ShinchakuViewController.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/03/09.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit
import Alamofire    //Alamofireをimport
import SwiftyJSON   //SwiftyJSONをimport

class ShinchakuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
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
    /*記事を取得する -> これをstructに変換したい*/
    
//    var articles: [[String: String?]] = []  //記事を入れるプロパティarticles:辞書の配列
    var articles: [Article] = []
    
    func getArticles() {
        Alamofire.request("https://qiita.com/api/v2/items").responseJSON { response in
                guard let object = response.result.value else { //guard letで引数responseのvalueプロパティをnil剥がして、定数objectに入れる
                    return
                }
                
                let json = JSON(object) //object（1つの記事）をJSON型に変換？し、定数jsonに入れる
                json.forEach { (_, json) in //JOSN型の定数jsonをforEachで
//                    let article: [String: String?] = [  //新たに定数article:辞書を宣言していき
                    let article = Article (
                        title: json["title"].string!,  //初期値として各keyに内容（string）を割り当てていく
                        authorName: json["user"]["id"].string!,
                        authorIcon: json["user"]["profile_image_url"].string!,
                        goodCnt: json["likes_count"].int!,
                        articleText: json["body"].string!,
                        url: json["url"].string!
                    )
                    self.articles.append(article) //それを辞書の配列であるarticlesに入れていく
                }
                self.tableView.reloadData() //TableViewを更新
        }
    }
    
    
    
    /*記事をTableViewに表示する*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: ArticleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        // セルに表示する値を設定する
        let article = articles[indexPath.row]   //○行目の記事を取得し、定数article[辞書型]に代入
//        cell.title.text = article["title"]!      //記事のtitleをxibで作ったtitleラベルのtextプロパティにセット
        cell.title.text = article.title
//        cell.author.text = article["userId"]!      //記事のuserIdをauthorラベルのtextプロパティにセット
        cell.author.text = article.authorName
        return cell
    }
    
    //タップされたcellをprintするメソッドを追加
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //処理
        //print("cell：\(indexPath.row) article：\(fruits[indexPath.row].title) URL:\(fruits[indexPath.row].url)")
//    }
    
    /*①httpリクエストで記事のJSONを取得する -> OK
     ②JSONをstructに変換する*/
    /*配列articles:[["title": "初心者が〜", "userId": "justin999", ,,,]]をJSON型に変換？*/
    
    /*記事詳細detailViewに遷移するメソッド*/
//    func tableView(tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailViewController = DetailViewController()
//        detailViewController.entry = articles[indexPath.row]["title"].
//        //entryはArticle型（構造体）
//        parent!.navigationController!.pushViewController(detailViewController , animated: true)
//    }
}
    
    //参考：http://webfood.info/swift-rss-reader/#tableview

    
    
    
    
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */





