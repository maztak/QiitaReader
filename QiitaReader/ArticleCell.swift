//
//  ArticleCell.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/03/26.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit
import RealmSwift

protocol ArticleCellDelegate {
    func addReadLater(cell: UITableViewCell)
}


class ArticleCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var goodCnt: UILabel!
    @IBOutlet weak var tag1: UILabel!
    @IBOutlet weak var tag2: UILabel!
    @IBOutlet weak var tag3: UILabel!
    @IBOutlet weak var authorIcon: UIImageView!
//    var url: String! //追加
//    var indexPathRow: Int! //追加
    var delegate: ArticleCellDelegate? = nil //代理人（処理の委譲先）関数をもつプロパティ
    
    @IBAction func readLaterButtonTapped(_ sender: Any) {
//        ボタンからcellを取得
//        let btn: UIButton = sender
//        let cell: UITableViewCell = btn.superview as! UITableViewCell
        delegate?.addReadLater(cell: self)
    }
    
}


struct Article {
    var title: String
    var authorName: String
    var authorImageUrl: String
    var goodCnt: Int
    var tag1: String?
    var tag2: String?
    var tag3: String?
    var url: String
}


class RealmArticle: Object {
    @objc dynamic var title = ""
    @objc dynamic var authorName = ""
    @objc dynamic var authorImageUrl = ""
    @objc dynamic var goodCnt = 0
    @objc dynamic var tag1 = ""
    @objc dynamic var tag2 = ""
    @objc dynamic var tag3 = ""
    @objc dynamic var url = ""
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    //    init(article: Article) {
    //        title = article.title
    //        authorName = article.authorName
    //        authorImageUrl = article.authorImageUrl
    //        goodCnt = article.goodCnt
    //        tag1 = article.tag1!
    //        tag2 = article.tag2!
    //        tag3 = article.tag3!
    //        url = article.url
    //    }
}

//extension Article {
//    func toRealmObject() -> RealmArticle {
//        return RealmArticle(value: self)
//    }
//}



