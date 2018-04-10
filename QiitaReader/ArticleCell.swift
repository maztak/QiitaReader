//
//  ArticleCell.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/03/26.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit

//protocol ArticleCellDelegate { //試験的に追加
//    func addReadLater(article: RealmTest3)  //引数はテキトーなので、これでいいかは分からん
//}

class ArticleCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var goodCnt: UILabel!
    @IBOutlet weak var tag1: UILabel!
    @IBOutlet weak var tag2: UILabel!
    @IBOutlet weak var tag3: UILabel!
    @IBOutlet weak var authorIcon: UIImageView!
//    var delegate: ArticleCellDelegate? = nil //プロパティだけど、メソッドを持つので関数プロパティ
    
//    @IBAction func readLaterButtonTapped(_ sender: Any) {
//        delegate?.addReadLater(article: RealmTest3 )
//    }
    
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


