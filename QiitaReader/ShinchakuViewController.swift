//
//  ShinchakuViewController.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/03/09.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ShinchakuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var articles: [Article] = [] //記事を入れるプロパティarticles:構造体の配列
    
    //////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        Alamofire.request("https://qiita.com/api/v2/items").responseJSON { response in
                guard let object = response.result.value else { //guard letで引数responseのvalueプロパティをnil剥がして、定数objectに入れる
                    return
                }
                
                let json = JSON(object) //object（1つの記事）をJSON型に変換？し、定数jsonに入れる
                json.forEach { (_, json) in //JOSN型の定数jsonの各要素をforEachで呼び出し、それらを構造体Articleの引数とし
                    let article = Article ( //articleを生成していく
                        title: json["title"].string!,
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
    
    
    /*TableViewに表示する記事数を返すメソッド*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    /*tableViewCellを生成し、値を設定し、そのセルを返すメソッド*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得（生成？）する
        let cell: ArticleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        // セルのプロパティに記事情報を設定する
        let article: Article = articles[indexPath.row]
        cell.title.text = article.title
        cell.author.text = article.authorName
        return cell
    }
    
    /*記事詳細detailViewに遷移させるメソッド*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController: DetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.entry = articles[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
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


