//
//  TrendViewController.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/03/09.
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


class TrendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UINavigationControllerDelegate, ArticleCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    var articles: [Article] = []
    var refreshControl: UIRefreshControl!
    var myView: UIView!
    var myButton: UIButton!
    var myLabel: UILabel!
    
    
    ///////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        //記事取得
        getArticles()
        //使用するXibとCellのReuseIdentifierを登録する
        self.tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
        //下に引っ張って更新するための設定
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "下に引っ張って更新")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        //アラートビュー（ログイン）を生成
        makeAlertView()
    }

    
    @objc func refresh() {
        getArticles()
        refreshControl.endRefreshing()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
    ///////////////////////////////////////////////////////
    //*各種メソッド
    ///////////////////////////////////////////////////////
    /*JSON型のデータを取得し、structに変換、配列に格納するメソッド*/
    func getArticles() {
        SVProgressHUD.show()
        Session.send(GetTrendRequest()) { [weak self] result in
            switch result {
            case .success(let response):
                print("成功：\(response)")
                //subviewを消す
                SVProgressHUD.dismiss()
                self?.myView.isHidden = true
                self?.myButton.isHidden = true
                self?.myLabel.isHidden = true
                //
                self?.articles = response.toArticle()
                self?.tableView.reloadData()
                
            case .failure(let error):
                print("失敗：\(error)")
                SVProgressHUD.dismiss()
                self?.myView.isHidden = false
                self?.myButton.isHidden = false
                self?.myLabel.isHidden = false

            }
        }
    }
    
   
     /*データの個数を返すメソッド*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    
    /*tableViewにデータを返すメソッド*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        // セルのプロパティに記事情報を設定
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
            "tagList": article.tags,
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
    
    
    // MARK: アラートビューを生成するメソッド
    func makeAlertView() {
        // Viewを生成.
        self.myView = UIView(frame: CGRect(x: 0, y: 0, width: 220, height: 135))
        // myViewの背景を緑色に設定.
        self.myView.backgroundColor = UIColor.init(red: 200, green: 200, blue: 200, alpha: 1.0)
        // 透明度を設定.
        //                self?.myView.alpha = 0.85
        // 位置を中心に設定.
        self.myView.layer.position = CGPoint(x: (self.view.frame.width)/2, y: (self.view.frame.height)/2)
        // 角丸
        self.myView.layer.cornerRadius = 20.0
        self.myView.isHidden = true
        
        // ボタンを生成
        self.myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        //                self?.myButton.backgroundColor = UIColor.red
        self.myButton.layer.position = CGPoint(x: (self.myView.frame.width)/2, y: (self.myView.frame.height)-50)
        self.myButton.setTitle("ログイン", for: .normal)
        self.myButton.setTitleColor(UIColor.blue, for: .normal)
        self.myButton.addTarget(self, action: #selector(self.onClickMyButton), for: .touchUpInside)
        self.myButton.isHidden = true
        
        //ラベルを生成
        self.myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        //                self?.myLabel.backgroundColor = UIColor.blue
        self.myLabel.layer.position = CGPoint(x: (self.myView.frame.width)/2, y: (self.myView.frame.height)-100)
        self.myLabel.textAlignment = NSTextAlignment.center
        self.myLabel.text = "ログインしてください"
        self.myLabel.textColor = UIColor.black
        self.myLabel.isHidden = true
        
        // myViewをviewに追加.
        self.view.addSubview(self.myView)
        // ボタンをviewに追加.
        self.myView.addSubview(self.myButton)
        // ラベルを追加
        self.myView.addSubview(self.myLabel)
    }
    
    /* ボタンイベント */
    @objc func onClickMyButton(sender: UIButton) {
        // リトライ処理
        print("ログインボタンタップ")
        self.myView.isHidden = true
        self.myButton.isHidden = true
        self.myLabel.isHidden = true
        
        let loginViewController: LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
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


