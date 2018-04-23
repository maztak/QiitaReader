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
}

let article1 = Article(title: "title", authorName: "author", authorImageUrl: "https://qiita-image-store.s3.amazonaws.com/0/83914/profile-images/1474114026", goodCnt: 42, tag1: "testTag1", tag2: "testTag2", tag3: "testTag3", url: "https://qiita.com/on0z/items/9768d2bccc29cc4e1851")

class RealmArticle: Object {
    @objc dynamic var title = String()
    @objc dynamic var authorName = String()
    @objc dynamic var authorImageUrl = String()
    @objc dynamic var goodCnt = Int()
    @objc dynamic var tag1: String? = String()
    @objc dynamic var tag2: String? = String()
    @objc dynamic var tag3: String? = String()
    @objc dynamic var url = String()
}
