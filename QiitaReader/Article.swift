//
//  Article.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/04/18.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import RealmSwift

struct Article {
    var title: String
    var authorName: String
    var authorImageUrl: String
    var goodCnt: Int
    var tag1: String?
    var tag2: String?
    var tag3: String?
    var url: String
    var id: String
}


class RealmArticle: Object {
    @objc dynamic var title = String()
    @objc dynamic var authorName = String()
    @objc dynamic var authorImageUrl = String()
    @objc dynamic var goodCnt = Int()
    @objc dynamic var tag1: String? = String()
    @objc dynamic var tag2: String? = String()
    @objc dynamic var tag3: String? = String()
    @objc dynamic var url = String()
    @objc dynamic var id =  String()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
