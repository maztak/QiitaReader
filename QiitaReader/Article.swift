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


protocol QiitaRequest: Request {}

extension QiitaRequest {
    var baseURL: URL {
        return URL(string: "https://qiita.com")!
    }
}
////////////////////////////////////////
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

struct GetTrendRequest: QiitaRequest {
    var path: String
    typealias Response = [TrendByHimotoki]
    var method: HTTPMethod {
        return .get
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> GetTrendRequest.Response {
        return try decodeArray(object)
    }
}







////////////////////////////////////////
struct Tag: Himotoki.Decodable {
    let name: String
    
    static func decode(_ e: Extractor) throws -> Tag {
        return try Tag(
            name:   e <| "name"
        )
    }
}
///////////////////////////////////////
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

struct TrendByHimotoki: Himotoki.Decodable {
    let title: String
    let authorName: String
    let authorImageUrl: String
    let goodCnt: Int
    let tags: [Tag] // 変数の型をPersonの配列にする
    let url: String
    let id: String
    
    static func decode(_ e: Extractor) throws -> TrendByHimotoki {
        return try TrendByHimotoki(
            title: e <| "trendItems" <| "article" <| "title",
            authorName: e <| "trendItems" <| "article" <| ["author", "urlName"],
            authorImageUrl: e <| "trendItems" <| "article" <| ["author", "profileImageUrl"],
            goodCnt: e <| "trendItems" <| "article" <| "likesCount",
            tags: e <| "trendItems" <| "article" <|| "tags", //
            url: e <| "trendItems" <| "article" <| "showUrl",
            id: e <| "trendItems" <| "article" <| "uuid"
        )
    }
}




////////////////////////////////////////
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


