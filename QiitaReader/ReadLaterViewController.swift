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
    var reversedArticles: [Article] = []
    var refreshControl: UIRefreshControl!
    
    ////////////////////////////////////////////////////////////
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        getArticles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //記事取得
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
        articles.removeAll()
        getArticles()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    /////////////////////////////////////////////////////////////
    //*各種メソッド
    /////////////////////////////////////////////////////////////
    /*realmからデータ取得しarticlesに追加*/
    func getArticles() {
        // デフォルトRealmを取得する(おまじない)
        let realm = try! Realm()
        // 記事の読み取りをする
        let object = realm.objects(RealmArticle.self) //objectはResults<RealmArticle>型　＝ [RealmArticel]型?
        print("object: \(object)")
        //objectの各要素をforEachで呼び出し、articleを生成、appendしてく
        object.forEach{ realmArticle in
            //List<String>型を[Tag]型に変換
            var castedTagList: [Tag] = []
            realmArticle.tagList.forEach { tag in
                let castedTag = Tag(name: tag)
                castedTagList.append(castedTag)
            }
            //articleを生成
            let article = SearchArticle(
                title: realmArticle.title,
                authorName: realmArticle.authorName,
                authorImageUrl: realmArticle.authorImageUrl,
                goodCnt: realmArticle.goodCnt,
                tags: castedTagList,
                url: realmArticle.url,
                id: realmArticle.id
            )
            //append
            self.articles.append(article.toArticle())
        }
        self.reversedArticles = articles.reversed()
        self.tableView.reloadData()
    }
    
    
    /*データの個数を返すメソッド*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reversedArticles.count
    }

    
    /*データを返すメソッド*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        //セルのプロパティに記事情報を設定する
        let article: Article = reversedArticles[indexPath.row]
        //タイトルラベルを設定
        let attributedString = NSMutableAttributedString(string: article.title)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 9
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        cell.title.attributedText = attributedString
        cell.title.lineBreakMode = NSLineBreakMode.byTruncatingTail
        cell.title.numberOfLines = 2
        cell.title.textAlignment = NSTextAlignment.left
        //著者アイコンを設定
        Manager.shared.loadImage(with: URL(string: article.authorImageUrl)!, into: cell.authorIcon)
        //タグを設定
        cell.tagListView.removeAllTags()
        cell.tagListView.addTags(article.tags)
        //その他のラベルを設定
        cell.author.text = article.authorName
        cell.goodCnt.text = String(article.goodCnt)
        cell.readLaterButton.isHidden = true
        return cell
    }
    
    
    
    
    /*記事詳細detailViewに遷移させるメソッド*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.entry = reversedArticles[indexPath.row]
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
