//
//  ArticleData.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/03/09.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import Foundation

struct Article {
    var title: String
    var authorName: String
    var authorIcon: String
    var goodCnt: Int
    var tag1: String?
    var tag2: String?
    var tag3: String?
    var url: String
    var authorImageUrl: String
}

//サンプルデータ
//var article1 = Article (
//    title: "初心者がオリジナルのiOSアプリを開発できるようになるまで",
//    authorName: "justin999",
//    authorIcon: ".../images/1473687346.jpeg",
//    tag1: "iOS",
//    tag2: "swift",
//    tag3: "Objective-C",
//    goodCnt: "142",
//    articleText: "私はiOSアプリのフロント側を趣味や仕事で開発しています。そんな中、時折聞かれるのが「iOSアプリってどうやって開発するの？",
//    url: "https://qiita.com/justin999/items/986fe025331f077e453e"
//)
//
