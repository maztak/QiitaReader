//
//  ArticleData.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/03/09.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import Foundation

struct article {
    var title: String
    var authorName: String
    var authorIcon: String
    var tag1: String //後回し
    var tag2: String //後回し
    var tag3: String //後回し
    var goodCnt: String
    var articleText: String
}

var article1 = article (
    title: "初心者がオリジナルのiOSアプリを開発できるようになるまで",
    authorName: "justin999",
    authorIcon: ".../images/1473687346.jpeg",
    tag1: "iOS",
    tag2: "swift",
    tag3: "Objective-C",
    goodCnt: "142",
    articleText: "私はiOSアプリのフロント側を趣味や仕事で開発しています。そんな中、時折聞かれるのが「iOSアプリってどうやって開発するの？"
)


