//
//  SearchViewController.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/04/04.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit
import APIKit
import Himotoki
import Nuke
import RealmSwift
import SVProgressHUD
//po Realm.Configuration.defaultConfiguration.fileURL
//FinderでShift+Cmd+gで絶対パスを指定


class SearchViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, UINavigationControllerDelegate, ArticleCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    var searchBar: UISearchBar!
    var articles: [Article] = []
    
    ////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        //検索バーを設定
        setupSearchBar()
        //何も入力されていなくてもReturnキーを押せるように設定
        searchBar.enablesReturnKeyAutomatically = true
        //tableViewに（Reusableな？）Cellを登録
        self.tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
        // BViewController自身をDelegate委託相手とする
        navigationController?.delegate = self
    }
    
    // UINavigationControllerDelegateのメソッド。遷移する直前の処理。
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print(viewController)
        // 遷移先が、OriginalViewControllerだったら……
        if let _ = viewController as? OriginalTabBarController {
            // インジケータを引っ込める
            SVProgressHUD.dismiss()
            // API通信を中止させる
            Session.cancelRequests(with: GetSearchRequest.self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            self.searchBar = searchBar
            searchBar.becomeFirstResponder()
        }
    }
    
    
    
    
    
    ///////////////////////////////////////////////////////
    // 各種メソッド
    ///////////////////////////////////////////////////////
    //検索ボタン押下時の呼び出しメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        articles.removeAll()
        getArticles()
    }
    

    /*JSON型のデータを取得し、structに変換、配列に格納するメソッド*/
    func getArticles() {
        SVProgressHUD.show()
        let searchQuery: String = searchBar.text!
        
        
        
        // TODO: ObserbleZip関数で5回Sessionを送ってみる -
        // SessionRxはノータッチ
        
        //RxSwiftを使って
        Session.rx_sendRequest(request: GetSearchRequest(query: searchQuery))
            .subscribe(onNext: { (response) in
                print("onNextで流れてきたよ")
                //subviewを消す
                SVProgressHUD.dismiss()
                self.articles = response.map { $0.toArticle() }
                self.tableView.reloadData()
            }, onError: { (error) in
                print("errorが流れてきたよ")
            }
        )

//        Session.send(GetSearchRequest(query: searchQuery)) { [weak self] result in
//            switch result {
//            case .success(let response):
//                print("成功：\(response)")
//                SVProgressHUD.dismiss()
//                self?.articles = response.map { $0.toArticle() }
//                self?.tableView.reloadData()
//
//            case .failure(let error):
//                print("失敗：\(error)")
//                SVProgressHUD.dismiss()
//            }
//        }
    }
    
    
    /*データの個数を返すメソッド*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    
    /*tableViewにデータを返すメソッド*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        // セルのプロパティに記事情報を設定する
        let article = articles[indexPath.row]
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
        //セルのデリゲートをViewControllerに設定
        cell.delegate = self
        return cell
    }
    
    
 
    /*記事詳細detailViewに遷移させるメソッド*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.entry = articles[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    
    /*あとで読むRealmに記事を追加するメソッド*/
    func addReadLater(cell: UITableViewCell) {
        //タップされたcellのindexPath.row（tableViewの何行目か）を取得する
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        //そこから対応している記事を取得し
        let article = articles[indexPath.row]
        //その情報をrealmArticleとしてモデル作成
        let realmArticle = RealmArticle(
            value: [
                "title" : article.title,
                "authorName": article.authorName,
                "goodCnt": article.goodCnt,
                "tagList": article.tags,
                "url": article.url,
                "authorImageUrl": article.authorImageUrl,
                "id": article.id
            ]
        )
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
