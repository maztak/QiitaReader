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
    var tags: [String]
    var url: String
    var id: String
}


class RealmArticle: Object {
    @objc dynamic var title = String()
    @objc dynamic var authorName = String()
    @objc dynamic var authorImageUrl = String()
    @objc dynamic var goodCnt = Int()
    var tagList = List<String>()
    @objc dynamic var url = String()
    @objc dynamic var id =  String()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}


