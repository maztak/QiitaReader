//
//  Article.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/04/18.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import APIKit
import Himotoki
import RealmSwift


//struct Article { //realmからのtagListの読み出し時に必要
//    var title: String
//    var authorName: String
//    var authorImageUrl: String
//    var goodCnt: Int
//    var tags: [String]
//    var url: String
//    var id: String
//}



protocol QiitaRequest: Request {}

extension QiitaRequest {
    var baseURL: URL {
        return URL(string: "https://qiita.com/api/v2/items")!
    }
}

struct GetArticleRequest: QiitaRequest {
    var path: String
    typealias Response = [ArticleByHimotoki]
    var method: HTTPMethod {
        return .get
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> GetArticleRequest.Response {
        return try decodeArray(object)
    }
}



struct Tag: Himotoki.Decodable {
    let name: String
    
    static func decode(_ e: Extractor) throws -> Tag {
        return try Tag(
            name:   e <| "name"
        )
    }
}


struct ArticleByHimotoki: Himotoki.Decodable {
    let title: String
    let authorName: String
    let authorImageUrl: String
    let goodCnt: Int
    let tags: [Tag] // 変数の型をPersonの配列にする
    let url: String
    let id: String
    
    static func decode(_ e: Extractor) throws -> ArticleByHimotoki {
        return try ArticleByHimotoki(
            title: e <| "title",
            authorName: e <| ["user", "id"],
            authorImageUrl: e <| ["user", "profile_image_url"],
            goodCnt: e <| "likes_count",
            tags: e <|| "tags", //変数の型がDecodableの場合は階層的にデコードしてくれる
            url: e <| "url",
            id: e <| "id"
        )
    }
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


