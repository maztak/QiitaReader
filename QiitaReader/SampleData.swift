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
    var tag1: String //後回し
    var tag2: String //後回し
    var tag3: String //後回し
    var goodCnt: String
    var articleText: String
    var url: String
}


var article1 = Article (
    title: "初心者がオリジナルのiOSアプリを開発できるようになるまで",
    authorName: "justin999",
    authorIcon: ".../images/1473687346.jpeg",
    tag1: "iOS",
    tag2: "swift",
    tag3: "Objective-C",
    goodCnt: "142",
    articleText: "私はiOSアプリのフロント側を趣味や仕事で開発しています。そんな中、時折聞かれるのが「iOSアプリってどうやって開発するの？",
    url: "https://qiita.com/justin999/items/986fe025331f077e453e"
)

var article2 = Article (
    title: "Rails Developers Meetup 2018 スライドまとめ",
    authorName: "dyoshimitsu",
    authorIcon: ".../images/1473687346.jpeg",
    tag1: "Ruby",
    tag2: "Rails",
    tag3: "RubyOnRails",
    goodCnt: "137",
    articleText: "時間 トラックA トラックB 11:10〜 安全かつ高速に進めるマイクロサービス化    Rails on Kubernetes on AWS",
    url : "https://qiita.com/dyoshimitsu/items/20a41ab656d2da80e4d9"
)
